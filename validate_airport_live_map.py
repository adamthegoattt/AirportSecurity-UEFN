import json
import unreal

actors = unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors()
validator = unreal.get_editor_subsystem(unreal.EditorValidatorSubsystem)

counts = {"valid": 0, "invalid": 0, "not_validated": 0, "errors": 0, "warnings": 0}
invalid_items = []
warning_items = []

for actor in actors:
    result, errors, warnings = validator.is_object_valid(actor, unreal.DataValidationUsecase.MANUAL)
    result_text = str(result)
    if "INVALID" in result_text.upper():
        counts["invalid"] += 1
        invalid_items.append({
            "label": actor.get_actor_label(),
            "class": actor.get_class().get_name(),
            "errors": [str(item) for item in errors],
        })
    elif "VALID" in result_text.upper() and "NOT_VALIDATED" not in result_text.upper():
        counts["valid"] += 1
    else:
        counts["not_validated"] += 1
    counts["errors"] += len(errors)
    counts["warnings"] += len(warnings)
    if warnings:
        warning_items.append({
            "label": actor.get_actor_label(),
            "warnings": [str(item) for item in warnings],
        })

production = [actor for actor in actors if actor.get_actor_label().startswith("TL_PROD_")]
disallowed_labels = {
    "TL_PROD_BagUtilityScanner",
    "TL_PROD_DocumentUtilityScanner",
    "TL_PROD_ScannerStatusLight",
    "TL_PROD_PowerServiceScanner",
    "TL_PROD_PowerStatusLight",
}
remaining_disallowed_fallbacks = [
    actor.get_actor_label()
    for actor in actors
    if actor.get_actor_label() in disallowed_labels and "VFX" in actor.get_class().get_name()
]

print(json.dumps({
    "level_actor_count": len(actors),
    "production_actor_count": len(production),
    "validation": counts,
    "invalid_items": invalid_items[:30],
    "warning_items": warning_items[:30],
    "remaining_disallowed_fallbacks": remaining_disallowed_fallbacks,
}, indent=2))
