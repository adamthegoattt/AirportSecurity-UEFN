import unreal


asset_data = unreal.AssetRegistryHelpers.get_asset_registry().get_asset_by_object_path(
    "/AirportSecurity/AirportSecurity.AirportSecurity"
)
if not asset_data.is_valid():
    raise RuntimeError("Failed to resolve /AirportSecurity/AirportSecurity")

subsystem = unreal.get_editor_subsystem(unreal.EditorValidatorSubsystem)
settings = unreal.ValidateAssetsSettings()
result_code, details = subsystem.validate_assets_with_settings([asset_data], settings)

actors = list(unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors())
labels = [actor.get_actor_label() for actor in actors]
residue = sorted(
    label
    for label in labels
    if any(token in label.upper() for token in ("PROOF", "DEBUG", "REPLAY", "TRIAL"))
)

result = {
    "result_code": int(result_code),
    "num_requested": details.num_requested,
    "num_checked": details.num_checked,
    "num_valid": details.num_valid,
    "num_invalid": details.num_invalid,
    "num_warnings": details.num_warnings,
    "num_unable_to_validate": details.num_unable_to_validate,
    "actor_count": len(actors),
    "residue": residue,
}
