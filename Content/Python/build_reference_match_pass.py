"""Idempotent reference-match environment pass for AirportSecurity.

This pass only uses the BlueprintGeneratedClass spawn method proven by
prove_reference_asset_set.py. Existing TL gameplay devices and Verse wiring are
left untouched. The validated GridPlane shell remains as the collision fallback.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
PREFIX = "TL_ART_"
FOLDER = unreal.Name("TerminalLockdown/ReferenceMatch")

CLASSES = {
    "primitive": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "smooth_wall": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "glass": "/Game/Creative/Sets/Glass/BuildingPieces/CP_Glass_Solid_Wall.CP_Glass_Solid_Wall_C",
    "beam": "/Game/Creative/Items/Building_Parts/MetalBeams/CP_Metal_I_Bar.CP_Metal_I_Bar_C",
    "seat": "/Game/Creative/Sets/ArtDeco_Bank/Props/CP_ArtDeco_Triple_Couch_B.CP_ArtDeco_Triple_Couch_B_C",
    "desk": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Desk_02.Apollo_Office_Desk_02_C",
    "monitor": "/Game/Environments/Asteria/Props/Office/Office_Monitors_A/Blueprints/Asteria_Office_Monitor_A.Asteria_Office_Monitor_A_C",
    "power": "/Game/Building/ActorBlueprints/Prop/PowerTransformer01.PowerTransformer01_C",
    "cell": "/Game/Creative/BuildingActors/Props/Prop_CellDoor.Prop_CellDoor_C",
}

ARCHITECTURE = [
    # Bright public floor and lower-wall lining.
    ("TerminalFloor", "primitive", (2500, 0, 76), (7800, 7600, 24), 0),
    ("ExitFloor", "primitive", (6700, 0, 96), (2100, 3500, 24), 0),
    ("EntryFloor", "primitive", (-1700, 0, 58), (1700, 2500, 20), 0),
    ("NorthSill", "primitive", (2500, 3800, 155), (8000, 90, 310), 0),
    ("SouthWallLiner", "smooth_wall", (2500, -3780, 650), (8000, 60, 1300), 0),
    ("WestWallNorth", "smooth_wall", (-1460, 2820, 650), (60, 2050, 1300), 90),
    ("WestWallSouth", "smooth_wall", (-1460, -2820, 650), (60, 2050, 1300), 90),
    ("EastWallNorth", "smooth_wall", (6460, 2870, 650), (60, 1900, 1300), 90),
    ("EastWallSouth", "smooth_wall", (6460, -2870, 650), (60, 1900, 1300), 90),
    # Tall white structural rhythm, matching the wide terminal references.
    ("ColumnWestA", "primitive", (-1380, -2800, 710), (120, 120, 1420), 0),
    ("ColumnWestB", "primitive", (-1380, 0, 710), (120, 120, 1420), 0),
    ("ColumnWestC", "primitive", (-1380, 2800, 710), (120, 120, 1420), 0),
    ("ColumnMidA", "primitive", (600, -3720, 710), (120, 120, 1420), 0),
    ("ColumnMidB", "primitive", (2600, -3720, 710), (120, 120, 1420), 0),
    ("ColumnMidC", "primitive", (4600, -3720, 710), (120, 120, 1420), 0),
    ("ColumnEast", "primitive", (6380, 0, 710), (120, 120, 1420), 0),
    ("RoofRibA", "primitive", (0, 0, 1370), (120, 7500, 120), 0),
    ("RoofRibB", "primitive", (2000, 0, 1370), (120, 7500, 120), 0),
    ("RoofRibC", "primitive", (4000, 0, 1370), (120, 7500, 120), 0),
    ("RoofRibD", "primitive", (6000, 0, 1370), (120, 7500, 120), 0),
    ("RoofCrossNorth", "primitive", (2500, 2600, 1370), (7800, 100, 100), 0),
    ("RoofCrossCenter", "primitive", (2500, 0, 1370), (7800, 100, 100), 0),
    ("RoofCrossSouth", "primitive", (2500, -2600, 1370), (7800, 100, 100), 0),
    # Blue runway glazing and dark metal framing.
    ("WindowA", "glass", (-800, 3775, 810), (1200, 36, 1000), 0),
    ("WindowB", "glass", (600, 3775, 810), (1200, 36, 1000), 0),
    ("WindowC", "glass", (2000, 3775, 810), (1200, 36, 1000), 0),
    ("WindowD", "glass", (3400, 3775, 810), (1200, 36, 1000), 0),
    ("WindowE", "glass", (4800, 3775, 810), (1200, 36, 1000), 0),
    ("WindowF", "glass", (6100, 3775, 810), (700, 36, 1000), 0),
    ("WindowHead", "beam", (2500, 3750, 1320), (8000, 90, 90), 0),
    ("MullionA", "beam", (-1450, 3750, 810), (70, 70, 1120), 0),
    ("MullionB", "beam", (-100, 3750, 810), (70, 70, 1120), 0),
    ("MullionC", "beam", (1300, 3750, 810), (70, 70, 1120), 0),
    ("MullionD", "beam", (2700, 3750, 810), (70, 70, 1120), 0),
    ("MullionE", "beam", (4100, 3750, 810), (70, 70, 1120), 0),
    ("MullionF", "beam", (5500, 3750, 810), (70, 70, 1120), 0),
    ("MullionG", "beam", (6450, 3750, 810), (70, 70, 1120), 0),
    # Scanner, bag tables, and decision counter retain the tested gameplay layout.
    ("ScannerSouthLeft", "beam", (1050, -1760, 470), (140, 180, 940), 0),
    ("ScannerSouthRight", "beam", (1050, -840, 470), (140, 180, 940), 0),
    ("ScannerSouthTop", "beam", (1050, -1300, 920), (140, 1100, 120), 0),
    ("ScannerNorthLeft", "beam", (1050, 840, 470), (140, 180, 940), 0),
    ("ScannerNorthRight", "beam", (1050, 1760, 470), (140, 180, 940), 0),
    ("ScannerNorthTop", "beam", (1050, 1300, 920), (140, 1100, 120), 0),
    ("BagBeltSouth", "primitive", (2200, -1300, 165), (1500, 650, 300), 0),
    ("BagBeltNorth", "primitive", (2200, 1300, 165), (1500, 650, 300), 0),
    ("DocumentCounter", "primitive", (3250, 0, 185), (850, 1700, 340), 0),
    ("DecisionCounter", "primitive", (4350, 0, 185), (900, 2500, 340), 0),
    # Restricted corridor surfaces and airport-like support-room enclosures.
    ("CorridorFloor", "primitive", (2450, -3320, 102), (3100, 720, 24), 0),
    ("PowerWallWest", "smooth_wall", (3350, -3340, 580), (70, 1000, 1120), 90),
    ("PowerWallEast", "smooth_wall", (4550, -3340, 580), (70, 1000, 1120), 90),
    ("PowerWallNorth", "smooth_wall", (3950, -2860, 580), (1280, 70, 1120), 0),
    ("OfficeFloor", "primitive", (5550, -3100, 112), (1650, 1250, 24), 0),
    ("CellFloor", "primitive", (5550, 1450, 100), (1500, 1250, 24), 0),
    ("CellWallEast", "smooth_wall", (6280, 1450, 580), (70, 1250, 1120), 90),
    ("CellWallNorth", "smooth_wall", (5550, 2030, 580), (1500, 70, 1120), 0),
    ("CellWallSouth", "smooth_wall", (5550, 870, 580), (1500, 70, 1120), 0),
    # Original, non-branded aircraft silhouette outside the runway glass.
    ("AircraftBody", "primitive", (2800, 4750, 450), (3000, 360, 420), 0),
    ("AircraftNose", "primitive", (4450, 4750, 450), (500, 300, 360), 0),
    ("AircraftTail", "primitive", (1050, 4750, 700), (420, 280, 700), 0),
    ("AircraftWingNear", "primitive", (2750, 4250, 440), (1300, 900, 90), 0),
    ("AircraftWingFar", "primitive", (2750, 5250, 440), (1300, 900, 90), 0),
]

PROPS = [
    ("WaitingSeatA", "seat", (900, 3050, 90), 720, 0),
    ("WaitingSeatB", "seat", (2200, 3050, 90), 720, 0),
    ("WaitingSeatC", "seat", (3500, 3050, 90), 720, 0),
    ("OfficeDesk", "desk", (5550, -3230, 115), 900, 0),
    ("OfficeMonitorA", "monitor", (5250, -3400, 420), 240, 0),
    ("OfficeMonitorB", "monitor", (5550, -3400, 420), 240, 0),
    ("OfficeMonitorC", "monitor", (5850, -3400, 420), 240, 0),
    ("PowerTransformerA", "power", (3600, -3430, 110), 500, 0),
    ("PowerTransformerB", "power", (4300, -3430, 110), 500, 0),
    ("DetentionDoor", "cell", (4890, 1450, 100), 1050, 90),
]

HIDE_OLD_PREFIXES = (
    "TL_GEO_WindowPane",
    "TL_GEO_SeatRow",
    "TL_GEO_OfficeDesk",
    "TL_GEO_OfficeMonitor",
    "TL_GEO_PowerCabinet",
    "TL_GEO_PowerConsole",
    "TL_GEO_Aircraft",
)


def all_actors():
    return list(ACTORS.get_all_level_actors())


def load_classes():
    loaded = {}
    for key, path in CLASSES.items():
        loaded[key] = unreal.load_class(None, path)
        if loaded[key] is None:
            raise RuntimeError(f"Approved class failed to load: {path}")
    return loaded


def center_actor(actor, center):
    origin, _ = actor.get_actor_bounds(False)
    location = actor.get_actor_location()
    actor.set_actor_location(
        unreal.Vector(
            location.x + center[0] - origin.x,
            location.y + center[1] - origin.y,
            location.z + center[2] - origin.z,
        ),
        False,
        False,
    )


def spawn_box(classes, suffix, class_key, center, size, yaw):
    rotation = (
        unreal.Rotator(pitch=0, yaw=yaw, roll=90)
        if class_key == "smooth_wall"
        else unreal.Rotator(0, yaw, 0)
    )
    actor = ACTORS.spawn_actor_from_class(
        classes[class_key], unreal.Vector(*center), rotation
    )
    if actor is None:
        raise RuntimeError(f"Spawn failed: {suffix}")
    actor.set_actor_label(PREFIX + suffix)
    actor.set_folder_path(FOLDER)
    actor.set_actor_scale3d(unreal.Vector(1, 1, 1))
    _, extent = actor.get_actor_bounds(False)
    base = (
        max(extent.x * 2.0, 1.0),
        max(extent.y * 2.0, 1.0),
        max(extent.z * 2.0, 1.0),
    )
    if class_key == "smooth_wall":
        if int(yaw) % 180 == 0:
            scale = unreal.Vector(
                size[0] / base[0], size[2] / base[2], size[1] / base[1]
            )
        else:
            scale = unreal.Vector(
                size[1] / base[1], size[2] / base[2], size[0] / base[0]
            )
        actor.set_actor_scale3d(scale)
    else:
        actor.set_actor_scale3d(
            unreal.Vector(size[0] / base[0], size[1] / base[1], size[2] / base[2])
        )
    center_actor(actor, center)
    return actor


def spawn_prop(classes, suffix, class_key, ground, target_span, yaw):
    actor = ACTORS.spawn_actor_from_class(
        classes[class_key], unreal.Vector(*ground), unreal.Rotator(0, yaw, 0)
    )
    if actor is None:
        raise RuntimeError(f"Spawn failed: {suffix}")
    actor.set_actor_label(PREFIX + suffix)
    actor.set_folder_path(FOLDER)
    _, extent = actor.get_actor_bounds(False)
    span = max(extent.x * 2.0, extent.y * 2.0, 1.0)
    scale = target_span / span
    actor.set_actor_scale3d(unreal.Vector(scale, scale, scale))
    origin, extent = actor.get_actor_bounds(False)
    location = actor.get_actor_location()
    actor.set_actor_location(
        unreal.Vector(
            location.x + ground[0] - origin.x,
            location.y + ground[1] - origin.y,
            location.z + ground[2] - (origin.z - extent.z),
        ),
        False,
        False,
    )
    return actor


world = unreal.EditorLevelLibrary.get_editor_world()
if world is None or "AirportSecurity" not in world.get_path_name():
    raise RuntimeError("Reference pass refused outside AirportSecurity")

for candidate in all_actors():
    if candidate.get_actor_label().startswith(PREFIX):
        ACTORS.destroy_actor(candidate)

classes = load_classes()
created = []
for spec in ARCHITECTURE:
    created.append(spawn_box(classes, *spec).get_actor_label())
for spec in PROPS:
    created.append(spawn_prop(classes, *spec).get_actor_label())

hidden = []
for actor in all_actors():
    label = actor.get_actor_label()
    if label.startswith(HIDE_OLD_PREFIXES):
        actor.set_actor_hidden_in_game(True)
        try:
            actor.set_is_temporarily_hidden_in_editor(True)
        except Exception:
            pass
        hidden.append(label)

# Place the Creative pads and their generated starts together in the open south
# concourse. The original pad transforms were directly behind the legacy
# briefing backwall, so Fortnite's third-person camera opened against graybox
# geometry even though the generated starts were clear.
spawn_pads = sorted(
    [a for a in all_actors() if "Player_Spawner" in a.get_class().get_name()],
    key=lambda a: a.get_actor_location().y,
)
pad_locations = ((-950, -3300, 64), (-950, -3050, 64))
for pad, location in zip(spawn_pads, pad_locations):
    pad.set_actor_location(unreal.Vector(*location), False, False)
    pad.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=180.0, roll=0.0), False
    )

player_starts = sorted(
    [a for a in all_actors() if "FortPlayerStartCreative" in a.get_class().get_name()],
    key=lambda a: a.get_actor_location().y,
)
start_locations = ((-950, -3300, 180), (-950, -3050, 180))
for start, location in zip(player_starts, start_locations):
    start.set_actor_location(unreal.Vector(*location), False, False)
    start.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=180.0, roll=0.0), False
    )

saved = unreal.EditorLevelLibrary.save_current_level()
unreal.EditorLevelLibrary.set_level_viewport_camera_info(
    unreal.Vector(-1050, 3000, 700),
    unreal.Rotator(pitch=-7.0, yaw=0.0, roll=0.0),
)
result = {
    "world": world.get_path_name(),
    "created": len(created),
    "hidden_legacy_visuals": len(hidden),
    "spawn_pads_normalized": min(len(spawn_pads), len(pad_locations)),
    "player_starts_repositioned": min(len(player_starts), len(start_locations)),
    "saved": bool(saved),
    "actor_count": len(all_actors()),
}
