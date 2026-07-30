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
    "security_scanner": "/Game/Athena/Apollo/Environments/BuildingActors/Agency/Props/Apollo_Agency_SecurityScanner_02.Apollo_Agency_SecurityScanner_02_C",
    "conveyor": "/Game/Environments/Apollo/Sets/Industrial/Props/Blueprints/Apollo_IND_ConveyorBelt_01.Apollo_IND_ConveyorBelt_01_C",
    "electrical_box": "/Game/Athena/Apollo/Environments/BuildingActors/Tinfoil/Props/Apollo_Tinfoil_ElectricalBox_01.Apollo_Tinfoil_ElectricalBox_01_C",
    "prison_bed": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_SingleBed_01.Apollo_SharkPrison_SingleBed_01_C",
    "prison_sink": "/Game/Athena/BuildingActors/Props/Building/ActorBlueprints/Containers/Athena_Prop_Prison_Bathroom_Sink.Athena_Prop_Prison_Bathroom_Sink_C",
    "cell_bench": "/Game/Environments/Helios/Props/Brimstone/Brimstone_Cell_Bench_A/Blueprints/BP_Brimstone_CellBench_A.BP_Brimstone_CellBench_A_C",
    "stanchion": "/Game/Environments/Helios/Props/Commerce/Commerce_BeltStanchion_A/Blueprints/BP_Commerce_BeltStanchion_A.BP_Commerce_BeltStanchion_A_C",
    "breaker": "/Game/Environments/Helios/Props/Coastal/Coastal_Breakers_A/Blueprints/BP_Coastal_Breaker_A.BP_Coastal_Breaker_A_C",
    "triple_seat": "/Game/Creative/Sets/ArtDeco_Bank/Props/CP_ArtDeco_Triple_Couch_B.CP_ArtDeco_Triple_Couch_B_C",
}


def all_actors():
    return list(ACTORS.get_all_level_actors())


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


# Solid Creative colors replace the stretched world-grid materials visible in
# the previous player build. This affects presentation only, never transforms.
ART_COLORS = {
    "TerminalFloor": "SILVER",
    "ExitFloor": "SILVER",
    "EntryFloor": "GRAY",
    "WaitingCarpet": "MIDNIGHT_BLUE",
    "DecisionZoneCarpet": "GRAY",
    "CorridorFloor": "MIDNIGHT_BLUE",
    "OfficeFloor": "MIDNIGHT_BLUE",
    "CellFloor": "GRAY",
    "ScannerSouthPad": "AQUA",
    "ScannerNorthPad": "AQUA",
    "QueueLaneSouth": "PACIFIC_BLUE",
    "QueueLaneNorth": "PACIFIC_BLUE",
    "BagBeltSouth": "BLACK",
    "BagBeltNorth": "BLACK",
    "DocumentCounter": "GRAY",
    "DecisionCounter": "BLACK",
    "CheckpointSignBacking": "GREEN",
    "PowerConsole": "GRAY",
    "DetentionIntake": "GRAY",
    "CellBench": "GRAY",
    "RunwayApron": "MIDNIGHT_BLUE",
    "RunwayStripeNear": "WHITE",
    "RunwayStripeFar": "GOLD",
    "StaffHeader": "MIDNIGHT_BLUE",
    "PowerHeader": "MIDNIGHT_BLUE",
    "OfficeHeader": "MIDNIGHT_BLUE",
    "DetentionHeader": "MIDNIGHT_BLUE",
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


BOXES = [
    # White ceiling coffers and cool structural rhythm: the terminal now reads
    # as an interior rather than an open blue box from the spawn camera.
    ("CeilingPanel01", (-500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel02", (500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel03", (1500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel04", (2500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel05", (3500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel06", (4500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel07", (5500, -2550, 1325), (850, 1500, 45), "WHITE"),
    ("CeilingPanel08", (-500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel09", (500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel10", (1500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel11", (2500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel12", (3500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel13", (4500, 200, 1325), (850, 3600, 45), "WHITE"),
    ("CeilingPanel14", (5500, 200, 1325), (850, 3600, 45), "WHITE"),
    # Public concourse color bands and deliberate floor flow.
    ("SouthWallBlueBand", (2500, -3735, 410), (7900, 55, 220), "PACIFIC_BLUE"),
    ("WestPortalBlueBand", (-1430, 0, 410), (55, 1850, 220), "PACIFIC_BLUE"),
    ("EastPortalBlueBand", (6430, 0, 410), (55, 1850, 220), "PACIFIC_BLUE"),
    ("PassengerFlow01", (-650, -2150, 108), (2200, 36, 8), "WHITE"),
    ("PassengerFlow02", (650, -1750, 108), (900, 36, 8), "WHITE", 35.0),
    ("PassengerFlow03", (1550, -1300, 108), (1000, 36, 8), "WHITE"),
    ("DepartureFlow", (4800, 1150, 108), (2800, 46, 8), "APPLE_GREEN"),
    ("DetentionFlow", (4550, 1450, 108), (1200, 46, 8), "RED_ORANGE"),
    # Strong checkpoint silhouette and officer-side separation.
    ("CheckpointHeader", (1120, -1300, 1110), (180, 1580, 250), "APPLE_GREEN"),
    ("ScannerSideLeft", (1120, -1670, 500), (180, 150, 840), "GRAY"),
    ("ScannerSideRight", (1120, -930, 500), (180, 150, 840), "GRAY"),
    ("ScannerCrown", (1120, -1300, 910), (180, 890, 150), "MIDNIGHT_BLUE"),
    ("BagMachineShell", (2480, -1300, 500), (720, 780, 720), "GRAY"),
    ("BagTunnelVoid", (2480, -1300, 455), (760, 470, 470), "BLACK"),
    ("OfficerBarrierA", (3400, -1030, 275), (1900, 90, 380), "MIDNIGHT_BLUE"),
    ("OfficerBarrierB", (3400, 1030, 275), (1900, 90, 380), "MIDNIGHT_BLUE"),
    # Integrated green/amber/red decision consoles around the wired buttons.
    ("ClearConsole", (4380, -760, 190), (760, 500, 300), "APPLE_GREEN"),
    ("SecondaryConsole", (4380, 0, 190), (760, 500, 300), "GOLD"),
    ("DetainConsole", (4380, 760, 190), (760, 500, 300), "RED_ORANGE"),
    ("DecisionDeskFront", (4800, 0, 320), (120, 2480, 520), "MIDNIGHT_BLUE"),
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
    ("OfficeTechWall", (6120, -3100, 630), (120, 900, 820), "MIDNIGHT_BLUE"),
    ("OfficeDeskRiser", (5550, -3300, 160), (1150, 520, 120), "GRAY"),
    # Detention intake and visible secure threshold.
    ("DetentionOuterFrameTop", (4890, 1450, 1120), (160, 1260, 170), "MIDNIGHT_BLUE"),
    ("DetentionOuterFrameNorth", (4890, 2020, 610), (160, 140, 1020), "MIDNIGHT_BLUE"),
    ("DetentionOuterFrameSouth", (4890, 880, 610), (160, 140, 1020), "MIDNIGHT_BLUE"),
    ("DetentionRedLine", (4820, 1450, 125), (180, 1100, 20), "RED_ORANGE"),
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
    # Scanner and X-ray accents are thin, nonblocking visual status elements.
    ("ScannerInnerLightLeft", (1115, -1572, 520), (195, 24, 670), "AQUA"),
    ("ScannerInnerLightRight", (1115, -1028, 520), (195, 24, 670), "AQUA"),
    ("ScannerReadyStrip", (1015, -1300, 915), (22, 500, 38), "APPLE_GREEN"),
    ("BagMachineAccent", (2110, -1300, 735), (35, 650, 55), "AQUA"),
    ("BagEntryFrameTop", (2020, -1300, 720), (130, 600, 100), "MIDNIGHT_BLUE"),
    ("BagEntryFrameNorth", (2020, -1035, 475), (130, 80, 490), "MIDNIGHT_BLUE"),
    ("BagEntryFrameSouth", (2020, -1565, 475), (130, 80, 490), "MIDNIGHT_BLUE"),
    # Designed officer work surfaces tie the evidence stations together.
    ("DocumentDesk", (3480, -520, 300), (950, 520, 420), "GRAY"),
    ("DocumentDeskFront", (3480, -260, 285), (950, 55, 390), "MIDNIGHT_BLUE"),
    ("SecondaryWorktop", (4620, 1760, 260), (900, 520, 330), "GRAY"),
    ("SecondaryAmberStrip", (4620, 1495, 410), (900, 32, 55), "GOLD"),
    ("DetentionIntakeTop", (5070, 1450, 350), (500, 760, 90), "GRAY"),
    ("DetentionGateStatus", (4920, 1450, 760), (35, 500, 120), "RED_ORANGE"),
    # Apron markings and stand guidance deepen the exterior airport identity.
    ("ApronCenterline", (5200, 5050, 105), (2600, 32, 8), "GOLD"),
    ("ApronStandBar", (5200, 4800, 105), (32, 1150, 8), "GOLD"),
    ("ApronEdgeStripe", (2500, 4200, 105), (7600, 38, 8), "WHITE"),
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
    # Native scanner and conveyors replace the weakest block-only silhouettes
    # while retaining the stable gameplay pad, button, and luggage transforms.
    # The native prop is a solid imaging panel, so it dresses the lane edge
    # instead of occupying the walk-through opening or its navigation path.
    ("NativeScanner", "security_scanner", (1120, -1700, 110), 600.0, 90.0),
    ("BagConveyorIn", "conveyor", (2050, -1300, 110), 590.0, 0.0),
    ("BagConveyorOut", "conveyor", (3200, -1300, 110), 590.0, 0.0),
    # Officer-facing technical props make the scanner/X-ray hierarchy legible.
    ("BagOperatorConsole", "monitor", (2700, -940, 365), 260.0, 180.0),
    ("DocumentOperatorConsole", "monitor", (3300, -560, 365), 230.0, 180.0),
    ("ScannerStatusLight", "emergency_light", (1120, -1300, 1010), 180.0, 0.0),
    ("BagMonitor", "monitor", (3040, -900, 390), 240.0, 180.0),
    ("DecisionMonitorClear", "monitor", (4380, -760, 360), 220.0, 180.0),
    ("DecisionMonitorSecondary", "monitor", (4380, 0, 360), 220.0, 180.0),
    ("DecisionMonitorDetain", "monitor", (4380, 760, 360), 220.0, 180.0),
    # Queue/back-of-house luggage density without touching active linked props.
    ("QueueBag01", "luggage_a", (-1850, -2570, 110), 115.0, 10.0),
    ("QueueBag02", "luggage_b", (-1350, -2570, 110), 125.0, -10.0),
    ("QueueBag03", "luggage_a", (-850, -2570, 110), 105.0, 18.0),
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
    # A second native panel completes the walk-through scanner silhouette.
    ("NativeScannerRight", "security_scanner", (1120, -900, 110), 600.0, -90.0),
    # Airport queue hardware frames four visible positions without occupying
    # the active route centerline.
    ("QueuePostSouth01", "stanchion", (-2200, -2520, 105), 145.0, 0.0),
    ("QueuePostSouth02", "stanchion", (-1600, -2520, 105), 145.0, 0.0),
    ("QueuePostSouth03", "stanchion", (-1000, -2520, 105), 145.0, 0.0),
    ("QueuePostSouth04", "stanchion", (-400, -2520, 105), 145.0, 0.0),
    ("QueuePostSouth05", "stanchion", (200, -2520, 105), 145.0, 0.0),
    ("QueuePostNorth01", "stanchion", (-2200, -1780, 105), 145.0, 180.0),
    ("QueuePostNorth02", "stanchion", (-1600, -1780, 105), 145.0, 180.0),
    ("QueuePostNorth03", "stanchion", (-1000, -1780, 105), 145.0, 180.0),
    ("QueuePostNorth04", "stanchion", (-400, -1780, 105), 145.0, 180.0),
    ("QueuePostNorth05", "stanchion", (200, -1780, 105), 145.0, 180.0),
    # Modern grouped seating adds the denser waiting-area rhythm in the target.
    ("WaitingTripleSeatA", "triple_seat", (900, 2850, 105), 470.0, 0.0),
    ("WaitingTripleSeatB", "triple_seat", (1900, 2850, 105), 470.0, 0.0),
    ("WaitingTripleSeatC", "triple_seat", (3200, 3150, 105), 470.0, 180.0),
    ("WaitingTripleSeatD", "triple_seat", (4200, 3150, 105), 470.0, 180.0),
    # Ceiling luminaires create a legible checkpoint spine and public-lounge bay.
    ("CeilingLightCheckpoint01", "ceiling_light", (200, -2300, 1250), 330.0, 0.0),
    ("CeilingLightCheckpoint02", "ceiling_light", (1400, -1900, 1250), 330.0, 0.0),
    ("CeilingLightCheckpoint03", "ceiling_light", (2600, -1400, 1250), 330.0, 0.0),
    ("CeilingLightDecision", "ceiling_light", (4300, 0, 1250), 360.0, 90.0),
    ("CeilingLightLounge01", "ceiling_light", (800, 2800, 1250), 360.0, 0.0),
    ("CeilingLightLounge02", "ceiling_light", (2400, 2800, 1250), 360.0, 0.0),
    ("CeilingLightLounge03", "ceiling_light", (4000, 2800, 1250), 360.0, 0.0),
    # Three visibly distinct breaker cabinets support the multi-step outage.
    ("PowerBreakerMain", "breaker", (3500, -3090, 110), 310.0, 0.0),
    ("PowerBreakerBackup", "breaker", (3950, -3090, 110), 310.0, 0.0),
    ("PowerBreakerCheckpoint", "breaker", (4400, -3090, 110), 310.0, 0.0),
    # Secondary and document workstations now read as staffed inspections.
    ("DocumentDeskChair", "chair", (3480, -850, 110), 150.0, 0.0),
    ("SecondaryDesk", "desk", (4620, 1760, 110), 720.0, 90.0),
    ("SecondaryChair", "chair", (4500, 2050, 110), 150.0, 180.0),
    ("SecondaryMonitor", "monitor", (4700, 1740, 430), 230.0, -90.0),
]


NONBLOCKING_BOX_TOKENS = (
    "Flow", "Rug", "InfoScreen", "Hazard", "Accent", "Light",
    "Status", "Apron", "Stripe", "RedLine", "Threshold",
)


world = unreal.EditorLevelLibrary.get_editor_world()
if world is None or "AirportSecurity" not in world.get_path_name():
    raise RuntimeError("Production pass refused outside AirportSecurity")

actors_before = all_actors()
EXISTING.update({a.get_actor_label(): a for a in actors_before if a.get_actor_label().startswith(PREFIX)})
existing_labels = set(EXISTING)

classes = {}
for key, path in CLASSES.items():
    loaded = unreal.load_class(None, path)
    if loaded is None:
        raise RuntimeError("Approved production class failed to load: " + path)
    classes[key] = loaded

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
    if suffix in ("ScannerSouthPad", "ScannerNorthPad") and terminal_floor_top is not None:
        pad_origin, pad_extent = actor.get_actor_bounds(False)
        location = actor.get_actor_location()
        desired_origin_z = terminal_floor_top - pad_extent.z
        actor.set_actor_location(
            unreal.Vector(location.x, location.y, location.z + desired_origin_z - pad_origin.z),
            False,
            False,
        )
        make_decorative_nonblocking(actor)
        adjusted_origin, adjusted_extent = actor.get_actor_bounds(False)
        scanner_pad_adjustments.append(
            {
                "label": label,
                "top": round(adjusted_origin.z + adjusted_extent.z, 3),
                "floor_top": round(terminal_floor_top, 3),
            }
        )

created = []
for spec in BOXES:
    actor = spawn_box(classes, *spec)
    if any(token in spec[0] for token in NONBLOCKING_BOX_TOKENS):
        make_decorative_nonblocking(actor)
    created.append(actor.get_actor_label())
for spec in PROPS:
    created.append(spawn_prop(classes, *spec).get_actor_label())

# The wired scan button was previously centered in the walk-through opening.
# Keep it as the reliable interaction fallback, but mount it beside the arch so
# the full scanner aperture is clear in both directions.
scan_button_relocated = False
for actor in all_actors():
    if actor.get_actor_label() == "TL_BTN_Scan":
        actor.set_actor_location(unreal.Vector(1120.0, -1850.0, 180.0), False, False)
        scan_button_relocated = True
        break

stale = sorted(EXISTING)
for label in stale:
    ACTORS.destroy_actor(EXISTING[label])

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
    unreal.Vector(-950.0, 3000.0, 620.0),
    unreal.Rotator(pitch=-5.0, yaw=-8.0, roll=0.0),
)

actors_after = all_actors()
labels = [actor.get_actor_label() for actor in actors_after]
duplicates = sorted({label for label in labels if label.startswith("TL_") and labels.count(label) > 1})
result = {
    "world": world.get_path_name(),
    "created": sum(1 for label in created if label not in existing_labels),
    "updated": sum(1 for label in created if label in existing_labels),
    "deleted_stale": len(stale),
    "recolored_art_actors": len(recolored),
    "scanner_pad_adjustments": scanner_pad_adjustments,
    "scan_button_relocated": scan_button_relocated,
    "removed_old_seats": len(removed_old_seats),
    "production_actor_count": len(created),
    "actor_count_before": len(actors_before),
    "actor_count_after": len(actors_after),
    "duplicate_tl_labels": duplicates,
    "level_saved": bool(saved_level),
    "dirty_packages_saved": bool(saved_packages),
}
