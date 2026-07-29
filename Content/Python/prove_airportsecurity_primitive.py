import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
ASSETS = unreal.EditorAssetLibrary

EXPECTED_LEVEL_TOKEN = "AirportSecurity"
LABEL = "TL_PROOF_PrimitiveBlock"
MESH_PATH = "/Game/Creative/Sets/PropSets/Primitives/Rounds/Mesh/CP_L_Squared_Cube_Full.CP_L_Squared_Cube_Full"
MATERIAL_PATH = "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_Black.MI_Primitive_WorldGrid_Marble_Black"
LOCATION = (6000.0, 0.0, 100.0)
SIZE = (600.0, 600.0, 200.0)


def all_actors():
    return list(ACTORS.get_all_level_actors())


def actor_by_label(label):
    for actor in all_actors():
        if actor.get_actor_label() == label:
            return actor
    return None


world = unreal.EditorLevelLibrary.get_editor_world()
world_path = world.get_path_name() if world else "<none>"
print(f"TL_PROOF_CONTEXT|world={world_path}|actors_before={len(all_actors())}")
if EXPECTED_LEVEL_TOKEN.lower() not in world_path.lower():
    raise RuntimeError(f"Refusing placement: expected {EXPECTED_LEVEL_TOKEN} level, got {world_path}")

mesh = ASSETS.load_asset(MESH_PATH)
material = ASSETS.load_asset(MATERIAL_PATH)
if not mesh or not material:
    raise RuntimeError("Primitive proof mesh or material failed to load")

actor = actor_by_label(LABEL)
created = actor is None
if created:
    actor = ACTORS.spawn_actor_from_class(
        unreal.FortStaticMeshActor,
        unreal.Vector(*LOCATION),
    )
    if not actor:
        raise RuntimeError("Failed to spawn primitive proof actor")
    actor.set_actor_label(LABEL)

actor.set_actor_location(unreal.Vector(*LOCATION), False, False)
actor.set_actor_rotation(unreal.Rotator(0.0, 0.0, 0.0), False)
component = actor.static_mesh_component
component.set_static_mesh(mesh)
bounds = mesh.get_bounding_box()
extent = bounds.max - bounds.min
actor.set_actor_scale3d(
    unreal.Vector(
        SIZE[0] / max(extent.x, 1.0),
        SIZE[1] / max(extent.y, 1.0),
        SIZE[2] / max(extent.z, 1.0),
    )
)
component.set_collision_profile_name("BlockAll")
component.set_material(0, material)

saved_level = unreal.EditorLevelLibrary.save_current_level()
saved_packages = unreal.EditorLoadingAndSavingUtils.save_dirty_packages(True, True)

verified = actor_by_label(LABEL)
if not verified:
    raise RuntimeError("Placement verification failed: proof actor not found by label")

print(
    "TL_PROOF_OK|"
    f"created={created}|"
    f"label={verified.get_actor_label()}|"
    f"class={verified.get_class().get_path_name()}|"
    f"location={verified.get_actor_location()}|"
    f"mesh={component.static_mesh.get_path_name() if component.static_mesh else '<none>'}|"
    f"level_saved={saved_level}|"
    f"packages_saved={saved_packages}|"
    f"actors_after={len(all_actors())}"
)
