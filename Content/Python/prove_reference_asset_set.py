"""Disposable proof for the reference-match environment asset set.

Run only in the AirportSecurity editor map. The actors use TL_PROOF_REF2_ labels
so a repeated run replaces the previous proof set and final cleanup is explicit.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
PREFIX = "TL_PROOF_REF2_"

CLASSES = {
    "primitive": "/Game/Creative/Sets/PropSets/Primitives/Rounds/Props/CP_L_Primitive_Squared_Cube_Full.CP_L_Primitive_Squared_Cube_Full_C",
    "glass": "/Game/Creative/Sets/Glass/BuildingPieces/CP_Glass_Solid_Wall.CP_Glass_Solid_Wall_C",
    "beam": "/Game/Creative/Items/Building_Parts/MetalBeams/CP_Metal_I_Bar.CP_Metal_I_Bar_C",
    "seat": "/Game/Creative/Sets/ArtDeco_Bank/Props/CP_ArtDeco_Triple_Couch_B.CP_ArtDeco_Triple_Couch_B_C",
    "desk": "/Game/Athena/Apollo/Environments/BuildingActors/Office/Props/Apollo_Office_Desk_02.Apollo_Office_Desk_02_C",
    "monitor": "/Game/Environments/Asteria/Props/Office/Office_Monitors_A/Blueprints/Asteria_Office_Monitor_A.Asteria_Office_Monitor_A_C",
    "power": "/Game/Building/ActorBlueprints/Prop/PowerTransformer01.PowerTransformer01_C",
    "cell": "/Game/Creative/BuildingActors/Props/Prop_CellDoor.Prop_CellDoor_C",
}

SPECS = [
    ("Primitive", CLASSES["primitive"], (-1100, 7500, 0), 600.0, 0.0),
    ("Glass", CLASSES["glass"], (-300, 7500, 0), 650.0, 0.0),
    ("Beam", CLASSES["beam"], (500, 7500, 0), 850.0, 90.0),
    ("Seat", CLASSES["seat"], (1450, 7500, 0), 500.0, 0.0),
    ("Desk", CLASSES["desk"], (2250, 7500, 0), 500.0, 0.0),
    ("Monitor", CLASSES["monitor"], (2950, 7500, 0), 350.0, 0.0),
    ("Power", CLASSES["power"], (3650, 7500, 0), 550.0, 0.0),
    ("Cell", CLASSES["cell"], (4500, 7500, 0), 750.0, 0.0),
]


def all_actors():
    return list(ACTORS.get_all_level_actors())


def remove_proof():
    for candidate in all_actors():
        if candidate.get_actor_label().startswith(PREFIX):
            ACTORS.destroy_actor(candidate)


def place(label, class_path, location, target_size, yaw):
    actor_class = unreal.load_class(None, class_path)
    if actor_class is None:
        raise RuntimeError(f"Class failed to load: {class_path}")
    actor = ACTORS.spawn_actor_from_class(
        actor_class,
        unreal.Vector(*location),
        unreal.Rotator(0.0, yaw, 0.0),
    )
    if actor is None:
        raise RuntimeError(f"Class failed to spawn: {class_path}")
    actor.set_actor_label(label)
    origin, extent = actor.get_actor_bounds(False)
    largest = max(extent.x * 2.0, extent.y * 2.0, extent.z * 2.0, 1.0)
    scale = target_size / largest
    actor.set_actor_scale3d(unreal.Vector(scale, scale, scale))
    origin, extent = actor.get_actor_bounds(False)
    actor.set_actor_location(
        unreal.Vector(location[0], location[1], location[2] + extent.z - origin.z),
        False,
        False,
    )
    actor.set_folder_path(unreal.Name("TerminalLockdown/ReferenceProof"))
    return actor


world = unreal.EditorLevelLibrary.get_editor_world()
if world is None or "AirportSecurity" not in world.get_path_name():
    raise RuntimeError("Reference proof refused outside AirportSecurity")

remove_proof()
created = [
    place(PREFIX + suffix, class_path, location, size, yaw).get_actor_label()
    for suffix, class_path, location, size, yaw in SPECS
]
saved = unreal.EditorLevelLibrary.save_current_level()
result = {
    "world": world.get_path_name(),
    "created": created,
    "classes": CLASSES,
    "saved": bool(saved),
    "actor_count": len(all_actors()),
}
