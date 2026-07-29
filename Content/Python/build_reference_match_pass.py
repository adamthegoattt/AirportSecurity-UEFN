"""Idempotent reference-match environment pass for AirportSecurity.

The pass preserves the tested gameplay devices and Verse wiring while replacing
the highest-impact placeholder silhouettes with proved Fortnite-native props.
The original GridPlane shell remains only where it provides useful collision.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
PREFIX = "TL_ART_"
FOLDER = unreal.Name("TerminalLockdown/ReferenceMatch")
EXISTING_BY_LABEL = {}

# Spawn transforms are named because they are presentation-critical and must
# survive every idempotent reference-pass rerun. Both lanes sit on the open
# entry apron and face east into the checkpoint hall. They start beside the
# START SHIFT control so onboarding is immediate while still presenting the
# checkpoint through the wide central opening.
SPAWN_PAD_TRANSFORMS = (
    ((-1180, -180, 64), 0.0),
    ((-1180, 180, 64), 0.0),
)
PLAYER_START_TRANSFORMS = (
    ((-1180, -180, 180), 0.0),
    ((-1180, 180, 180), 0.0),
)

CLASSES = {
    "primitive": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "sphere": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Sphere_Solid.CP_Primitive_Sphere_Solid_C",
    "smooth_wall": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "glass": "/Game/Creative/Sets/Glass/Props/CP_Glass_PropWall.CP_Glass_PropWall_C",
    "beam": "/Game/Creative/Items/Building_Parts/MetalBeams/CP_Metal_I_Bar.CP_Metal_I_Bar_C",
    "seat": "/Game/Creative/Sets/ArtDeco_Bank/Props/CP_ArtDeco_Triple_Couch_B.CP_ArtDeco_Triple_Couch_B_C",
    "desk": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Desk_02.Apollo_Office_Desk_02_C",
    "monitor": "/Game/Environments/Asteria/Props/Office/Office_Monitors_A/Blueprints/Asteria_Office_Monitor_A.Asteria_Office_Monitor_A_C",
    "power": "/Game/Building/ActorBlueprints/Prop/PowerTransformer01.PowerTransformer01_C",
    "cell": "/Game/Creative/BuildingActors/Props/Prop_CellDoor.Prop_CellDoor_C",
    "scanner": "/Game/Athena/Apollo/Environments/BuildingActors/Agency/Props/Apollo_Agency_SecurityScanner_02.Apollo_Agency_SecurityScanner_02_C",
    "stanchion": "/Game/Environments/Helios/Props/Commerce/Commerce_BeltStanchion_A/Blueprints/BP_Commerce_BeltStanchion_A.BP_Commerce_BeltStanchion_A_C",
    "luggage_a": "/Game/Environments/Asteria/Props/Commerce/Commerce_Luggage_A/Blueprints/BP_Commerce_Luggage_A_A.BP_Commerce_Luggage_A_A_C",
    "luggage_b": "/Game/Environments/Asteria/Props/Commerce/Commerce_Luggage_A/Blueprints/BP_Commerce_Luggage_B_B.BP_Commerce_Luggage_B_B_C",
    "ceiling_light": "/Game/Creative/BuildingActors/Props/CP_Yacht_Ceiling_Light.CP_Yacht_Ceiling_Light_C",
    "emergency_light": "/Game/Creative/BuildingActors/Props/CP_Apollo_TrainTunnelEmergency_Light.CP_Apollo_TrainTunnelEmergency_Light_C",
    "aircraft_fuselage": "/Game/Athena/Apollo/Environments/BuildingActors/TaskForce/Props/Apollo_Airplane_Broken_Fuselage_01.Apollo_Airplane_Broken_Fuselage_01_C",
    "aircraft_nose": "/Game/Athena/Apollo/Environments/BuildingActors/TaskForce/Props/Apollo_Airplane_Broken_Nose_01.Apollo_Airplane_Broken_Nose_01_C",
    "aircraft_wing": "/Game/Athena/Apollo/Environments/BuildingActors/TaskForce/Props/Apollo_Airplane_Broken_Wing_01.Apollo_Airplane_Broken_Wing_01_C",
    "aircraft_tail": "/Game/Athena/Apollo/Environments/BuildingActors/TaskForce/Props/Apollo_Airplane_Broken_Tail_01.Apollo_Airplane_Broken_Tail_01_C",
    "aircraft_engine": "/Game/Athena/Apollo/Environments/BuildingActors/TaskForce/Props/Apollo_Airplane_Broken_Engine_01.Apollo_Airplane_Broken_Engine_01_C",
    "office_chair": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Chair_01.Apollo_Office_Chair_01_C",
    "prison_bed": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_SingleBed_01.Apollo_SharkPrison_SingleBed_01_C",
}

MATERIALS = {
    "marble_white": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_White.MI_Primitive_WorldGrid_Marble_White",
    "marble_beige": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_Beige.MI_Primitive_WorldGrid_Marble_Beige",
    "marble_gray": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_Gray.MI_Primitive_WorldGrid_Marble_Gray",
    "concrete": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Concrete.MI_Primitive_WorldGrid_Concrete",
    "carbon_fiber": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_CarbonFiber.MI_Primitive_WorldGrid_CarbonFiber",
    "ice": "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Ice.MI_Primitive_WorldGrid_Ice",
}

# Project-owned surface actors receive explicit Fortnite-native finishes instead
# of the default white primitive material. Names are exact and therefore safe to
# reapply on every idempotent pass.
SURFACE_MATERIALS = {
    "TerminalFloor": "concrete",
    "ExitFloor": "concrete",
    "EntryFloor": "marble_beige",
    "WaitingCarpet": "carbon_fiber",
    "DecisionZoneCarpet": "carbon_fiber",
    "CorridorFloor": "carbon_fiber",
    "OfficeFloor": "carbon_fiber",
    "CellFloor": "carbon_fiber",
    "ScannerSouthPad": "ice",
    "ScannerNorthPad": "ice",
    "QueueLaneSouth": "marble_gray",
    "QueueLaneNorth": "marble_gray",
    "BagBeltSouth": "carbon_fiber",
    "BagBeltNorth": "carbon_fiber",
    "DocumentCounter": "marble_gray",
    "DecisionCounter": "marble_gray",
    "CheckpointSignBacking": "carbon_fiber",
    "PowerConsole": "marble_gray",
    "DetentionIntake": "marble_gray",
    "CellBench": "marble_gray",
    "PowerWallWest": "concrete",
    "PowerWallEast": "concrete",
    "PowerWallNorth": "concrete",
    "CellWallEast": "concrete",
    "CellWallNorth": "concrete",
    "CellWallSouth": "concrete",
    "CorridorWallSouth": "concrete",
    "CorridorWallNorth": "concrete",
    "RunwayApron": "concrete",
    "RunwayStripeNear": "marble_white",
    "RunwayStripeFar": "marble_white",
    "StaffHeader": "carbon_fiber",
    "PowerHeader": "carbon_fiber",
    "OfficeHeader": "carbon_fiber",
    "DetentionHeader": "carbon_fiber",
    "AircraftBody": "marble_white",
    "AircraftWing": "marble_white",
    "AircraftTailWing": "marble_white",
    "AircraftTailFin": "marble_white",
    "AircraftEngineNear": "marble_gray",
    "AircraftEngineFar": "marble_gray",
    "AircraftCockpit": "carbon_fiber",
    "AircraftDoor": "carbon_fiber",
    "AircraftWindow01": "carbon_fiber",
    "AircraftWindow02": "carbon_fiber",
    "AircraftWindow03": "carbon_fiber",
    "AircraftWindow04": "carbon_fiber",
    "AircraftWindow05": "carbon_fiber",
    "AircraftWindow06": "carbon_fiber",
    "AircraftWindow07": "carbon_fiber",
    "AircraftWindow08": "carbon_fiber",
}

ARCHITECTURE = [
    # Bright public floor and lower-wall lining.
    ("TerminalFloor", "primitive", (2500, 0, 76), (7800, 7600, 24), 0),
    ("ExitFloor", "primitive", (6700, 0, 96), (2100, 3500, 24), 0),
    ("EntryFloor", "primitive", (-1700, 0, 58), (1700, 2500, 20), 0),
    ("WaitingCarpet", "primitive", (2250, 2820, 93), (4600, 1550, 8), 0),
    ("DecisionZoneCarpet", "primitive", (4100, 0, 93), (2500, 3000, 8), 0),
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
    # Thin ceiling strips break up the gray roof mass like the reference fixtures.
    ("CeilingStripNorthA", "primitive", (600, 2100, 1300), (1450, 42, 32), 0),
    ("CeilingStripNorthB", "primitive", (2600, 2100, 1300), (1450, 42, 32), 0),
    ("CeilingStripNorthC", "primitive", (4600, 2100, 1300), (1450, 42, 32), 0),
    ("CeilingStripSouthA", "primitive", (600, -2100, 1300), (1450, 42, 32), 0),
    ("CeilingStripSouthB", "primitive", (2600, -2100, 1300), (1450, 42, 32), 0),
    ("CeilingStripSouthC", "primitive", (4600, -2100, 1300), (1450, 42, 32), 0),
    # Open runway glazing line with dark mullions. The opening preserves the
    # floor-to-ceiling airport-window silhouette without an opaque prop pane.
    ("WindowHead", "beam", (2500, 3750, 1320), (8000, 90, 90), 0),
    ("MullionA", "beam", (-1450, 3750, 810), (70, 70, 1120), 0),
    ("MullionB", "beam", (-100, 3750, 810), (70, 70, 1120), 0),
    ("MullionC", "beam", (1300, 3750, 810), (70, 70, 1120), 0),
    ("MullionD", "beam", (2700, 3750, 810), (70, 70, 1120), 0),
    ("MullionE", "beam", (4100, 3750, 810), (70, 70, 1120), 0),
    ("MullionF", "beam", (5500, 3750, 810), (70, 70, 1120), 0),
    ("MullionG", "beam", (6450, 3750, 810), (70, 70, 1120), 0),
    # The pilot pane passed placement/save inspection, so the same approved
    # class now completes the full blue-tinted runway wall.
    ("WindowA", "glass", (-800, 3775, 810), (1200, 36, 1000), 0),
    ("WindowB", "glass", (600, 3775, 810), (1200, 36, 1000), 0),
    ("WindowC", "glass", (2000, 3775, 810), (1200, 36, 1000), 0),
    ("WindowD", "glass", (3400, 3775, 810), (1200, 36, 1000), 0),
    ("WindowE", "glass", (4800, 3775, 810), (1200, 36, 1000), 0),
    ("WindowF", "glass", (6100, 3775, 810), (700, 36, 1000), 0),
    # A real apron beneath the aircraft prevents the exterior from reading as
    # an empty skybox and gives the window view strong runway striping.
    ("RunwayApron", "primitive", (2500, 5200, 72), (8000, 2700, 24), 0),
    ("RunwayStripeNear", "primitive", (2500, 4450, 87), (7600, 45, 6), 0),
    ("RunwayStripeFar", "primitive", (2500, 6100, 87), (7600, 45, 6), 0),
    # A clean passenger-aircraft silhouette. The previous broken-plane kit
    # exposed a torn fuselage ring through the terminal window and read as a
    # crash scene. These approved primitives produce a continuous jet body,
    # side windows, wings, engines, and tail from the public viewing angle.
    ("AircraftBody", "sphere", (2750, 5700, 430), (3300, 520, 520), 0),
    ("AircraftWing", "primitive", (2750, 5700, 300), (1450, 1750, 70), 0),
    ("AircraftTailWing", "primitive", (1450, 5700, 470), (700, 1050, 55), 0),
    ("AircraftTailFin", "primitive", (1450, 5700, 710), (520, 65, 520), 0),
    ("AircraftEngineNear", "sphere", (3050, 5200, 230), (520, 280, 280), 0),
    ("AircraftEngineFar", "sphere", (3050, 6200, 230), (520, 280, 280), 0),
    ("AircraftCockpit", "sphere", (4220, 5435, 480), (300, 34, 125), 0),
    ("AircraftDoor", "primitive", (3770, 5432, 390), (115, 28, 240), 0),
    ("AircraftWindow01", "primitive", (3450, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow02", "primitive", (3240, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow03", "primitive", (3030, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow04", "primitive", (2820, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow05", "primitive", (2610, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow06", "primitive", (2400, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow07", "primitive", (2190, 5430, 480), (95, 26, 62), 0),
    ("AircraftWindow08", "primitive", (1980, 5430, 480), (95, 26, 62), 0),
    # Checkpoint hierarchy, floor guidance, and X-ray portals.
    ("CheckpointSignBacking", "primitive", (1080, -1300, 1120), (120, 1500, 300), 0),
    ("CheckpointSignCap", "beam", (1080, -1300, 1300), (150, 1580, 70), 0),
    ("ScannerSouthPad", "primitive", (1050, -1300, 96), (720, 900, 12), 0),
    ("ScannerNorthPad", "primitive", (1050, 1300, 96), (720, 900, 12), 0),
    ("WalkthroughSouthLeft", "beam", (1050, -1620, 500), (120, 100, 820), 0),
    ("WalkthroughSouthRight", "beam", (1050, -980, 500), (120, 100, 820), 0),
    ("WalkthroughSouthTop", "beam", (1050, -1300, 910), (120, 740, 120), 0),
    ("WalkthroughNorthLeft", "beam", (1050, 980, 500), (120, 100, 820), 0),
    ("WalkthroughNorthRight", "beam", (1050, 1620, 500), (120, 100, 820), 0),
    ("WalkthroughNorthTop", "beam", (1050, 1300, 910), (120, 740, 120), 0),
    ("QueueLaneSouth", "primitive", (-550, -2150, 94), (2300, 620, 10), 0),
    ("QueueLaneNorth", "primitive", (-550, 2150, 94), (2300, 620, 10), 0),
    ("BagBeltSouth", "primitive", (2200, -1300, 165), (1500, 650, 300), 0),
    ("BagBeltNorth", "primitive", (2200, 1300, 165), (1500, 650, 300), 0),
    ("BagRailSouthA", "beam", (2200, -1590, 360), (1500, 50, 150), 0),
    ("BagRailSouthB", "beam", (2200, -1010, 360), (1500, 50, 150), 0),
    ("BagRailNorthA", "beam", (2200, 1010, 360), (1500, 50, 150), 0),
    ("BagRailNorthB", "beam", (2200, 1590, 360), (1500, 50, 150), 0),
    ("BagXraySouthLeft", "beam", (2500, -1580, 520), (420, 70, 650), 0),
    ("BagXraySouthRight", "beam", (2500, -1020, 520), (420, 70, 650), 0),
    ("BagXraySouthTop", "beam", (2500, -1300, 830), (420, 650, 70), 0),
    ("BagXrayNorthLeft", "beam", (2500, 1020, 520), (420, 70, 650), 0),
    ("BagXrayNorthRight", "beam", (2500, 1580, 520), (420, 70, 650), 0),
    ("BagXrayNorthTop", "beam", (2500, 1300, 830), (420, 650, 70), 0),
    ("DocumentCounter", "primitive", (3250, 0, 185), (850, 1700, 340), 0),
    ("DecisionCounter", "primitive", (4350, 0, 185), (900, 2500, 340), 0),
    ("DecisionHeader", "beam", (4350, 0, 1020), (140, 2600, 100), 0),
    # Restricted corridor surfaces and airport-like support-room enclosures.
    ("CorridorFloor", "primitive", (2450, -3320, 102), (3100, 720, 24), 0),
    ("CorridorCeiling", "primitive", (2450, -3320, 1160), (3100, 720, 80), 0),
    ("CorridorWallSouth", "smooth_wall", (2450, -3670, 580), (3100, 70, 1120), 0),
    ("CorridorWallNorth", "smooth_wall", (2150, -2970, 580), (2100, 70, 1120), 0),
    ("StaffHeader", "primitive", (1450, -3320, 980), (100, 620, 180), 0),
    ("PowerWallWest", "smooth_wall", (3350, -3340, 580), (70, 1000, 1120), 90),
    ("PowerWallEast", "smooth_wall", (4550, -3340, 580), (70, 1000, 1120), 90),
    ("PowerWallNorth", "smooth_wall", (3950, -2860, 580), (1280, 70, 1120), 0),
    ("PowerConsole", "primitive", (3950, -3030, 180), (520, 220, 320), 0),
    ("PowerHeader", "primitive", (3950, -2880, 980), (900, 70, 180), 0),
    ("OfficeFloor", "primitive", (5550, -3100, 112), (1650, 1250, 24), 0),
    ("OfficeCabinet", "primitive", (6200, -3100, 320), (240, 800, 600), 0),
    ("ResponseSupplyRack", "primitive", (5850, -2400, 300), (620, 260, 560), 0),
    ("OfficeHeader", "primitive", (5550, -2520, 980), (1000, 70, 180), 0),
    ("CellFloor", "primitive", (5550, 1450, 100), (1500, 1250, 24), 0),
    ("DetentionIntake", "primitive", (4660, 1450, 180), (320, 700, 320), 0),
    ("DetentionHeader", "primitive", (4890, 1450, 1120), (100, 1160, 170), 0),
    ("CellBench", "primitive", (5950, 1450, 160), (450, 300, 140), 0),
    ("CellWallEast", "smooth_wall", (6280, 1450, 580), (70, 1250, 1120), 90),
    ("CellWallNorth", "smooth_wall", (5550, 2030, 580), (1500, 70, 1120), 0),
    ("CellWallSouth", "smooth_wall", (5550, 870, 580), (1500, 70, 1120), 0),
    ("CellBarTop", "beam", (4890, 1450, 1030), (90, 1160, 90), 0),
    ("CellBarNorth", "beam", (4890, 1980, 560), (90, 90, 980), 0),
    ("CellBarSouth", "beam", (4890, 920, 560), (90, 90, 980), 0),
]

PROPS = [
    # Pilot one native scanner in the active south lane. The surrounding arch
    # remains as the stable collision/readability fallback during validation.
    ("ScannerSouth", "scanner", (2200, -1300, 90), 760, 0),
    # Belt stanchions make the active traveler queue read immediately at eye level.
    ("QueueStanchionSouth01", "stanchion", (-2100, -1850, 90), 130, 0),
    ("QueueStanchionSouth02", "stanchion", (-1600, -1850, 90), 130, 0),
    ("QueueStanchionSouth03", "stanchion", (-1100, -1850, 90), 130, 0),
    ("QueueStanchionSouth04", "stanchion", (-600, -1850, 90), 130, 0),
    ("QueueStanchionSouth05", "stanchion", (-100, -1850, 90), 130, 0),
    ("QueueStanchionSouth06", "stanchion", (-2100, -2450, 90), 130, 180),
    ("QueueStanchionSouth07", "stanchion", (-1600, -2450, 90), 130, 180),
    ("QueueStanchionSouth08", "stanchion", (-1100, -2450, 90), 130, 180),
    ("QueueStanchionSouth09", "stanchion", (-600, -2450, 90), 130, 180),
    ("QueueStanchionSouth10", "stanchion", (-100, -2450, 90), 130, 180),
    ("QueueStanchionNorth01", "stanchion", (-1850, 1850, 90), 130, 0),
    ("QueueStanchionNorth02", "stanchion", (-1200, 1850, 90), 130, 0),
    ("QueueStanchionNorth03", "stanchion", (-550, 1850, 90), 130, 0),
    ("QueueStanchionNorth04", "stanchion", (-1850, 2450, 90), 130, 180),
    ("QueueStanchionNorth05", "stanchion", (-1200, 2450, 90), 130, 180),
    ("QueueStanchionNorth06", "stanchion", (-550, 2450, 90), 130, 180),
    # Two orderly banks establish the waiting lounge seen in the wide references.
    ("WaitingSeatA", "seat", (250, 3050, 90), 720, 0),
    ("WaitingSeatB", "seat", (1150, 3050, 90), 720, 0),
    ("WaitingSeatC", "seat", (2050, 3050, 90), 720, 0),
    ("WaitingSeatD", "seat", (2950, 3050, 90), 720, 0),
    ("WaitingSeatE", "seat", (3850, 3050, 90), 720, 0),
    ("WaitingSeatF", "seat", (700, 2450, 90), 720, 180),
    ("WaitingSeatG", "seat", (1600, 2450, 90), 720, 180),
    ("WaitingSeatH", "seat", (2500, 2450, 90), 720, 180),
    ("WaitingSeatI", "seat", (3400, 2450, 90), 720, 180),
    # Recognizable luggage gives the X-ray lane and waiting zone real ownership cues.
    ("WaitingBagA", "luggage_a", (200, 2200, 90), 120, 15),
    ("WaitingBagB", "luggage_b", (820, 2200, 90), 145, -15),
    ("WaitingBagC", "luggage_a", (1450, 2200, 90), 110, 20),
    ("NorthBeltBagA", "luggage_a", (1600, 1300, 315), 105, 90),
    ("NorthBeltBagB", "luggage_b", (2050, 1300, 315), 125, 90),
    ("NorthBeltBagC", "luggage_a", (2750, 1300, 315), 95, 90),
    # Native monitor props give each processing counter a readable workstation.
    ("DocumentMonitorA", "monitor", (3250, -520, 355), 220, 180),
    ("DocumentMonitorB", "monitor", (3250, 520, 355), 220, 180),
    ("DecisionMonitorA", "monitor", (4350, -820, 355), 220, 180),
    ("DecisionMonitorB", "monitor", (4350, 0, 355), 220, 180),
    ("DecisionMonitorC", "monitor", (4350, 820, 355), 220, 180),
    ("OfficeDesk", "desk", (5550, -3230, 115), 900, 0),
    ("OfficeMonitorA", "monitor", (5250, -3400, 420), 240, 0),
    ("OfficeMonitorB", "monitor", (5550, -3400, 420), 240, 0),
    ("OfficeMonitorC", "monitor", (5850, -3400, 420), 240, 0),
    ("OfficeChairA", "office_chair", (5300, -2980, 110), 150, 180),
    ("OfficeChairB", "office_chair", (5750, -2980, 110), 150, 180),
    ("PowerTransformerA", "power", (3600, -3430, 110), 430, 0),
    ("PowerTransformerB", "power", (3950, -3430, 110), 430, 0),
    ("PowerTransformerC", "power", (4300, -3430, 110), 430, 0),
    ("DetentionDoor", "cell", (4890, 1450, 100), 1050, 90),
    ("DetentionBed", "prison_bed", (5920, 1550, 105), 250, 90),
    # Physical ceiling and corridor fixtures establish normal and emergency layers.
    ("CeilingLight01", "ceiling_light", (0, -2200, 1170), 210, 0),
    ("CeilingLight02", "ceiling_light", (0, 2200, 1170), 210, 0),
    ("CeilingLight03", "ceiling_light", (1500, -2200, 1170), 210, 0),
    ("CeilingLight04", "ceiling_light", (1500, 2200, 1170), 210, 0),
    ("CeilingLight05", "ceiling_light", (3000, -2200, 1170), 210, 0),
    ("CeilingLight06", "ceiling_light", (3000, 2200, 1170), 210, 0),
    ("CeilingLight07", "ceiling_light", (4500, -2200, 1170), 210, 0),
    ("CeilingLight08", "ceiling_light", (4500, 2200, 1170), 210, 0),
    ("CeilingLight09", "ceiling_light", (6000, -2200, 1170), 210, 0),
    ("CeilingLight10", "ceiling_light", (6000, 2200, 1170), 210, 0),
    ("CorridorEmergencyLightA", "emergency_light", (1850, -3650, 780), 190, 0),
    ("CorridorEmergencyLightB", "emergency_light", (2850, -3650, 780), 190, 0),
    ("PowerEmergencyLight", "emergency_light", (3950, -3650, 780), 190, 0),
    ("OfficeEmergencyLight", "emergency_light", (5500, -3650, 780), 190, 0),
]

HIDE_OLD_PREFIXES = (
    "TL_GEO_BriefingBackwall",
    "TL_GEO_BriefingDesk",
    "TL_GEO_WindowPane",
    "TL_GEO_SeatRow",
    "TL_GEO_OfficeDesk",
    "TL_GEO_OfficeMonitor",
    "TL_GEO_PowerCabinet",
    "TL_GEO_PowerConsole",
    "TL_GEO_Aircraft",
    "TL_GEO_ScanSouth",
    "TL_GEO_ScanNorth",
    "TL_GEO_QueueRail_",
    "TL_GEO_Bollard_",
    "TL_GEO_BagBelt",
    "TL_GEO_WallNorth",
    "TL_GEO_WindowTopBeam",
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


def load_materials():
    loaded = {}
    for key, path in MATERIALS.items():
        loaded[key] = unreal.load_asset(path)
        if loaded[key] is None:
            raise RuntimeError(f"Approved material failed to load: {path}")
    return loaded


def clear_material_overrides(actor):
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        try:
            component.set_editor_property("override_materials", [])
        except Exception:
            component.set_material(0, None)


def apply_surface_material(actor, material):
    try:
        actor.set_editor_property("allow_custom_material", True)
    except Exception:
        pass
    applied = False
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        if component.get_num_materials() > 0:
            component.set_material(0, material)
            applied = True
    if not applied:
        raise RuntimeError(f"Surface material target has no slot: {actor.get_actor_label()}")


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


def spawn_box(classes, materials, suffix, class_key, center, size, yaw):
    label = PREFIX + suffix
    rotation = (
        unreal.Rotator(pitch=0, yaw=yaw, roll=90)
        if class_key == "smooth_wall"
        else unreal.Rotator(pitch=0, yaw=yaw, roll=0)
    )
    actor = EXISTING_BY_LABEL.pop(label, None)
    if actor is not None and actor.get_class() != classes[class_key]:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(
            classes[class_key], unreal.Vector(*center), rotation
        )
    if actor is None:
        raise RuntimeError(f"Spawn failed: {suffix}")
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
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
    if class_key in ("primitive", "smooth_wall", "sphere"):
        clear_material_overrides(actor)
    material_key = SURFACE_MATERIALS.get(suffix)
    if material_key:
        apply_surface_material(actor, materials[material_key])
    center_actor(actor, center)
    return actor


def spawn_prop(classes, suffix, class_key, ground, target_span, yaw):
    label = PREFIX + suffix
    rotation = unreal.Rotator(pitch=0, yaw=yaw, roll=0)
    actor = EXISTING_BY_LABEL.pop(label, None)
    if actor is not None and actor.get_class() != classes[class_key]:
        ACTORS.destroy_actor(actor)
        actor = None
    if actor is None:
        actor = ACTORS.spawn_actor_from_class(
            classes[class_key], unreal.Vector(*ground), rotation
        )
    if actor is None:
        raise RuntimeError(f"Spawn failed: {suffix}")
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
    actor.set_actor_scale3d(unreal.Vector(1, 1, 1))
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

EXISTING_BY_LABEL.update(
    {
        candidate.get_actor_label(): candidate
        for candidate in all_actors()
        if candidate.get_actor_label().startswith(PREFIX)
    }
)
existing_managed_labels = set(EXISTING_BY_LABEL)

classes = load_classes()
materials = load_materials()
created = []
for spec in ARCHITECTURE:
    created.append(spawn_box(classes, materials, *spec).get_actor_label())
for spec in PROPS:
    created.append(spawn_prop(classes, *spec).get_actor_label())

stale = sorted(EXISTING_BY_LABEL)
for stale_label in stale:
    ACTORS.destroy_actor(EXISTING_BY_LABEL[stale_label])
EXISTING_BY_LABEL.clear()

deleted_legacy = []
replacement_suffixes = {
    label.removeprefix(PREFIX)
    for label in created
}
for actor in all_actors():
    label = actor.get_actor_label()
    replaced_by_native_pass = (
        label.startswith("TL_GEO_")
        and label.removeprefix("TL_GEO_") in replacement_suffixes
    )
    if label.startswith(HIDE_OLD_PREFIXES) or replaced_by_native_pass:
        ACTORS.destroy_actor(actor)
        deleted_legacy.append(label)

# Put both spawn pairs on the dedicated entry apron beside the shift control.
spawn_pads = sorted(
    [a for a in all_actors() if "Player_Spawner" in a.get_class().get_name()],
    key=lambda a: a.get_actor_location().y,
)
for pad, (location, yaw) in zip(spawn_pads, SPAWN_PAD_TRANSFORMS):
    pad.set_actor_location(unreal.Vector(*location), False, False)
    pad.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0), False
    )

player_starts = sorted(
    [a for a in all_actors() if "FortPlayerStartCreative" in a.get_class().get_name()],
    key=lambda a: a.get_actor_location().y,
)
for start, (location, yaw) in zip(player_starts, PLAYER_START_TRANSFORMS):
    start.set_actor_location(unreal.Vector(*location), False, False)
    start.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0), False
    )

# The original button was mounted too high and too far from the player starts to
# show a reliable interaction prompt. Keep the same wired device, but present it
# as a waist-height onboarding console centered between both spawn lanes.
start_buttons = [a for a in all_actors() if a.get_actor_label() == "TL_BTN_Start"]
for start_button in start_buttons:
    start_button.set_actor_location(unreal.Vector(-1080.0, 0.0, 150.0), False, False)
    start_button.set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=180.0, roll=0.0), False
    )

saved = unreal.EditorLevelLibrary.save_current_level()
packages_saved = unreal.EditorLoadingAndSavingUtils.save_dirty_packages(True, True)
unreal.EditorLevelLibrary.set_level_viewport_camera_info(
    unreal.Vector(-1050, 3000, 700),
    unreal.Rotator(pitch=-7.0, yaw=0.0, roll=0.0),
)
actors_after = all_actors()
label_counts = {}
for actor in actors_after:
    label = actor.get_actor_label()
    if label.startswith("TL_"):
        label_counts[label] = label_counts.get(label, 0) + 1
duplicate_labels = sorted(
    label for label, count in label_counts.items() if count > 1
)
created_count = sum(1 for label in created if label not in existing_managed_labels)
result = {
    "world": world.get_path_name(),
    "created": created_count,
    "updated": len(created) - created_count,
    "deleted_temporary": len(stale),
    "expected_managed": len(ARCHITECTURE) + len(PROPS),
    "intrinsic_surface_structures": sum(
        1 for _, class_key, _, _, _ in ARCHITECTURE if class_key in ("primitive", "smooth_wall")
    ),
    "deleted_legacy_visuals": len(deleted_legacy),
    "spawn_pads_normalized": min(len(spawn_pads), len(SPAWN_PAD_TRANSFORMS)),
    "player_starts_repositioned": min(len(player_starts), len(PLAYER_START_TRANSFORMS)),
    "start_buttons_repositioned": len(start_buttons),
    "level_saved": bool(saved),
    "dirty_packages_saved": bool(packages_saved),
    "actor_count": len(actors_after),
    "duplicate_tl_labels": duplicate_labels,
}
