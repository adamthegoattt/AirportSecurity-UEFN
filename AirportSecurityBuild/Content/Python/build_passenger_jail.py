"""Build the production passenger jail and reusable holding positions.

This script owns only ``TL_JAIL_*`` actors plus the three additional pooled
jail Character devices. It retires the earlier overlapping cell prototypes,
then creates one coherent, player-scale cell with a sliding Creative prop door.
"""

import json
import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
WORLD = unreal.EditorLevelLibrary.get_editor_world()
FOLDER = unreal.Name("TerminalLockdown/PassengerJail")
GAMEPLAY_FOLDER = unreal.Name("TerminalLockdown/Gameplay/Custody")

CLASSES = {
    "cube": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cube.CP_Primitive_Cube_C",
    "cylinder": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_Primitive_Cylinder_Small.CP_Primitive_Cylinder_Small_C",
    "door": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_Door.Apollo_SharkPrison_Door_C",
    "billboard": "/CreativeCoreDevices/Device_Billboard_V2.Device_Billboard_V2_C",
    "bed": "/Game/Athena/Apollo/Environments/BuildingActors/SharkPrison/Props/Apollo_SharkPrison_SingleBed_01.Apollo_SharkPrison_SingleBed_01_C",
    "bench": "/Game/Environments/Helios/Props/Brimstone/Brimstone_Cell_Bench_A/Blueprints/BP_Brimstone_CellBench_A.BP_Brimstone_CellBench_A_C",
    "sink": "/Game/Athena/BuildingActors/Props/Building/ActorBlueprints/Containers/Athena_Prop_Prison_Bathroom_Sink.Athena_Prop_Prison_Bathroom_Sink_C",
    "toilet": "/Game/Athena/BuildingActors/Props/Building/ActorBlueprints/Containers/Athena_Prop_Bathroom_PrisonToilet.Athena_Prop_Bathroom_PrisonToilet_C",
    "light": "/Game/Creative/BuildingActors/Props/CP_Yacht_Ceiling_Light.CP_Yacht_Ceiling_Light_C",
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
    color_type = type(actor.get_editor_property("color"))
    actor.set_editor_property("allow_custom_material", False)
    clear_materials(actor)
    actor.set_editor_property("color", getattr(color_type, color_name))


def make_nonblocking(actor):
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        component.set_collision_enabled(unreal.CollisionEnabled.NO_COLLISION)
    for name in ("no_collision", "no_pawn_collision", "no_physics_collision"):
        try:
            actor.set_editor_property(name, True)
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


def spawn_sized(label, class_key, center, size, color, rotation=None, nonblocking=False):
    actor_class = unreal.load_class(None, CLASSES[class_key])
    if actor_class is None:
        raise RuntimeError("Could not load approved jail class: " + CLASSES[class_key])
    rotation = rotation or unreal.Rotator()
    actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*center), rotation)
    if actor is None:
        raise RuntimeError("Could not spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
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
    color_actor(actor, color)
    center_actor(actor, center)
    if nonblocking:
        make_nonblocking(actor)
    return actor


def spawn_prop(label, class_key, center, target_span, yaw=0.0):
    actor_class = unreal.load_class(None, CLASSES[class_key])
    if actor_class is None:
        raise RuntimeError("Could not load approved jail prop: " + CLASSES[class_key])
    rotation = unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0)
    actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*center), rotation)
    if actor is None:
        raise RuntimeError("Could not spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_rotation(rotation, False)
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
    _, extent = actor.get_actor_bounds(False)
    span = max(extent.x * 2.0, extent.y * 2.0, 1.0)
    scale = target_span / span
    actor.set_actor_scale3d(unreal.Vector(scale, scale, scale))
    center_actor(actor, center)
    return actor


def spawn_billboard(label, location, text, scale=0.72):
    actor_class = unreal.load_class(None, CLASSES["billboard"])
    actor = ACTORS.spawn_actor_from_class(actor_class, unreal.Vector(*location), unreal.Rotator())
    if actor is None:
        raise RuntimeError("Could not spawn " + label)
    actor.set_actor_label(label)
    actor.set_folder_path(FOLDER)
    actor.set_actor_scale3d(unreal.Vector(scale, scale, scale))
    actor.set_editor_property("text", text)
    make_nonblocking(actor)
    return actor


if WORLD is None or "AirportSecurity" not in WORLD.get_path_name():
    raise RuntimeError("Passenger jail build refused outside AirportSecurity")

# Remove only the known overlapping prototypes and this script's owned output.
retired_exact = {
    "TL_ART_CellBarNorth",
    "TL_ART_CellBarSouth",
    "TL_ART_CellBarTop",
    "TL_ART_CellBench",
    "TL_ART_CellFloor",
    "TL_ART_CellWallEast",
    "TL_ART_CellWallNorth",
    "TL_ART_CellWallSouth",
    "TL_ART_DetentionBed",
    "TL_ART_DetentionDoor",
    "TL_ART_DetentionHeader",
    "TL_ART_DetentionIntake",
    "TL_PROD_CellRearBand",
}
retired_prefixes = ("TL_JAIL_", "TL_PROD_Detention", "TL_GEO_CellBar")
removed = []
for actor in all_actors():
    label = actor.get_actor_label()
    if label in retired_exact or label.startswith(retired_prefixes):
        removed.append(label)
        ACTORS.destroy_actor(actor)

# Flush floor and complete reinforced shell.
created = []
box_specs = [
    ("TL_JAIL_Floor", (6500, 1450, 56), (1700, 1700, 24), "GRAY", False),
    ("TL_JAIL_WornFloorInset", (6500, 1450, 68), (1380, 1380, 4), "BLACK", True),
    ("TL_JAIL_BackWall", (7320, 1450, 520), (160, 1700, 900), "GRAY", False),
    ("TL_JAIL_SideWallSouth", (6500, 600, 520), (1700, 160, 900), "GRAY", False),
    ("TL_JAIL_SideWallNorth", (6500, 2300, 520), (1700, 160, 900), "GRAY", False),
    ("TL_JAIL_Ceiling", (6500, 1450, 1010), (1700, 1700, 100), "MIDNIGHT_BLUE", False),
    ("TL_JAIL_FrontPostSouth", (5700, 610, 520), (180, 180, 900), "GRAY", False),
    ("TL_JAIL_FrontPostNorth", (5700, 2290, 520), (180, 180, 900), "GRAY", False),
    ("TL_JAIL_FrontHeader", (5700, 1450, 1010), (180, 1700, 100), "GRAY", False),
    ("TL_JAIL_RedHeaderBackplate", (5650, 1450, 1135), (80, 1050, 170), "RED_ORANGE", True),
    ("TL_JAIL_LeftRailLow", (5700, 950, 350), (70, 820, 32), "MIDNIGHT_BLUE", False),
    ("TL_JAIL_LeftRailHigh", (5700, 950, 700), (70, 820, 32), "MIDNIGHT_BLUE", False),
    ("TL_JAIL_RightRailLow", (5700, 1980, 350), (70, 580, 32), "MIDNIGHT_BLUE", False),
    ("TL_JAIL_RightRailHigh", (5700, 1980, 700), (70, 580, 32), "MIDNIGHT_BLUE", False),
    ("TL_JAIL_DoorLockPlate", (5635, 1695, 355), (30, 90, 170), "BLACK", True),
    ("TL_JAIL_DoorHandle", (5615, 1725, 355), (28, 35, 65), "GOLD", True),
    ("TL_JAIL_IntakeGuide", (5940, 1450, 70), (480, 560, 4), "RED_ORANGE", True),
]
for label, center, size, color, nonblocking in box_specs:
    spawn_sized(label, "cube", center, size, color, nonblocking=nonblocking)
    created.append(label)

for index, y in enumerate((740, 900, 1060, 1840, 2000, 2160), start=1):
    label = "TL_JAIL_FrontBar{0:02d}".format(index)
    spawn_sized(label, "cylinder", (5700, y, 520), (42, 42, 800), "MIDNIGHT_BLUE")
    created.append(label)

# One player-scale sliding gate. Its authored position is the Verse closed home.
door = spawn_prop("TL_JAIL_Door", "door", (5700, 1450, 290), 500.0, yaw=90.0)
door.set_actor_scale3d(unreal.Vector(3.43, 2.99, 2.03))
center_actor(door, (5700, 1450, 290))
created.append("TL_JAIL_Door")

for label, class_key, center, span, yaw in (
    ("TL_JAIL_Bed", "bed", (6830, 900, 130), 430.0, 90.0),
    ("TL_JAIL_Bench", "bench", (6900, 2110, 130), 330.0, 180.0),
    ("TL_JAIL_Sink", "sink", (7130, 1970, 170), 170.0, -90.0),
    ("TL_JAIL_Toilet", "toilet", (7120, 2150, 130), 160.0, -90.0),
    ("TL_JAIL_LightA", "light", (6350, 950, 940), 210.0, 0.0),
    ("TL_JAIL_LightB", "light", (6850, 1950, 940), 210.0, 180.0),
):
    spawn_prop(label, class_key, center, span, yaw)
    created.append(label)

spawn_billboard("TL_JAIL_CriminalsOnlySign", (5550, 1450, 1140), "CRIMINALS ONLY!", 0.9)
spawn_billboard(
    "TL_JAIL_Instructions",
    (5550, 2450, 610),
    "[ HANDCUFFS ]\nESCORT CRIMINALS THROUGH THE GATE",
    0.64,
)
created.extend(("TL_JAIL_CriminalsOnlySign", "TL_JAIL_Instructions"))

# Retain the original occupant as slot one and duplicate three bounded slots.
for label in ("TL_NPC_JailOccupant2", "TL_NPC_JailOccupant3", "TL_NPC_JailOccupant4"):
    existing = actor_by_label(label)
    if existing is not None:
        ACTORS.destroy_actor(existing)

occupant1 = actor_by_label("TL_NPC_JailOccupant")
if occupant1 is None:
    raise RuntimeError("Required pooled TL_NPC_JailOccupant is missing")
occupant_positions = (
    ("TL_NPC_JailOccupant", (6350, 930, 70)),
    ("TL_NPC_JailOccupant2", (6700, 1120, 70)),
    ("TL_NPC_JailOccupant3", (6400, 1940, 70)),
    ("TL_NPC_JailOccupant4", (6900, 1850, 70)),
)
occupants = [occupant1]
for label, position in occupant_positions[1:]:
    duplicate = ACTORS.duplicate_actor(occupant1, None, unreal.Vector())
    if duplicate is None:
        raise RuntimeError("Could not duplicate holding position " + label)
    duplicate.set_actor_label(label)
    duplicate.set_folder_path(GAMEPLAY_FOLDER)
    duplicate.set_actor_location(unreal.Vector(*position), False, False)
    occupants.append(duplicate)
occupant1.set_folder_path(GAMEPLAY_FOLDER)
occupant1.set_actor_location(unreal.Vector(*occupant_positions[0][1]), False, False)

unreal.EditorLevelLibrary.save_current_level()
print(
    "PASSENGER_JAIL_BUILT|"
    + json.dumps(
        {
            "removed": sorted(set(removed)),
            "created": created,
            "door": door.get_path_name(),
            "occupants": [actor.get_path_name() for actor in occupants],
            "actor_count": len(all_actors()),
        },
        separators=(",", ":"),
    )
)
