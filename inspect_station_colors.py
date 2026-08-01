import json
import unreal

labels = {
    "TL_PROD_CheckpointDecisionBase", "TL_PROD_CheckpointDecisionTop",
    "TL_PROD_CheckpointNoPassRim", "TL_PROD_CheckpointNoPassCap",
    "TL_PROD_CheckpointPassRim", "TL_PROD_CheckpointPassCap",
    "TL_PROD_CheckpointNoPassLabel", "TL_PROD_CheckpointPassLabel",
}
rows = []
for actor in unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors():
    if actor.get_actor_label() not in labels:
        continue
    row = {"label": actor.get_actor_label(), "class": actor.get_class().get_name()}
    for prop in ("color", "allow_custom_material", "text", "visible_during_game"):
        try:
            row[prop] = str(actor.get_editor_property(prop))
        except Exception:
            pass
    origin, extent = actor.get_actor_bounds(False)
    row["bounds"] = [round(origin.x, 1), round(origin.y, 1), round(origin.z, 1), round(extent.x * 2, 1), round(extent.y * 2, 1), round(extent.z * 2, 1)]
    rows.append(row)
result = sorted(rows, key=lambda item: item["label"])
