"""Build the Terminal Lockdown airport vertical slice inside UEFN.

The script is deliberately idempotent.  Every generated actor has a stable
``TL_`` label, so rerunning the script updates the intended object instead of
silently duplicating it.  Static geometry is duplicated from the blank
project's already-validated ``GridPlane1`` actor.  This avoids restricted
Fortnite hard references while still providing resizable collision geometry.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
ASSETS = unreal.EditorAssetLibrary

EXPECTED_LEVEL_TOKEN = "AirportSecurity"
BUILD_PREFIX = "TL_"
PROOF_PREFIX = "TL_PROOF_"

BUTTON_CLASS_PATH = "/CreativeCoreDevices/Device_Button_V2.Device_Button_V2_C"
HUD_CLASS_PATH = "/CreativeCoreDevices/Device_HUDMessage_V2.Device_HUDMessage_V2_C"
CHARACTER_CLASS_PATH = "/CRD_Mannequin/Device_Character_V2.Device_Character_V2_C"
BILLBOARD_CLASS_PATH = "/CreativeCoreDevices/Device_Billboard_V2.Device_Billboard_V2_C"
VERSE_CLASS_PATH = "/AirportSecurity/_Verse.terminal_lockdown_controller"

GRID_SOURCE_WIDTH = 512.0
GRID_SOURCE_THICKNESS = 32.0


def all_actors():
    return list(ACTORS.get_all_level_actors())


def actor_by_label(label):
    for actor in all_actors():
        if actor.get_actor_label() == label:
            return actor
    return None


def organize(actor, folder):
    try:
        actor.set_folder_path(unreal.Name(f"TerminalLockdown/{folder}"))
    except Exception:
        pass


def set_transform(actor, location, rotation=(0.0, 0.0, 0.0), scale=(1.0, 1.0, 1.0)):
    actor.set_actor_location(unreal.Vector(*location), False, False)
    actor.set_actor_rotation(unreal.Rotator(*rotation), False)
    actor.set_actor_scale3d(unreal.Vector(*scale))


def place_box(label, center, size, folder="Architecture"):
    """Duplicate the validated grid actor at a requested center and size."""
    actor = actor_by_label(label)
    created = actor is None
    if actor and actor.get_class().get_path_name() != GRID_SOURCE.get_class().get_path_name():
        if not ACTORS.destroy_actor(actor):
            raise RuntimeError(f"Failed to replace invalid geometry actor {label}")
        actor = None
        created = True
    sx, sy, sz = size
    cx, cy, cz = center
    # GridPlane's validated mesh uses a corner/top pivot.  At unit scale its
    # bounds are x=[0,512], y=[-512,0], z=[-32,0].
    location = (cx - sx / 2.0, cy + sy / 2.0, cz + sz / 2.0)
    scale = (
        sx / GRID_SOURCE_WIDTH,
        sy / GRID_SOURCE_WIDTH,
        sz / GRID_SOURCE_THICKNESS,
    )
    if created:
        actor = ACTORS.duplicate_actor(GRID_SOURCE, None, unreal.Vector())
        if not actor:
            raise RuntimeError(f"Failed to place geometry actor {label}")
        actor.set_actor_label(label)
    set_transform(actor, location, scale=scale)
    organize(actor, folder)
    return actor, created


def place_device(label, actor_class, location, rotation=(0.0, 0.0, 0.0), folder="Gameplay"):
    actor = actor_by_label(label)
    created = actor is None
    if created:
        actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*location))
        if not actor:
            raise RuntimeError(f"Failed to place device actor {label}")
        actor.set_actor_label(label)
    set_transform(actor, location, rotation=rotation)
    organize(actor, folder)
    return actor, created


def place_verse_device(label, location):
    actor = actor_by_label(label)
    created = actor is None
    if created:
        actor = ACTORS.spawn_actor_from_object(VERSE_CLASS, unreal.Vector(*location))
        if not actor:
            raise RuntimeError(f"Failed to place Verse device actor {label}")
        actor.set_actor_label(label)
    set_transform(actor, location)
    organize(actor, "Gameplay")
    return actor, created


world = unreal.EditorLevelLibrary.get_editor_world()
world_path = world.get_path_name() if world else "<none>"
if EXPECTED_LEVEL_TOKEN.lower() not in world_path.lower():
    raise RuntimeError(
        f"Refusing build: expected a {EXPECTED_LEVEL_TOKEN} world, got {world_path}"
    )

GRID_SOURCE = actor_by_label("GridPlane1")
BUTTON_CLASS = unreal.load_class(None, BUTTON_CLASS_PATH)
HUD_CLASS = unreal.load_class(None, HUD_CLASS_PATH)
CHARACTER_CLASS = unreal.load_class(None, CHARACTER_CLASS_PATH)
BILLBOARD_CLASS = unreal.load_class(None, BILLBOARD_CLASS_PATH)
VERSE_CLASS = unreal.load_object(None, VERSE_CLASS_PATH)
if (
    not GRID_SOURCE
    or not BUTTON_CLASS
    or not HUD_CLASS
    or not CHARACTER_CLASS
    or not BILLBOARD_CLASS
    or not VERSE_CLASS
):
    raise RuntimeError(
        "A verified build dependency failed to load: "
        f"grid_source={bool(GRID_SOURCE)}, button={bool(BUTTON_CLASS)}, "
        f"hud={bool(HUD_CLASS)}, character={bool(CHARACTER_CLASS)}, "
        f"billboard={bool(BILLBOARD_CLASS)}, verse={bool(VERSE_CLASS)}"
    )

deleted_proofs = 0
for candidate in all_actors():
    if candidate.get_actor_label().startswith(PROOF_PREFIX):
        if ACTORS.destroy_actor(candidate):
            deleted_proofs += 1

created_labels = []
updated_labels = []


def record(label, result):
    _actor, created = result
    (created_labels if created else updated_labels).append(label)
    return _actor


# ---------------------------------------------------------------------------
# Terminal shell and landmark silhouettes
# ---------------------------------------------------------------------------
BOXES = [
    # Foundation and approach plaza.
    ("TL_GEO_ApproachPlaza", (-1700, 0, 24), (1800, 2600, 48), "SafeZone"),
    ("TL_GEO_TerminalFloor", (2500, 0, 32), (7800, 7600, 64), "Architecture"),
    ("TL_GEO_ExitConcourseFloor", (6700, 0, 40), (2200, 3600, 80), "Architecture"),
    # Outer walls; west face has a generous passenger entrance opening.
    # The north wall is a low sill so the validated terminal gains a readable
    # runway/window wall without discarding the existing shell.
    ("TL_GEO_WallNorth", (2500, 3830, 150), (8000, 80, 300), "Architecture"),
    ("TL_GEO_WallSouth", (2500, -3830, 650), (8000, 80, 1300), "Architecture"),
    ("TL_GEO_WallWestNorth", (-1500, 2830, 650), (80, 2000, 1300), "Architecture"),
    ("TL_GEO_WallWestSouth", (-1500, -2830, 650), (80, 2000, 1300), "Architecture"),
    ("TL_GEO_WallEastNorth", (6500, 2870, 650), (80, 1900, 1300), "Architecture"),
    ("TL_GEO_WallEastSouth", (6500, -2870, 650), (80, 1900, 1300), "Architecture"),
    # Terminal sign/canopy and ceiling ribs make the airport readable at a glance.
    ("TL_GEO_EntryCanopy", (-1300, 0, 1100), (700, 2800, 120), "Landmarks"),
    ("TL_GEO_EntrySign", (-1420, 0, 1450), (100, 2100, 420), "Landmarks"),
    ("TL_GEO_RoofRibA", (0, 0, 1320), (120, 7500, 120), "Architecture"),
    ("TL_GEO_RoofRibB", (2000, 0, 1320), (120, 7500, 120), "Architecture"),
    ("TL_GEO_RoofRibC", (4000, 0, 1320), (120, 7500, 120), "Architecture"),
    ("TL_GEO_RoofRibD", (6000, 0, 1320), (120, 7500, 120), "Architecture"),
    ("TL_GEO_RoofCrossNorth", (2500, 2600, 1320), (7800, 100, 100), "Architecture"),
    ("TL_GEO_RoofCrossCenter", (2500, 0, 1320), (7800, 100, 100), "Architecture"),
    ("TL_GEO_RoofCrossSouth", (2500, -2600, 1320), (7800, 100, 100), "Architecture"),
    # Briefing desk and security command feature.
    ("TL_GEO_BriefingDesk", (-650, 0, 140), (700, 1900, 280), "Stations"),
    ("TL_GEO_BriefingBackwall", (-250, 0, 650), (100, 2400, 900), "Stations"),
    ("TL_GEO_CommandHeader", (-150, 0, 1180), (160, 2600, 180), "Landmarks"),
    # Lane divider spine.
    ("TL_GEO_LaneDivider", (1800, 0, 105), (3600, 90, 210), "Lanes"),
    # Two scan arches (south and north).
    ("TL_GEO_ScanSouthLeft", (1050, -1760, 460), (140, 180, 920), "Stations"),
    ("TL_GEO_ScanSouthRight", (1050, -840, 460), (140, 180, 920), "Stations"),
    ("TL_GEO_ScanSouthTop", (1050, -1300, 900), (140, 1100, 120), "Stations"),
    ("TL_GEO_ScanNorthLeft", (1050, 840, 460), (140, 180, 920), "Stations"),
    ("TL_GEO_ScanNorthRight", (1050, 1760, 460), (140, 180, 920), "Stations"),
    ("TL_GEO_ScanNorthTop", (1050, 1300, 900), (140, 1100, 120), "Stations"),
    # Baggage conveyors and inspection tables.
    ("TL_GEO_BagBeltSouth", (2200, -1300, 150), (1500, 650, 300), "Stations"),
    ("TL_GEO_BagBeltNorth", (2200, 1300, 150), (1500, 650, 300), "Stations"),
    ("TL_GEO_DocDesk", (3250, 0, 170), (850, 1700, 340), "Stations"),
    ("TL_GEO_DecisionDesk", (4350, 0, 170), (900, 2500, 340), "Stations"),
    ("TL_GEO_DecisionHeader", (4550, 0, 900), (120, 2700, 180), "Landmarks"),
    # Secondary inspection room.
    ("TL_GEO_SecondaryWallWest", (4700, 2800, 580), (80, 1700, 1160), "Rooms"),
    ("TL_GEO_SecondaryWallEast", (6100, 2800, 580), (80, 1700, 1160), "Rooms"),
    ("TL_GEO_SecondaryWallNorth", (5400, 3610, 580), (1480, 80, 1160), "Rooms"),
    ("TL_GEO_SecondaryTable", (5400, 2750, 150), (850, 850, 300), "Stations"),
    ("TL_GEO_SecondaryHeader", (5400, 2000, 980), (1500, 100, 220), "Landmarks"),
    # Emergency response wing.
    ("TL_GEO_ResponseWallSouth", (5500, -2300, 580), (2100, 80, 1160), "Rooms"),
    ("TL_GEO_ResponseWallEast", (6480, -3000, 580), (80, 1480, 1160), "Rooms"),
    ("TL_GEO_ResponseConsole", (5650, -3000, 180), (1150, 700, 360), "Stations"),
    ("TL_GEO_ResponseHeader", (5500, -2200, 980), (2200, 100, 220), "Landmarks"),
    # Upgrade kiosk and end-of-shift plaza.
    ("TL_GEO_UpgradeKiosk", (7150, -1100, 300), (650, 650, 600), "Stations"),
    ("TL_GEO_UpgradeHeader", (7150, -1100, 780), (800, 800, 160), "Landmarks"),
    ("TL_GEO_ExitGateLeft", (7250, 550, 530), (160, 180, 1060), "Landmarks"),
    ("TL_GEO_ExitGateRight", (7250, 1650, 530), (160, 180, 1060), "Landmarks"),
    ("TL_GEO_ExitGateTop", (7250, 1100, 1020), (160, 1280, 120), "Landmarks"),
    # Waiting-area carpet and multi-row seating, kept north of the public lane.
    ("TL_GEO_WaitingCarpet", (2300, 3150, 78), (4300, 1050, 28), "WaitingArea"),
    ("TL_GEO_SeatRow1Back", (900, 3120, 280), (900, 90, 420), "WaitingArea"),
    ("TL_GEO_SeatRow1Base", (900, 2970, 150), (900, 360, 120), "WaitingArea"),
    ("TL_GEO_SeatRow2Back", (2100, 3120, 280), (900, 90, 420), "WaitingArea"),
    ("TL_GEO_SeatRow2Base", (2100, 2970, 150), (900, 360, 120), "WaitingArea"),
    ("TL_GEO_SeatRow3Back", (3300, 3120, 280), (900, 90, 420), "WaitingArea"),
    ("TL_GEO_SeatRow3Base", (3300, 2970, 150), (900, 360, 120), "WaitingArea"),
    # Window wall, exterior apron, and an original primitive aircraft silhouette.
    ("TL_GEO_WindowTopBeam", (2500, 3810, 1240), (8000, 100, 120), "WindowWall"),
    ("TL_GEO_WindowPaneA", (-800, 3790, 760), (1200, 50, 820), "WindowWall"),
    ("TL_GEO_WindowPaneB", (600, 3790, 760), (1200, 50, 820), "WindowWall"),
    ("TL_GEO_WindowPaneC", (2000, 3790, 760), (1200, 50, 820), "WindowWall"),
    ("TL_GEO_WindowPaneD", (3400, 3790, 760), (1200, 50, 820), "WindowWall"),
    ("TL_GEO_WindowPaneE", (4800, 3790, 760), (1200, 50, 820), "WindowWall"),
    ("TL_GEO_WindowPaneF", (6200, 3790, 760), (500, 50, 820), "WindowWall"),
    ("TL_GEO_RunwayApron", (2500, 4850, 45), (9000, 1900, 90), "Exterior"),
    ("TL_GEO_AircraftBody", (2800, 4750, 430), (3000, 360, 420), "Exterior"),
    ("TL_GEO_AircraftNose", (4450, 4750, 430), (500, 300, 360), "Exterior"),
    ("TL_GEO_AircraftTail", (1050, 4750, 680), (420, 280, 700), "Exterior"),
    ("TL_GEO_AircraftWingLeft", (2750, 4250, 420), (1300, 900, 90), "Exterior"),
    ("TL_GEO_AircraftWingRight", (2750, 5250, 420), (1300, 900, 90), "Exterior"),
    # Restricted corridor and power room along the south support edge.
    ("TL_GEO_CorridorFloor", (2450, -3320, 80), (3100, 720, 32), "RestrictedCorridor"),
    ("TL_GEO_CorridorRail", (2450, -2860, 330), (3100, 80, 660), "RestrictedCorridor"),
    ("TL_GEO_PowerWallWest", (3350, -3340, 560), (80, 1000, 1120), "PowerRoom"),
    ("TL_GEO_PowerWallEast", (4550, -3340, 560), (80, 1000, 1120), "PowerRoom"),
    ("TL_GEO_PowerWallNorth", (3950, -2860, 560), (1280, 80, 1120), "PowerRoom"),
    ("TL_GEO_PowerConsole", (3950, -3420, 230), (680, 380, 460), "PowerRoom"),
    ("TL_GEO_PowerCabinetA", (3500, -3530, 380), (280, 260, 760), "PowerRoom"),
    ("TL_GEO_PowerCabinetB", (4400, -3530, 380), (280, 260, 760), "PowerRoom"),
    # Security office/control surfaces share the proved response wing.
    ("TL_GEO_OfficeFloor", (5550, -3100, 82), (1650, 1250, 36), "SecurityOffice"),
    ("TL_GEO_OfficeDesk", (5550, -3230, 190), (1050, 430, 380), "SecurityOffice"),
    ("TL_GEO_OfficeMonitorA", (5250, -3440, 560), (300, 60, 280), "SecurityOffice"),
    ("TL_GEO_OfficeMonitorB", (5600, -3440, 560), (300, 60, 280), "SecurityOffice"),
    ("TL_GEO_OfficeMonitorC", (5950, -3440, 560), (300, 60, 280), "SecurityOffice"),
    ("TL_GEO_ResponseSupplyTable", (5950, -2500, 160), (760, 420, 320), "ResponseSupply"),
    ("TL_GEO_ResponseSupplyCrate", (5950, -2500, 390), (420, 300, 180), "ResponseSupply"),
    # Visible barred detention cell with a wide, reliable intake opening.
    ("TL_GEO_CellFloor", (5550, 1450, 74), (1500, 1250, 28), "Detention"),
    ("TL_GEO_CellWallEast", (6280, 1450, 560), (80, 1250, 1120), "Detention"),
    ("TL_GEO_CellWallNorth", (5550, 2030, 560), (1500, 80, 1120), "Detention"),
    ("TL_GEO_CellWallSouth", (5550, 870, 560), (1500, 80, 1120), "Detention"),
    ("TL_GEO_CellBarA", (4850, 1050, 500), (70, 70, 1000), "Detention"),
    ("TL_GEO_CellBarB", (4850, 1250, 500), (70, 70, 1000), "Detention"),
    ("TL_GEO_CellBarC", (4850, 1650, 500), (70, 70, 1000), "Detention"),
    ("TL_GEO_CellBarD", (4850, 1850, 500), (70, 70, 1000), "Detention"),
    ("TL_GEO_CellBarTop", (4850, 1450, 1020), (80, 1250, 80), "Detention"),
    # Linked physical luggage pool at the active belt.
    ("TL_GEO_LuggageActive", (2200, -1300, 390), (360, 240, 260), "Luggage"),
    ("TL_GEO_LuggageQueueA", (1700, -1300, 380), (300, 220, 240), "Luggage"),
    ("TL_GEO_LuggageQueueB", (2700, -1300, 380), (300, 220, 240), "Luggage"),
]

for label, center, size, folder in BOXES:
    record(label, place_box(label, center, size, folder))

# Passenger queue rails: short repeated barriers with wide walkable gaps.
for lane_y in (-2450, -1950, -750, 750, 1950, 2450):
    for index, x in enumerate((-450, 50, 550)):
        label = f"TL_GEO_QueueRail_{int(lane_y)}_{index}"
        record(label, place_box(label, (x, lane_y, 85), (420, 70, 170), "Lanes"))

# Bollards visually protect the decision and exit routes.
for index, (x, y) in enumerate(
    ((3800, -1550), (3800, 1550), (5000, -1550), (5000, 1550), (6600, -750), (6600, 750))
):
    label = f"TL_GEO_Bollard_{index + 1:02d}"
    record(label, place_box(label, (x, y, 180), (130, 130, 360), "Lanes"))

# ---------------------------------------------------------------------------
# Interactive devices
# ---------------------------------------------------------------------------
BUTTONS = [
    # Put the briefing control directly in both players' initial sightline.
    ("TL_BTN_Start", (-1160, 0, 150), (0, 0, 0)),
    ("TL_BTN_Scan", (1180, -1300, 180), (0, 0, 0)),
    ("TL_BTN_Bag", (2200, -1300, 340), (0, 0, 0)),
    ("TL_BTN_Documents", (3250, 0, 380), (0, 0, 0)),
    ("TL_BTN_Clear", (4350, -720, 380), (0, 0, 0)),
    ("TL_BTN_Secondary", (4350, 0, 380), (0, 0, 0)),
    ("TL_BTN_Detain", (4350, 720, 380), (0, 0, 0)),
    ("TL_BTN_Response", (5650, -3000, 420), (0, 0, 0)),
    ("TL_BTN_Upgrade", (7150, -1100, 650), (0, 0, 0)),
    ("TL_BTN_Custody", (5000, 1450, 180), (0, 0, 0)),
    ("TL_BTN_Power", (3950, -3200, 420), (0, 0, 0)),
    # Debug is deliberately inside the response room, away from the main flow.
    ("TL_BTN_Debug", (6200, -3300, 220), (0, 0, 0)),
]

for label, location, rotation in BUTTONS:
    record(label, place_device(label, BUTTON_CLASS, location, rotation, "Gameplay/Buttons"))

record(
    "TL_HUD_Status",
    place_device("TL_HUD_Status", HUD_CLASS, (6100, 3300, 100), folder="Gameplay/HUD"),
)

BILLBOARDS = [
    ("TL_BOARD_Checkpoint", (1000, -1300, 1120), (0, 0, 0)),
    ("TL_BOARD_CaseStatus", (3000, -400, 760), (0, 0, 0)),
    ("TL_BOARD_BagEvidence", (2200, -1600, 720), (0, 0, 0)),
    ("TL_BOARD_DocumentEvidence", (3250, 350, 720), (0, 0, 0)),
    ("TL_BOARD_PowerStatus", (3950, -3550, 760), (0, 0, 0)),
    ("TL_BOARD_CustodyStatus", (5000, 1700, 760), (0, 0, 0)),
    ("TL_BOARD_EmergencyStatus", (5650, -2750, 820), (0, 0, 0)),
]
for label, location, rotation in BILLBOARDS:
    record(
        label,
        place_device(
            label,
            BILLBOARD_CLASS,
            location,
            rotation,
            "Gameplay/Billboards",
        ),
    )

CHARACTERS = [
    ("TL_PASSENGER_Queue1", (-550, -2150, 70), (0, 90, 0)),
    ("TL_PASSENGER_Queue2", (-50, -2150, 70), (0, 90, 0)),
    ("TL_PASSENGER_Queue3", (450, -2150, 70), (0, 90, 0)),
    ("TL_PASSENGER_Active", (900, -1300, 70), (0, 90, 0)),
]
for label, location, rotation in CHARACTERS:
    record(
        label,
        place_device(
            label,
            CHARACTER_CLASS,
            location,
            rotation,
            "Gameplay/Passengers",
        ),
    )

record("TL_Controller", place_verse_device("TL_Controller", (6200, 3300, 100)))

# Relocate the two supplied spawn pads to the marked safe-zone entrance.
spawn_targets = {
    "Player 1 Spawn Pad": (-1280, -125, 64),
    "Player 2 Spawn Pad": (-1280, 125, 64),
}
for actor in all_actors():
    target = spawn_targets.get(actor.get_actor_label())
    if target:
        actor.set_actor_location(unreal.Vector(*target), False, False)
        actor.set_actor_rotation(unreal.Rotator(0.0, 0.0, 0.0), False)

expected_labels = [item[0] for item in BOXES]
expected_labels += [
    f"TL_GEO_QueueRail_{int(lane_y)}_{index}"
    for lane_y in (-2450, -1950, -750, 750, 1950, 2450)
    for index in range(3)
]
expected_labels += [f"TL_GEO_Bollard_{index:02d}" for index in range(1, 7)]
expected_labels += [item[0] for item in BUTTONS]
expected_labels += [item[0] for item in BILLBOARDS]
expected_labels += [item[0] for item in CHARACTERS]
expected_labels += ["TL_HUD_Status", "TL_Controller"]

labels_after = {actor.get_actor_label() for actor in all_actors()}
missing = sorted(set(expected_labels) - labels_after)
duplicates = sorted(
    label
    for label in expected_labels
    if sum(1 for actor in all_actors() if actor.get_actor_label() == label) != 1
)
if missing or duplicates:
    raise RuntimeError(f"Build verification failed: missing={missing}, duplicates={duplicates}")

level_saved = unreal.EditorLevelLibrary.save_current_level()
packages_saved = unreal.EditorLoadingAndSavingUtils.save_dirty_packages(True, True)
if not level_saved or not packages_saved:
    raise RuntimeError(
        f"Build exists in memory but did not save: level={level_saved}, packages={packages_saved}"
    )

print(
    "TL_BUILD_OK|"
    f"world={world_path}|"
    f"created={len(created_labels)}|"
    f"updated={len(updated_labels)}|"
    f"deleted_proofs={deleted_proofs}|"
    f"expected={len(expected_labels)}|"
    f"actors_total={len(all_actors())}|"
    f"level_saved={level_saved}|"
    f"packages_saved={packages_saved}"
)
for label in expected_labels:
    actor = actor_by_label(label)
    print(
        "TL_LEDGER|"
        f"label={label}|"
        f"class={actor.get_class().get_path_name()}|"
        f"location={actor.get_actor_location()}|"
        f"scale={actor.get_actor_scale3d()}"
    )
