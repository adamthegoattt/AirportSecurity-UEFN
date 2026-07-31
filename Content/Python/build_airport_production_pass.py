"""Idempotent player-visible airport production pass for AirportSecurity.

Adds a coherent public-terminal kit, checkpoint furniture, and distinct support
rooms while preserving all wired devices, characters, and navigation targets.
Existing TL_ART geometry is recolored in place; only TL_PROD actors are owned
and replaced by this script.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
PREFIX = "TL_PROD_"
FOLDER = unreal.Name("TerminalLockdown/ProductionPass")
EXISTING = {}

CLASSES = {
    "cube": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "cylinder": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cylinder_Small.CP_Primitive_Cylinder_Small_C",
    "glass": "/Game/Creative/Sets/Glass/Props/CP_Glass_PropWall.CP_Glass_PropWall_C",
    "beam": "/Game/Creative/Items/Building_Parts/MetalBeams/CP_Metal_I_Bar.CP_Metal_I_Bar_C",
    "bench": "/Game/Athena/Apollo/Environments/BuildingActors/Agency/Props/Apollo_Agency_Bench_01.Apollo_Agency_Bench_01_C",
    "planter": "/Game/Creative/BuildingActors/Props/CP_Agency_Planter_02.CP_Agency_Planter_02_C",
    "prison_door": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_Door.Apollo_SharkPrison_Door_C",
    "prison_toilet": "/Game/Athena/BuildingActors/Props/Building/ActorBlueprints/Containers/Athena_Prop_Bathroom_PrisonToilet.Athena_Prop_Bathroom_PrisonToilet_C",
    "luggage_a": "/Game/Environments/Asteria/Props/Commerce/Commerce_Luggage_A/Blueprints/BP_Commerce_Luggage_A_A.BP_Commerce_Luggage_A_A_C",
    "luggage_b": "/Game/Environments/Asteria/Props/Commerce/Commerce_Luggage_A/Blueprints/BP_Commerce_Luggage_B_B.BP_Commerce_Luggage_B_B_C",
    "monitor": "/Game/Environments/Asteria/Props/Office/Office_Monitors_A/Blueprints/Asteria_Office_Monitor_A.Asteria_Office_Monitor_A_C",
    "desk": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Desk_02.Apollo_Office_Desk_02_C",
    "chair": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Chair_01.Apollo_Office_Chair_01_C",
    "ceiling_light": "/Game/Creative/BuildingActors/Props/CP_Yacht_Ceiling_Light.CP_Yacht_Ceiling_Light_C",
    "emergency_light": "/Game/Creative/BuildingActors/Props/CP_Apollo_TrainTunnelEmergency_Light.CP_Apollo_TrainTunnelEmergency_Light_C",
    # Native prop families proven with disposable spawn, actor validation, and
    # cleanup before they are promoted into the saved production batch.
    "electrical_box": "/Game/Athena/Apollo/Environments/BuildingActors/Tinfoil/Props/Apollo_Tinfoil_ElectricalBox_01.Apollo_Tinfoil_ElectricalBox_01_C",
    "prison_bed": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_SingleBed_01.Apollo_SharkPrison_SingleBed_01_C",
    "prison_sink": "/Game/Athena/BuildingActors/Props/Building/ActorBlueprints/Containers/Athena_Prop_Prison_Bathroom_Sink.Athena_Prop_Prison_Bathroom_Sink_C",
    "cell_bench": "/Game/Environments/Helios/Props/Brimstone/Brimstone_Cell_Bench_A/Blueprints/BP_Brimstone_CellBench_A.BP_Brimstone_CellBench_A_C",
    "stanchion": "/Game/Environments/Helios/Props/Commerce/Commerce_BeltStanchion_A/Blueprints/BP_Commerce_BeltStanchion_A.BP_Commerce_BeltStanchion_A_C",
    "breaker": "/Game/Environments/Helios/Props/Coastal/Coastal_Breakers_A/Blueprints/BP_Coastal_Breaker_A.BP_Coastal_Breaker_A_C",
    "triple_seat": "/Game/Creative/Sets/ArtDeco_Bank/Props/CP_ArtDeco_Triple_Couch_B.CP_ArtDeco_Triple_Couch_B_C",
    "button": "/CreativeCoreDevices/Device_Button_V2.Device_Button_V2_C",
    "billboard": "/CreativeCoreDevices/Device_Billboard_V2.Device_Billboard_V2_C",
}


def all_actors():
    return list(ACTORS.get_all_level_actors())


def actor_by_label(label):
    return next((actor for actor in all_actors() if actor.get_actor_label() == label), None)


def clear_materials(actor):
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        if component.get_num_materials() > 0:
            component.set_material(0, None)


def color_actor(actor, color_name):
    try:
        color_type = type(actor.get_editor_property("color"))
        color_value = getattr(color_type, color_name)
        actor.set_editor_property("allow_custom_material", False)
        clear_materials(actor)
        actor.set_editor_property("color", color_value)
        return True
    except Exception:
        return False


def make_decorative_nonblocking(actor):
    """Keep a thin visible surface without adding a player collision lip."""
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        component.set_collision_enabled(unreal.CollisionEnabled.NO_COLLISION)
    for property_name in ("no_collision", "no_pawn_collision", "no_physics_collision"):
        try:
            actor.set_editor_property(property_name, True)
        except Exception:
            pass


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


def resize_existing_actor(actor, center, size):
    """Resize a retained shell actor by bounds, independent of its pivot."""
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
    _, extent = actor.get_actor_bounds(False)
    base = (
        max(extent.x * 2.0, 1.0),
        max(extent.y * 2.0, 1.0),
        max(extent.z * 2.0, 1.0),
    )
    actor.set_actor_scale3d(
        unreal.Vector(size[0] / base[0], size[1] / base[1], size[2] / base[2])
    )
    center_actor(actor, center)


def spawn_box(classes, suffix, center, size, color, yaw=0.0):
    label = PREFIX + suffix
    actor = EXISTING.pop(label, None)
    actor_class = classes["cube"]
    rotation = unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0)
    if actor is not None and actor.get_class() != actor_class:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*center), rotation)
    if actor is None:
        raise RuntimeError("Failed to spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
    _, extent = actor.get_actor_bounds(False)
    base = (max(extent.x * 2.0, 1.0), max(extent.y * 2.0, 1.0), max(extent.z * 2.0, 1.0))
    actor.set_actor_scale3d(unreal.Vector(size[0] / base[0], size[1] / base[1], size[2] / base[2]))
    color_actor(actor, color)
    center_actor(actor, center)
    return actor


def spawn_shape(classes, suffix, class_key, center, size, color, yaw=0.0):
    """Spawn a sized primitive shape while preserving idempotent TL_PROD ownership."""
    label = PREFIX + suffix
    actor = EXISTING.pop(label, None)
    actor_class = classes[class_key]
    rotation = unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0)
    if actor is not None and actor.get_class() != actor_class:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*center), rotation)
    if actor is None:
        raise RuntimeError("Failed to spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
    _, extent = actor.get_actor_bounds(False)
    base = (max(extent.x * 2.0, 1.0), max(extent.y * 2.0, 1.0), max(extent.z * 2.0, 1.0))
    actor.set_actor_scale3d(unreal.Vector(size[0] / base[0], size[1] / base[1], size[2] / base[2]))
    color_actor(actor, color)
    center_actor(actor, center)
    return actor


def spawn_prop(classes, suffix, class_key, ground, target_span, yaw=0.0):
    label = PREFIX + suffix
    actor = EXISTING.pop(label, None)
    actor_class = classes[class_key]
    rotation = unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0)
    if actor is not None and actor.get_class() != actor_class:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*ground), rotation)
    if actor is None:
        raise RuntimeError("Failed to spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
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


def spawn_device(classes, label, location, rotation=(0.0, 0.0, 0.0)):
    actor = actor_by_label(label)
    actor_class = classes["button"]
    if actor is not None and actor.get_class() != actor_class:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(
            actor_class,
            unreal.Vector(*location),
            unreal.Rotator(*rotation),
        )
    if actor is None:
        raise RuntimeError("Failed to spawn production interaction " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(unreal.Name("TerminalLockdown/Gameplay/StationInteractions"))
    actor.set_actor_location(unreal.Vector(*location), False, False)
    actor.set_actor_rotation(unreal.Rotator(*rotation), False)
    # These devices are interaction backends for the deliberately modeled
    # consoles and cabinets. Keep the stock Creative button mesh out of the
    # player-facing composition whenever this class exposes the option.
    try:
        actor.set_editor_property("visible_during_game", False)
    except Exception as exc:
        unreal.log_warning("Could not hide backend device {0}: {1}".format(label, exc))
    return actor


def spawn_label(classes, suffix, location, text, scale=0.62):
    """Add a concise physical-console label; gameplay remains on real buttons."""
    label = PREFIX + suffix
    actor = EXISTING.pop(label, None)
    actor_class = classes["billboard"]
    if actor is not None and actor.get_class() != actor_class:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*location), unreal.Rotator())
    if actor is None:
        raise RuntimeError("Failed to spawn station label " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_location(unreal.Vector(*location), False, False)
    actor.set_actor_rotation(unreal.Rotator(pitch=0.0, yaw=0.0, roll=0.0), False)
    actor.set_actor_scale3d(unreal.Vector(scale, scale, scale))
    actor.set_editor_property("text", text)
    make_decorative_nonblocking(actor)
    return actor


# Solid Creative colors replace the stretched world-grid materials visible in
# the previous player build. This affects presentation only, never transforms.
ART_COLORS = {
    # A mid-value floor preserves the bright terminal read without clipping to
    # featureless white under Fortnite's daylight exposure.
    "TerminalFloor": "GRAY",
    "ExitFloor": "SILVER",
    "EntryFloor": "GRAY",
    "WaitingCarpet": "MIDNIGHT_BLUE",
    "DecisionZoneCarpet": "MIDNIGHT_BLUE",
    "CorridorFloor": "MIDNIGHT_BLUE",
    "OfficeFloor": "MIDNIGHT_BLUE",
    "CellFloor": "GRAY",
    "QueueLaneSouth": "PACIFIC_BLUE",
    "QueueLaneNorth": "PACIFIC_BLUE",
    "BagBeltSouth": "BLACK",
    "BagBeltNorth": "BLACK",
    "BagRailNorthA": "GRAY",
    "BagRailNorthB": "GRAY",
    "BagRailSouthA": "GRAY",
    "BagRailSouthB": "GRAY",
    "BagXrayNorthLeft": "GRAY",
    "BagXrayNorthRight": "GRAY",
    "BagXrayNorthTop": "MIDNIGHT_BLUE",
    "BagXraySouthLeft": "GRAY",
    "BagXraySouthRight": "GRAY",
    "BagXraySouthTop": "MIDNIGHT_BLUE",
    "WalkthroughNorthLeft": "MIDNIGHT_BLUE",
    "WalkthroughNorthRight": "MIDNIGHT_BLUE",
    "WalkthroughNorthTop": "MIDNIGHT_BLUE",
    "WalkthroughSouthLeft": "MIDNIGHT_BLUE",
    "WalkthroughSouthRight": "MIDNIGHT_BLUE",
    "WalkthroughSouthTop": "MIDNIGHT_BLUE",
    "DocumentCounter": "GRAY",
    "DecisionCounter": "BLACK",
    "DecisionHeader": "MIDNIGHT_BLUE",
    "DecisionMonitorA": "APPLE_GREEN",
    "DecisionMonitorB": "GOLD",
    "DecisionMonitorC": "RED_ORANGE",
    "DocumentMonitorA": "AQUA",
    "DocumentMonitorB": "PACIFIC_BLUE",
    "CheckpointSignBacking": "GREEN",
    "PowerConsole": "GRAY",
    "DetentionIntake": "GRAY",
    "CellBench": "GRAY",
    "CellBarNorth": "MIDNIGHT_BLUE",
    "CellBarSouth": "MIDNIGHT_BLUE",
    "CellBarTop": "MIDNIGHT_BLUE",
    "CellWallEast": "GRAY",
    "CellWallNorth": "GRAY",
    "CellWallSouth": "GRAY",
    "RunwayApron": "MIDNIGHT_BLUE",
    "RunwayStripeNear": "WHITE",
    "RunwayStripeFar": "GOLD",
    "StaffHeader": "MIDNIGHT_BLUE",
    "PowerHeader": "MIDNIGHT_BLUE",
    "OfficeHeader": "MIDNIGHT_BLUE",
    "DetentionHeader": "MIDNIGHT_BLUE",
    "CorridorWallNorth": "GRAY",
    "CorridorWallSouth": "GRAY",
    "CorridorCeiling": "SILVER",
    "PowerWallEast": "GRAY",
    "PowerWallNorth": "GRAY",
    "PowerWallWest": "GRAY",
    "SouthWallLiner": "SILVER",
    "MullionA": "MIDNIGHT_BLUE",
    "MullionB": "MIDNIGHT_BLUE",
    "MullionC": "MIDNIGHT_BLUE",
    "MullionD": "MIDNIGHT_BLUE",
    "MullionE": "MIDNIGHT_BLUE",
    "MullionF": "MIDNIGHT_BLUE",
    "MullionG": "MIDNIGHT_BLUE",
    "WindowHead": "MIDNIGHT_BLUE",
    "NorthSill": "MIDNIGHT_BLUE",
    "RoofRibA": "SILVER",
    "RoofRibB": "SILVER",
    "RoofRibC": "SILVER",
    "RoofRibD": "SILVER",
    "RoofCrossCenter": "SILVER",
    "RoofCrossNorth": "SILVER",
    "RoofCrossSouth": "SILVER",
    "AircraftBody": "WHITE",
    "AircraftWing": "WHITE",
    "AircraftTailWing": "WHITE",
    "AircraftTailFin": "PACIFIC_BLUE",
    "AircraftEngineNear": "GRAY",
    "AircraftEngineFar": "GRAY",
    "AircraftCockpit": "MIDNIGHT_BLUE",
    "AircraftDoor": "GRAY",
    "AircraftWindow01": "MIDNIGHT_BLUE",
    "AircraftWindow02": "MIDNIGHT_BLUE",
    "AircraftWindow03": "MIDNIGHT_BLUE",
    "AircraftWindow04": "MIDNIGHT_BLUE",
    "AircraftWindow05": "MIDNIGHT_BLUE",
    "AircraftWindow06": "MIDNIGHT_BLUE",
    "AircraftWindow07": "MIDNIGHT_BLUE",
    "AircraftWindow08": "MIDNIGHT_BLUE",
}


# Keep the saved editor and pre-game presentation production-ready. Verse
# replaces these messages dynamically once a session begins, but without
# authored defaults every physical board visibly reads "Sample Text" while
# editing, validating, capturing proof, or waiting for device initialization.
BILLBOARD_DEFAULTS = {
    "TL_BOARD_Checkpoint": "SECURITY CHECKPOINT | OPEN",
    "TL_BOARD_CaseStatus": "CURRENT PASSENGER | WAITING FOR SHIFT",
    "TL_BOARD_BagEvidence": "BAG INSPECTION | NO ACTIVE BAG",
    "TL_BOARD_DocumentEvidence": "TRAVEL DOCUMENTS | NO ACTIVE CASE",
    "TL_BOARD_PowerStatus": "POWER ONLINE",
    "TL_BOARD_CustodyStatus": "DETENTION INTAKE | READY",
    "TL_BOARD_CellStatus": "DETENTION CELL | VACANT",
    "TL_BOARD_EmergencyStatus": "RESPONSE SUPPLY | STANDBY",
    "TL_BOARD_ResponseLoadout": "SECURITY RESPONSE KIT\nSIGNAL REMOTE A\nSTANDBY",
    "TL_BOARD_ClearControl": "PASS / CLEAR\nLOCKED - COMPLETE CHECKS",
    "TL_BOARD_SecondaryControl": "NO PASS / SECONDARY\nLOCKED - COMPLETE CHECKS",
    "TL_BOARD_DetainControl": "DETAIN\nLOCKED - COMPLETE CHECKS",
}


# Put both players at the far end of the detector spine. This gives the player
# the same long, centered checkpoint reveal as the reference instead of spawning
# beside unrelated briefing furniture. The art-floor slab tops out at Z=68.
SPAWN_PLACEMENTS = {
    "Player 1 Spawn Pad": (-2750.0, -1450.0, 68.0, 0.0),
    "Player 2 Spawn Pad": (-2750.0, -1150.0, 68.0, 0.0),
}


# Gameplay actors stay bound to Verse while their physical presentation moves
# to the perimeter. The detector approach itself remains empty from the west
# entry to the arch; queued passengers and service controls read as side-wall
# terminal activity rather than obstacles in the passenger lane.
WALKUP_ACTOR_PLACEMENTS = {
    "TL_BTN_Start": (-2700.0, -2250.0, 330.0),
    "TL_PASSENGER_Queue1": (-1900.0, -3100.0, 70.0),
    "TL_PASSENGER_Queue2": (-1200.0, -3100.0, 70.0),
    "TL_PASSENGER_Queue3": (-500.0, -3100.0, 70.0),
    "TL_BTN_Documents": (3400.0, 3050.0, 380.0),
    "TL_BOARD_DocumentEvidence": (3400.0, 3210.0, 720.0),
}


# Extend the public terminal 16 m west. The retained large detector remains at
# X=1050, but this moves the shell's visual center from X=2500 to X=1700 and
# gives the oversized checkpoint frame deliberate breathing room. Both the base
# shell and reference-finish actors are adjusted when present, so this remains
# correct regardless of which upstream builder ran most recently.
SHELL_BOX_ADJUSTMENTS = {
    "TL_GEO_TerminalFloor": ((1700, 0, 32), (9400, 7600, 64)),
    "TL_ART_TerminalFloor": ((1700, 0, 76), (9400, 7600, 24)),
    "TL_ART_EntryFloor": ((-1925, 0, 58), (2150, 2500, 20)),
    "TL_GEO_WallSouth": ((1700, -3830, 650), (9600, 80, 1300)),
    "TL_ART_SouthWallLiner": ((1700, -3780, 650), (9600, 60, 1300)),
    "TL_GEO_WallNorth": ((1700, 3830, 150), (9600, 80, 300)),
    "TL_GEO_WindowTopBeam": ((1700, 3810, 1240), (9600, 100, 120)),
    "TL_GEO_RoofCrossNorth": ((1700, 2600, 1320), (9400, 100, 100)),
    "TL_GEO_RoofCrossCenter": ((1700, 0, 1320), (9400, 100, 100)),
    "TL_GEO_RoofCrossSouth": ((1700, -2600, 1320), (9400, 100, 100)),
    "TL_ART_RoofCrossNorth": ((1700, 2600, 1370), (9400, 100, 100)),
    "TL_ART_RoofCrossCenter": ((1700, 0, 1370), (9400, 100, 100)),
    "TL_ART_RoofCrossSouth": ((1700, -2600, 1370), (9400, 100, 100)),
}

SHELL_LOCATION_ADJUSTMENTS = {
    "TL_GEO_WallWestNorth": (-3100, 2830, 650),
    "TL_GEO_WallWestSouth": (-3100, -2830, 650),
    "TL_ART_WestWallNorth": (-3060, 2820, 650),
    "TL_ART_WestWallSouth": (-3060, -2820, 650),
}


BOXES = [
    # White ceiling coffers and cool structural rhythm: the terminal now reads
    # as an interior rather than an open blue box from the spawn camera.
    ("CeilingPanel01", (-500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel02", (500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel03", (1500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel04", (2500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel05", (3500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel06", (4500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel07", (5500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanel08", (-500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel09", (500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel10", (1500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel11", (2500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel12", (3500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel13", (4500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanel14", (5500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanelWestSouth01", (-1500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanelWestSouth02", (-2500, -2550, 1325), (850, 1500, 45), "SILVER"),
    ("CeilingPanelWestMain01", (-1500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("CeilingPanelWestMain02", (-2500, 200, 1325), (850, 3600, 45), "SILVER"),
    ("WestRoofRib", (-2000, 0, 1320), (120, 7500, 120), "SILVER"),
    ("WestWindowSill", (-2200, 3830, 150), (1600, 80, 300), "GRAY"),
    ("WestWindowHeader", (-2200, 3810, 1240), (1600, 100, 120), "SILVER"),
    ("WestWindowMullion01", (-3000, 3775, 810), (70, 70, 1120), "MIDNIGHT_BLUE"),
    ("WestWindowMullion02", (-2200, 3775, 810), (70, 70, 1120), "MIDNIGHT_BLUE"),
    # Public concourse color bands and deliberate floor flow.
    ("SouthWallBlueBand", (1700, -3735, 410), (9500, 55, 220), "PACIFIC_BLUE"),
    ("WestPortalBlueBand", (-3030, 0, 410), (55, 1850, 220), "PACIFIC_BLUE"),
    ("EastPortalBlueBand", (6430, 0, 410), (55, 1850, 220), "PACIFIC_BLUE"),
    # A single 39 m walk-up replaces the offset queue maze. The inset and edge
    # lines are decorative/nonblocking and taper visually into the 740 cm clear
    # opening of the retained oversized detector.
    ("DetectorApproachInset", (-900, -1300, 94), (3900, 860, 8), "GRAY"),
    ("DetectorApproachEdgeSouth", (-900, -1780, 101), (3900, 24, 8), "PACIFIC_BLUE"),
    ("DetectorApproachEdgeNorth", (-900, -820, 101), (3900, 24, 8), "PACIFIC_BLUE"),
    ("DetectorApproachCenter01", (-2200, -1300, 101), (420, 18, 8), "WHITE"),
    ("DetectorApproachCenter02", (-900, -1300, 101), (420, 18, 8), "WHITE"),
    ("DetectorApproachCenter03", (350, -1300, 101), (420, 18, 8), "WHITE"),
    ("PassengerFlow03", (1550, -1300, 89), (1000, 30, 1.5), "WHITE"),
    ("DepartureFlow", (4800, 1150, 108), (2800, 46, 8), "APPLE_GREEN"),
    ("DetentionFlow", (4550, 1450, 108), (1200, 46, 8), "RED_ORANGE"),
    # Thin, nonblocking color fields make the passenger route and staff work
    # zones readable from eye level without recreating a collision lip.
    # Restore the original oversized, wall-backed detector proportions requested
    # by the map owner. Its 740 cm clear opening stays centered on Y=-1300, and
    # the pillars start at the finished floor top so there is no traversal lip.
    ("LargeDetectorLeft", (1050, -1760, 548), (140, 180, 920), "SILVER"),
    ("LargeDetectorRight", (1050, -840, 548), (140, 180, 920), "SILVER"),
    ("LargeDetectorTop", (1050, -1300, 960), (140, 1100, 120), "SILVER"),
    # Low baggage belts and a hollow three-piece X-ray portal replace the old
    # stacked solid shell/void and giant reference belt. Their centers follow
    # the BagButton-derived entry, tunnel, and exit route at Y=-1325.
    ("BagConveyorIn", (2175, -1325, 108), (650, 240, 40), "BLACK"),
    ("BagConveyorOut", (2825, -1325, 108), (550, 240, 40), "BLACK"),
    # The detector-side console is the primary two-choice checkpoint decision
    # station. It remains outside the Y=-1300 passenger path while the passenger
    # stops immediately beyond the centered arch, visible from both controls.
    ("CheckpointDecisionBase", (1500, -2200, 165), (520, 260, 154), "MIDNIGHT_BLUE"),
    ("CheckpointDecisionTop", (1500, -2200, 251), (520, 260, 18), "GRAY"),
    ("CheckpointDecisionDivider", (1500, -2200, 276), (18, 210, 32), "SILVER"),
    ("CheckpointNoPassSymbolA", (1385, -2200, 307), (70, 18, 12), "WHITE", 45.0),
    ("CheckpointNoPassSymbolB", (1385, -2200, 307), (70, 18, 12), "WHITE", -45.0),
    ("CheckpointPassSymbolA", (1592, -2205, 300), (50, 18, 12), "WHITE", -40.0),
    ("CheckpointPassSymbolB", (1628, -2194, 313), (85, 18, 12), "WHITE", 42.0),
    # Detain remains a later, explicit post-Secondary action at the custody desk.
    ("DetainConsole", (4380, 760, 190), (760, 500, 300), "RED_ORANGE"),
    # The former center-spanning desks are consolidated into compact service
    # counters at the terminal's north edge, preserving real airport functions
    # without interrupting the checkpoint sightline.
    ("DecisionDeskFront", (4650, 3260, 320), (1200, 120, 520), "MIDNIGHT_BLUE"),
    ("DecisionDetainPad", (4380, 760, 108), (760, 520, 12), "RED_ORANGE"),
    ("DecisionDetainBackplate", (4260, 760, 700), (45, 640, 600), "RED_ORANGE"),
    ("DecisionDetainGuide", (3920, 760, 106), (780, 42, 8), "RED_ORANGE"),
    # Runway-facing lounge islands and a low media wall.
    ("WaitingRugA", (1550, 3000, 108), (2600, 1050, 10), "MIDNIGHT_BLUE"),
    ("WaitingRugB", (3650, 3000, 108), (1400, 1050, 10), "MIDNIGHT_BLUE"),
    ("InfoWall", (5300, 3200, 540), (900, 110, 760), "MIDNIGHT_BLUE"),
    ("InfoScreenA", (5240, 3135, 680), (520, 20, 230), "AQUA"),
    ("InfoScreenB", (5240, 3135, 390), (520, 20, 170), "PACIFIC_BLUE"),
    # Restricted corridor: dark lower band, lit headers, and hazard language.
    ("RestrictedBandSouth", (2450, -3630, 360), (3100, 55, 260), "MIDNIGHT_BLUE"),
    ("RestrictedBandNorth", (2150, -3010, 360), (2100, 55, 260), "MIDNIGHT_BLUE"),
    ("RestrictedThreshold", (1450, -3320, 115), (220, 620, 24), "GOLD"),
    ("PowerHazardA", (3750, -3040, 350), (500, 26, 90), "GOLD", 45.0),
    ("PowerHazardB", (4150, -3040, 350), (500, 26, 90), "GOLD", -45.0),
    ("PowerCabinetPlinth", (3950, -3490, 150), (1050, 250, 160), "BLACK"),
    ("PowerRoomWarningPad", (3950, -3180, 106), (1500, 920, 10), "MIDNIGHT_BLUE"),
    ("PowerHazardStripe01", (3400, -3180, 108), (90, 880, 10), "GOLD"),
    ("PowerHazardStripe02", (3950, -3180, 108), (90, 880, 10), "GOLD"),
    ("PowerHazardStripe03", (4500, -3180, 108), (90, 880, 10), "GOLD"),
    ("PowerStatusBackplate", (4005, -3550, 760), (40, 980, 360), "GOLD"),
    ("OfficeTechWall", (6120, -3100, 630), (120, 900, 820), "MIDNIGHT_BLUE"),
    ("OfficeDeskRiser", (5550, -3300, 160), (1150, 520, 120), "GRAY"),
    # Detention intake and visible secure threshold.
    ("DetentionOuterFrameTop", (4890, 1450, 1120), (160, 1260, 170), "MIDNIGHT_BLUE"),
    ("DetentionOuterFrameNorth", (4890, 2020, 610), (160, 140, 1020), "MIDNIGHT_BLUE"),
    ("DetentionOuterFrameSouth", (4890, 880, 610), (160, 140, 1020), "MIDNIGHT_BLUE"),
    ("DetentionRedLine", (4820, 1450, 125), (180, 1100, 20), "RED_ORANGE"),
    ("SecondaryInspectionPad", (4620, 1760, 106), (1250, 900, 10), "GOLD"),
    ("DetentionIntakePad", (5150, 1450, 106), (900, 1100, 10), "RED_ORANGE"),
    ("CellRearBand", (6200, 1450, 420), (70, 1050, 300), "MIDNIGHT_BLUE"),
    # Full-height glazing now has dark airport mullions and a grounded sill,
    # preserving the aircraft view while eliminating the open-void read.
    ("WindowSill", (2500, 3670, 155), (7800, 85, 120), "MIDNIGHT_BLUE"),
    ("WindowHeader", (2500, 3670, 1190), (7800, 85, 150), "MIDNIGHT_BLUE"),
    ("WindowMullion01", (-900, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion02", (100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion03", (1100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion04", (2100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion05", (3100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion06", (4100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion07", (5100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    ("WindowMullion08", (6100, 3670, 670), (85, 85, 1040), "MIDNIGHT_BLUE"),
    # The scan control stays outside the retained large detector's south pillar.
    ("LargeDetectorControlPedestal", (1050, -2010, 143), (100, 120, 110), "MIDNIGHT_BLUE"),
    ("LargeDetectorControlFace", (1050, -1946, 155), (80, 8, 45), "AQUA"),
    ("BagMachineAccent", (2525, -1325, 328), (125, 330, 18), "AQUA"),
    ("BagEntryFrameTop", (2525, -1325, 318), (125, 360, 40), "MIDNIGHT_BLUE"),
    ("BagEntryFrameNorth", (2525, -1155, 193), (125, 50, 210), "MIDNIGHT_BLUE"),
    ("BagEntryFrameSouth", (2525, -1495, 193), (125, 50, 210), "MIDNIGHT_BLUE"),
    ("XRayTrayInbound", (2175, -1325, 135), (650, 220, 12), "GRAY"),
    ("XRayTrayOutbound", (2825, -1325, 135), (550, 220, 12), "GRAY"),
    # Designed officer work surfaces tie the evidence stations together.
    ("DocumentDesk", (3400, 3350, 300), (950, 300, 420), "GRAY"),
    ("DocumentDeskFront", (3400, 3190, 285), (950, 55, 390), "MIDNIGHT_BLUE"),
    ("SecondaryWorktop", (4620, 1760, 260), (900, 520, 330), "GRAY"),
    ("SecondaryAmberStrip", (4620, 1495, 410), (900, 32, 55), "GOLD"),
    ("SecondaryPassengerConsole", (4230, 2040, 250), (420, 310, 390), "MIDNIGHT_BLUE"),
    ("SecondaryPassengerSignalA", (4230, 1870, 250), (290, 22, 105), "AQUA"),
    ("SecondaryBagSearchTable", (4590, 2040, 300), (560, 360, 430), "GRAY"),
    ("SecondaryBagHotspotA", (4480, 2040, 530), (95, 95, 24), "GOLD"),
    ("SecondaryBagHotspotB", (4590, 2040, 530), (95, 95, 24), "GOLD"),
    ("SecondaryBagHotspotC", (4700, 2040, 530), (95, 95, 24), "GOLD"),
    ("SecondaryRecordsConsole", (4860, 1860, 300), (380, 300, 470), "PACIFIC_BLUE"),
    ("SecondaryRecordsScreen", (4860, 1700, 430), (250, 22, 170), "AQUA"),
    ("DetentionIntakeTop", (5070, 1450, 350), (500, 760, 90), "GRAY"),
    ("DetentionGateStatus", (4920, 1450, 760), (35, 500, 120), "RED_ORANGE"),
    # Apron markings and stand guidance deepen the exterior airport identity.
    ("ApronCenterline", (5200, 5050, 105), (2600, 32, 8), "GOLD"),
    ("ApronStandBar", (5200, 4800, 105), (32, 1150, 8), "GOLD"),
    ("ApronEdgeStripe", (2500, 4200, 105), (7600, 38, 8), "WHITE"),
    # Physical actuation caps and cabinet indicators make the hidden device
    # backends read as deliberate airport controls at player eye height.
    ("DecisionDetainActuator", (4260, 760, 485), (150, 250, 95), "RED_ORANGE"),
    ("PowerMainIndicator", (3500, -2965, 520), (125, 24, 125), "RED_ORANGE"),
    ("PowerBackupIndicator", (3950, -2965, 520), (125, 24, 125), "GOLD"),
    ("PowerRestartIndicator", (4400, -2965, 520), (125, 24, 125), "AQUA"),
    # The detector itself is the focal portal; no second arch or queue gate is
    # allowed to compete with it along the walk-up.
    ("LargeDetectorResultTower", (1450, -650, 155.5), (100, 70, 135), "MIDNIGHT_BLUE"),
    ("LargeDetectorResultFace", (1396, -650, 178), (8, 55, 70), "AQUA"),
    ("XRayRollerInbound01", (1720, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayRollerInbound02", (1830, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayRollerInbound03", (1940, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayRollerOutbound01", (3260, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayRollerOutbound02", (3370, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayRollerOutbound03", (3480, -1300, 230), (58, 430, 22), "SILVER"),
    ("XRayOperatorBackplate", (2860, -815, 575), (560, 36, 470), "MIDNIGHT_BLUE"),
    ("XRayOperatorStatus", (2860, -790, 690), (410, 20, 120), "AQUA"),
    ("SecondaryGlassHeader", (4680, 2240, 1030), (1200, 80, 120), "GOLD"),
    ("SecondaryEntryLight", (4090, 1760, 730), (40, 640, 80), "GOLD"),
    ("DetentionBookingBackplate", (5160, 1450, 680), (34, 720, 420), "MIDNIGHT_BLUE"),
    ("DetentionBookingStatus", (5140, 1450, 760), (24, 500, 120), "RED_ORANGE"),
    ("PowerMainNameplate", (3500, -2968, 700), (270, 20, 90), "RED_ORANGE"),
    ("PowerBackupNameplate", (3950, -2968, 700), (270, 20, 90), "GOLD"),
    ("PowerRestartNameplate", (4400, -2968, 700), (270, 20, 90), "AQUA"),
    ("RestrictedCeilingGuide01", (2050, -3310, 1110), (500, 40, 50), "AQUA"),
    ("RestrictedCeilingGuide02", (2700, -3310, 1110), (500, 40, 50), "AQUA"),
    ("RestrictedCeilingGuide03", (3350, -3310, 1110), (500, 40, 50), "AQUA"),
]


# Rounded, two-layer physical actuators avoid placeholder cubes and make the
# red/green choice readable from the normal player position. Rims and caps are
# separated vertically, so no coplanar color surfaces can flicker.
SHAPES = [
    ("WestWindowPane", "glass", (-2200, 3775, 810), (1600, 36, 1000), "PACIFIC_BLUE"),
    ("CheckpointNoPassRim", "cylinder", (1385, -2200, 277), (150, 150, 36), "SILVER"),
    ("CheckpointNoPassCap", "cylinder", (1385, -2200, 297), (122, 122, 44), "RED_ORANGE"),
    ("CheckpointPassRim", "cylinder", (1615, -2200, 277), (150, 150, 36), "SILVER"),
    ("CheckpointPassCap", "cylinder", (1615, -2200, 297), (122, 122, 44), "APPLE_GREEN"),
]


LABELS = [
    ("CheckpointNoPassLabel", (1385, -2025, 405), "NO PASS\nSECONDARY"),
    ("CheckpointPassLabel", (1615, -2025, 405), "PASS\nCLEAR"),
]


PROPS = [
    # Airport-style seating groups replacing the visual reliance on block benches.
    ("WaitingBench01", "bench", (350, 3100, 110), 430.0, 0.0),
    ("WaitingBench02", "bench", (950, 3100, 110), 430.0, 0.0),
    ("WaitingBench03", "bench", (1550, 3100, 110), 430.0, 0.0),
    ("WaitingBench04", "bench", (2150, 3100, 110), 430.0, 0.0),
    ("WaitingBench05", "bench", (2900, 2700, 110), 430.0, 180.0),
    ("WaitingBench06", "bench", (3500, 2700, 110), 430.0, 180.0),
    ("WaitingBench07", "bench", (4100, 2700, 110), 430.0, 180.0),
    ("WaitingBench08", "bench", (4700, 2700, 110), 430.0, 180.0),
    ("PlanterWest", "planter", (-900, 3150, 110), 300.0, 0.0),
    ("PlanterCenter", "planter", (2500, 3250, 110), 300.0, 0.0),
    ("PlanterEast", "planter", (5000, 3150, 110), 300.0, 0.0),
    ("PlanterEntry", "planter", (-1100, 1100, 80), 260.0, 0.0),
    # The retained scanner is the open production arch above. The native Agency
    # scanner asset is a solid imaging panel, not a walk-through detector, and
    # is deliberately omitted so it cannot return on builder reruns.
    # Officer-facing technical props make the scanner/X-ray hierarchy legible.
    ("BagOperatorConsole", "monitor", (2700, -940, 365), 260.0, 180.0),
    ("DocumentOperatorConsole", "monitor", (3400, 3150, 365), 230.0, -90.0),
    ("BagMonitor", "monitor", (3040, -900, 390), 240.0, 180.0),
    ("DecisionMonitorDetain", "monitor", (4380, 760, 360), 220.0, 180.0),
    # Queue/back-of-house luggage density without touching active linked props.
    ("QueueBag01", "luggage_a", (-1800, -3000, 110), 115.0, 10.0),
    ("QueueBag02", "luggage_b", (-1100, -3000, 110), 125.0, -10.0),
    ("QueueBag03", "luggage_a", (-400, -3000, 110), 105.0, 18.0),
    ("ApproachSideBench01", "bench", (-2500, -3420, 110), 430.0, 180.0),
    ("ApproachSideBench02", "bench", (-1500, -3420, 110), 430.0, 180.0),
    ("ApproachSideBench03", "bench", (-500, -3420, 110), 430.0, 180.0),
    ("ApproachSidePlanterWest", "planter", (-2920, -3420, 110), 250.0, 0.0),
    ("ApproachSidePlanterEast", "planter", (50, -3420, 110), 250.0, 0.0),
    ("SecondaryRetainedBag", "luggage_b", (4720, 1780, 110), 135.0, 90.0),
    # Distinct power, office, and detention props from validated native classes.
    ("PowerServiceMonitor", "monitor", (3950, -3020, 370), 250.0, 0.0),
    ("PowerStatusLight", "emergency_light", (3950, -2860, 760), 180.0, 0.0),
    ("PowerElectricalCabinetA", "electrical_box", (3520, -3470, 110), 390.0, 0.0),
    ("PowerElectricalCabinetB", "electrical_box", (4380, -3470, 110), 390.0, 0.0),
    ("OfficeDeskSecond", "desk", (5750, -2850, 115), 760.0, 180.0),
    ("OfficeChairThird", "chair", (5850, -3070, 115), 150.0, 0.0),
    ("OfficeMonitorD", "monitor", (6020, -3280, 420), 230.0, 0.0),
    ("DetentionSecureDoor", "prison_door", (5050, 1450, 100), 930.0, 90.0),
    ("DetentionBed", "prison_bed", (5750, 1120, 110), 410.0, 90.0),
    ("DetentionSink", "prison_sink", (6060, 1730, 110), 105.0, -90.0),
    ("DetentionBenchNative", "cell_bench", (5640, 1840, 110), 310.0, 180.0),
    ("DetentionToilet", "prison_toilet", (6020, 1810, 105), 150.0, -90.0),
    ("DetentionEmergencyLight", "emergency_light", (5580, 1980, 810), 180.0, 180.0),
    # The reference pass already owns the validated belt-stanchion lanes.
    # Reusing that set avoids an overlapping second row of posts in the queue.
    # Modern grouped seating adds the denser waiting-area rhythm in the target.
    ("WaitingTripleSeatA", "triple_seat", (900, 2850, 105), 470.0, 0.0),
    ("WaitingTripleSeatB", "triple_seat", (1900, 2850, 105), 470.0, 0.0),
    ("WaitingTripleSeatC", "triple_seat", (-1800, 3200, 105), 470.0, 180.0),
    ("WaitingTripleSeatD", "triple_seat", (-800, 3200, 105), 470.0, 180.0),
    # Ceiling luminaires create a legible checkpoint spine and public-lounge bay.
    ("CeilingLightCheckpoint01", "ceiling_light", (-1900, -1300, 1250), 330.0, 0.0),
    ("CeilingLightCheckpoint02", "ceiling_light", (-650, -1300, 1250), 330.0, 0.0),
    ("CeilingLightCheckpoint03", "ceiling_light", (550, -1300, 1250), 330.0, 0.0),
    ("CeilingLightDecision", "ceiling_light", (4300, 0, 1250), 360.0, 90.0),
    ("CeilingLightLounge01", "ceiling_light", (800, 2800, 1250), 360.0, 0.0),
    ("CeilingLightLounge02", "ceiling_light", (2400, 2800, 1250), 360.0, 0.0),
    ("CeilingLightLounge03", "ceiling_light", (4000, 2800, 1250), 360.0, 0.0),
    # Three visibly distinct breaker cabinets support the multi-step outage.
    ("PowerBreakerMain", "breaker", (3500, -3090, 110), 310.0, 0.0),
    ("PowerBreakerBackup", "breaker", (3950, -3090, 110), 310.0, 0.0),
    ("PowerBreakerCheckpoint", "breaker", (4400, -3090, 110), 310.0, 0.0),
    # Secondary and document workstations now read as staffed inspections.
    ("DocumentDeskChair", "chair", (3400, 3530, 110), 150.0, 180.0),
    ("SecondaryDesk", "desk", (4620, 1760, 110), 720.0, 90.0),
    ("SecondaryChair", "chair", (4500, 2050, 110), 150.0, 180.0),
    ("SecondaryMonitor", "monitor", (4700, 1740, 430), 230.0, -90.0),
    # Wider red emergency coverage supports the outage/response state instead
    # of limiting the visual alarm to one back room.
    ("EmergencyLightCheckpoint", "emergency_light", (900, -1300, 1030), 180.0, 0.0),
    ("EmergencyLightBaggage", "emergency_light", (2750, -850, 980), 180.0, 0.0),
    ("EmergencyLightDecision", "emergency_light", (4300, 1100, 980), 180.0, 180.0),
    ("EmergencyLightSecondary", "emergency_light", (4650, 2180, 850), 180.0, 180.0),
    ("EmergencyLightPower", "emergency_light", (4200, -2900, 850), 180.0, 0.0),
    # Additional native detail creates the prop density and operational read of
    # the references without turning the route into another primitive blockout.
    ("QueueInfoMonitor", "monitor", (-2750, -3500, 720), 210.0, 0.0),
    ("LargeDetectorResultMonitor", "monitor", (1450, -650, 235), 110.0, -90.0),
    ("DecisionSupervisorChair", "chair", (4650, 3500, 110), 150.0, 180.0),
    ("DecisionEvidenceMonitor", "monitor", (4650, 3170, 620), 270.0, -90.0),
    ("WaitingCarryOnA", "luggage_b", (520, 3260, 110), 105.0, 12.0),
    ("WaitingCarryOnB", "luggage_a", (2350, 3200, 110), 110.0, -18.0),
    ("WaitingCarryOnC", "luggage_b", (4500, 2800, 110), 100.0, 5.0),
    ("OfficeMonitorE", "monitor", (6200, -2940, 430), 220.0, -90.0),
    ("RestrictedCorridorLightA", "ceiling_light", (2200, -3310, 1160), 280.0, 0.0),
    ("RestrictedCorridorLightB", "ceiling_light", (3150, -3310, 1160), 280.0, 0.0),
    ("PowerRoomEmergencyLightB", "emergency_light", (3700, -2900, 850), 180.0, 0.0),
]


DEVICE_SPECS = [
    ("TL_BTN_PowerBackup", (3950.0, -3190.0, 420.0), (0.0, 0.0, 0.0)),
    ("TL_BTN_PowerRestart", (4400.0, -3190.0, 420.0), (0.0, 0.0, 0.0)),
    ("TL_BTN_SecondaryPassenger", (4230.0, 1880.0, 320.0), (0.0, 0.0, 0.0)),
    ("TL_BTN_SecondaryBag", (4590.0, 1870.0, 390.0), (0.0, 0.0, 0.0)),
    ("TL_BTN_SecondaryRecords", (4860.0, 1690.0, 390.0), (0.0, 0.0, 0.0)),
]


NONBLOCKING_BOX_TOKENS = (
    "Flow", "Approach", "Rug", "InfoScreen", "Hazard", "Accent", "Light",
    "Status", "Ready", "Apron", "Stripe", "RedLine", "Threshold", "Pad",
    "Guide", "Backplate", "Roller", "Nameplate", "Divider", "Face", "Symbol",
)

# Reference and base passes can layer duplicate arches, solid imaging panels,
# a second inactive lane, and coplanar pads over the checkpoint. Retire those
# sources on every rerun; the single restored TL_PROD_LargeDetector frame above
# now owns the requested oversized wall-backed silhouette.
RETIRED_BLOCKING_ART_LABELS = {
    "TL_ART_ScannerSouth",
    "TL_ART_ScannerSouthPad",
    "TL_ART_ScannerNorthPad",
    "TL_ART_WalkthroughSouthLeft",
    "TL_ART_WalkthroughSouthRight",
    "TL_ART_WalkthroughSouthTop",
    "TL_ART_WalkthroughNorthLeft",
    "TL_ART_WalkthroughNorthRight",
    "TL_ART_WalkthroughNorthTop",
    "TL_ART_CheckpointSignBacking",
    "TL_ART_CheckpointSignCap",
    "TL_ART_BagBeltSouth",
    "TL_ART_BagRailSouthA",
    "TL_ART_BagRailSouthB",
    "TL_ART_BagXraySouthLeft",
    "TL_ART_BagXraySouthRight",
    "TL_ART_BagXraySouthTop",
    "TL_ART_BagBeltNorth",
    "TL_ART_BagRailNorthA",
    "TL_ART_BagRailNorthB",
    "TL_ART_BagXrayNorthLeft",
    "TL_ART_BagXrayNorthRight",
    "TL_ART_BagXrayNorthTop",
    "TL_GEO_LaneDivider",
    # Clear the long west-to-east detector sightline. Large inherited counters
    # and offset queue dressing are replaced by compact side-wall production
    # counters and the single centered approach authored above.
    "TL_ART_QueueLaneSouth",
    "TL_GEO_BriefingDesk",
    "TL_GEO_DocDesk",
    "TL_GEO_DecisionDesk",
    "TL_ART_DocumentCounter",
    "TL_ART_DocumentMonitorA",
    "TL_ART_DocumentMonitorB",
    "TL_ART_DecisionCounter",
    "TL_ART_DecisionHeader",
    "TL_ART_DecisionMonitorA",
    "TL_ART_DecisionMonitorB",
    "TL_ART_DecisionMonitorC",
}

RETIRED_BLOCKING_ART_PREFIXES = (
    "TL_GEO_QueueRail_",
    "TL_ART_QueueStanchionSouth",
)


world = unreal.EditorLevelLibrary.get_editor_world()
if world is None or "AirportSecurity" not in world.get_path_name():
    raise RuntimeError("Production pass refused outside AirportSecurity")

actors_before = all_actors()
EXISTING.update({a.get_actor_label(): a for a in actors_before if a.get_actor_label().startswith(PREFIX)})
existing_labels = set(EXISTING)

billboard_defaults_updated = []
for actor in actors_before:
    label = actor.get_actor_label()
    default_text = BILLBOARD_DEFAULTS.get(label)
    if default_text is None:
        continue
    try:
        actor.set_editor_property("text", default_text)
        billboard_defaults_updated.append(label)
    except Exception as exc:
        raise RuntimeError(f"Failed to author default billboard text for {label}: {exc}") from exc

missing_billboard_defaults = sorted(set(BILLBOARD_DEFAULTS) - set(billboard_defaults_updated))
if missing_billboard_defaults:
    raise RuntimeError(
        "Production pass could not find required billboard actors: "
        + ", ".join(missing_billboard_defaults)
    )

classes = {}
for key, path in CLASSES.items():
    loaded = unreal.load_class(None, path)
    if loaded is None:
        raise RuntimeError("Approved production class failed to load: " + path)
    classes[key] = loaded

shell_adjusted = []
for actor in actors_before:
    label = actor.get_actor_label()
    box_adjustment = SHELL_BOX_ADJUSTMENTS.get(label)
    if box_adjustment is not None:
        resize_existing_actor(actor, *box_adjustment)
        shell_adjusted.append(label)
        continue
    location_adjustment = SHELL_LOCATION_ADJUSTMENTS.get(label)
    if location_adjustment is not None:
        center_actor(actor, location_adjustment)
        shell_adjusted.append(label)

recolored = []
scanner_pad_adjustments = []
terminal_floor = next((actor for actor in actors_before if actor.get_actor_label() == "TL_ART_TerminalFloor"), None)
terminal_floor_top = None
if terminal_floor is not None:
    floor_origin, floor_extent = terminal_floor.get_actor_bounds(False)
    terminal_floor_top = floor_origin.z + floor_extent.z
for actor in actors_before:
    label = actor.get_actor_label()
    if not label.startswith("TL_ART_"):
        continue
    suffix = label.removeprefix("TL_ART_")
    color = ART_COLORS.get(suffix)
    if color and color_actor(actor, color):
        recolored.append(label)

created = []
for spec in BOXES:
    actor = spawn_box(classes, *spec)
    if any(token in spec[0] for token in NONBLOCKING_BOX_TOKENS):
        make_decorative_nonblocking(actor)
    created.append(actor.get_actor_label())
for spec in SHAPES:
    actor = spawn_shape(classes, *spec)
    make_decorative_nonblocking(actor)
    created.append(actor.get_actor_label())
for spec in LABELS:
    created.append(spawn_label(classes, *spec).get_actor_label())
for spec in PROPS:
    created.append(spawn_prop(classes, *spec).get_actor_label())

station_devices = []
for spec in DEVICE_SPECS:
    station_devices.append(spawn_device(classes, *spec).get_actor_label())

# Mount the wired scan button outside the retained large detector's south
# pillar so the full 740 cm aperture remains clear in both directions.
scan_button_relocated = False
for actor in all_actors():
    if actor.get_actor_label() == "TL_BTN_Scan":
        actor.set_actor_location(unreal.Vector(1050.0, -2010.0, 145.0), False, False)
        make_decorative_nonblocking(actor)
        scan_button_relocated = True
        break

# Reuse the authoritative, already-bound CLEAR and SECONDARY Button devices as
# PASS and NO PASS backends. Moving the existing actors preserves every Verse
# reference and avoids a parallel/fake decision system. Their stock meshes stay
# hidden beneath the modeled caps while normal Fortnite interaction remains.
decision_button_placements = {
    "TL_BTN_Clear": (1615.0, -2200.0, 295.0),
    "TL_BTN_Secondary": (1385.0, -2200.0, 295.0),
}
decision_buttons_relocated = []
for actor in all_actors():
    location = decision_button_placements.get(actor.get_actor_label())
    if location is None:
        continue
    actor.set_actor_location(unreal.Vector(*location), False, False)
    actor.set_actor_rotation(unreal.Rotator(pitch=0.0, yaw=0.0, roll=0.0), False)
    actor.set_actor_scale3d(unreal.Vector(0.72, 0.72, 0.72))
    try:
        actor.set_editor_property("visible_during_game", False)
    except Exception:
        pass
    make_decorative_nonblocking(actor)
    decision_buttons_relocated.append(actor.get_actor_label())

# Main, backup-bus, and checkpoint-restart controls stay independently placed
# at their matching physical cabinets. The latter two are newly wired below in
# the editor after this idempotent creation pass.
power_main_relocated = False
for actor in all_actors():
    if actor.get_actor_label() == "TL_BTN_Power":
        actor.set_actor_location(unreal.Vector(3500.0, -3190.0, 420.0), False, False)
        power_main_relocated = True
        break

spawn_pads_relocated = []
for actor in all_actors():
    placement = SPAWN_PLACEMENTS.get(actor.get_actor_label())
    if placement is None:
        continue
    actor.set_actor_location(unreal.Vector(*placement[:3]), False, False)
    actor.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=placement[3], roll=0.0),
        False,
    )
    spawn_pads_relocated.append(actor.get_actor_label())

missing_spawn_pads = sorted(set(SPAWN_PLACEMENTS) - set(spawn_pads_relocated))
if missing_spawn_pads:
    raise RuntimeError(
        "Production pass could not find required player spawn pads: "
        + ", ".join(missing_spawn_pads)
    )

walkup_actors_relocated = []
for actor in all_actors():
    placement = WALKUP_ACTOR_PLACEMENTS.get(actor.get_actor_label())
    if placement is None:
        continue
    actor.set_actor_location(unreal.Vector(*placement), False, False)
    walkup_actors_relocated.append(actor.get_actor_label())

missing_walkup_actors = sorted(set(WALKUP_ACTOR_PLACEMENTS) - set(walkup_actors_relocated))
if missing_walkup_actors:
    raise RuntimeError(
        "Production pass could not relocate required walk-up actors: "
        + ", ".join(missing_walkup_actors)
    )

# FortPlayerStartCreative proxies are generated with duplicate labels, so move
# them by their current Y ordering instead of pretending labels are unique.
creative_starts = sorted(
    (actor for actor in all_actors() if actor.get_class().get_name() == "FortPlayerStartCreative"),
    key=lambda actor: actor.get_actor_location().y,
)
creative_start_targets = [(-2750.0, -1450.0, 184.0), (-2750.0, -1150.0, 184.0)]
if len(creative_starts) != len(creative_start_targets):
    raise RuntimeError(
        f"Expected {len(creative_start_targets)} creative starts, found {len(creative_starts)}"
    )
for actor, placement in zip(creative_starts, creative_start_targets):
    actor.set_actor_location(unreal.Vector(*placement), False, False)
    actor.set_actor_rotation(unreal.Rotator(pitch=0.0, yaw=0.0, roll=0.0), False)

stale = sorted(EXISTING)
for label in stale:
    ACTORS.destroy_actor(EXISTING[label])

removed_blocking_art = []
for actor in all_actors():
    label = actor.get_actor_label()
    if label in RETIRED_BLOCKING_ART_LABELS or label.startswith(RETIRED_BLOCKING_ART_PREFIXES):
        removed_blocking_art.append(label)
        ACTORS.destroy_actor(actor)

# Retire the older couch bank so the validated agency benches become the single
# finished-looking waiting-area silhouette. No gameplay actor uses these props.
removed_old_seats = []
for actor in all_actors():
    if actor.get_actor_label().startswith("TL_ART_WaitingSeat"):
        removed_old_seats.append(actor.get_actor_label())
        ACTORS.destroy_actor(actor)

saved_level = unreal.EditorLevelLibrary.save_current_level()
saved_packages = unreal.EditorLoadingAndSavingUtils.save_dirty_packages(True, True)
unreal.EditorLevelLibrary.set_level_viewport_camera_info(
    unreal.Vector(-2850.0, -1300.0, 420.0),
    unreal.Rotator(pitch=-4.0, yaw=0.0, roll=0.0),
)

actors_after = all_actors()
labels = [actor.get_actor_label() for actor in actors_after]
duplicates = sorted({label for label in labels if label.startswith("TL_") and labels.count(label) > 1})
result = {
    "world": world.get_path_name(),
    "created": sum(1 for label in created if label not in existing_labels),
    "updated": sum(1 for label in created if label in existing_labels),
    "deleted_stale": len(stale),
    "shell_adjusted": sorted(shell_adjusted),
    "recolored_art_actors": len(recolored),
    "scanner_pad_adjustments": scanner_pad_adjustments,
    "scan_button_relocated": scan_button_relocated,
    "decision_buttons_relocated": sorted(decision_buttons_relocated),
    "power_main_relocated": power_main_relocated,
    "station_devices": sorted(station_devices),
    "spawn_pads_relocated": sorted(spawn_pads_relocated),
    "walkup_actors_relocated": sorted(walkup_actors_relocated),
    "creative_starts_relocated": len(creative_starts),
    "removed_blocking_art": sorted(removed_blocking_art),
    "removed_old_seats": len(removed_old_seats),
    "production_actor_count": len(created),
    "actor_count_before": len(actors_before),
    "actor_count_after": len(actors_after),
    "duplicate_tl_labels": duplicates,
    "billboard_defaults_updated": sorted(billboard_defaults_updated),
    "level_saved": bool(saved_level),
    "dirty_packages_saved": bool(saved_packages),
}
unreal.log("AIRPORT_PRODUCTION_PASS|" + repr(result))
print("AIRPORT_PRODUCTION_PASS|" + repr(result))
