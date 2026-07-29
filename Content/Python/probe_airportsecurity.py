import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
ASSETS = unreal.EditorAssetLibrary

EXPECTED_LEVEL_TOKEN = "AirportSecurity"
MESH_PATH = "/Game/Creative/Sets/PropSets/Primitives/Rounds/Mesh/CP_L_Squared_Cube_Full.CP_L_Squared_Cube_Full"
MATERIAL_PATH = "/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_Black.MI_Primitive_WorldGrid_Marble_Black"
CLASS_PATHS = {
    "button": "/CreativeCoreDevices/Device_Button_V2.Device_Button_V2_C",
    "hud": "/CreativeCoreDevices/Device_HUDMessage_V2.Device_HUDMessage_V2_C",
    "spawn_pad": "/CRD_PlayerSpawn/BP_Creative_Player_Spawner_Prop.BP_Creative_Player_Spawner_Prop_C",
}


world = unreal.EditorLevelLibrary.get_editor_world()
world_path = world.get_path_name() if world else "<none>"
actors = list(ACTORS.get_all_level_actors())

print(f"TL_PROBE|world={world_path}|actors={len(actors)}")
if EXPECTED_LEVEL_TOKEN.lower() not in world_path.lower():
    raise RuntimeError(f"Refusing probe: expected {EXPECTED_LEVEL_TOKEN} level, got {world_path}")

for actor in sorted(actors, key=lambda item: item.get_actor_label().lower()):
    print(
        "TL_ACTOR|"
        f"label={actor.get_actor_label()}|"
        f"class={actor.get_class().get_path_name()}|"
        f"location={actor.get_actor_location()}"
    )

mesh = ASSETS.load_asset(MESH_PATH)
material = ASSETS.load_asset(MATERIAL_PATH)
print(f"TL_ASSET|kind=mesh|path={MESH_PATH}|loaded={bool(mesh)}")
print(f"TL_ASSET|kind=material|path={MATERIAL_PATH}|loaded={bool(material)}")
if not mesh or not material:
    raise RuntimeError("Required primitive proof assets did not load")

for name, path in CLASS_PATHS.items():
    loaded = unreal.load_class(None, path)
    print(f"TL_CLASS|kind={name}|path={path}|loaded={bool(loaded)}")
    if not loaded:
        raise RuntimeError(f"Required class did not load: {path}")

print("TL_PROBE_OK")
