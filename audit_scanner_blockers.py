import unreal


actors = list(unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors())
rows = []
for actor in actors:
    origin, extent = actor.get_actor_bounds(False)
    size = (extent.x * 2.0, extent.y * 2.0, extent.z * 2.0)
    overlaps_checkpoint = (
        origin.x + extent.x >= -600.0
        and origin.x - extent.x <= 2600.0
        and origin.y + extent.y >= -2800.0
        and origin.y - extent.y <= 500.0
        and origin.z - extent.z < 900.0
        and origin.z + extent.z > 88.0
    )
    materially_large = max(size) >= 500.0 or size[2] >= 400.0
    if not overlaps_checkpoint or not materially_large:
        continue
    solid = False
    for component in actor.get_components_by_class(unreal.PrimitiveComponent):
        if component.get_class().get_name() == "BoxComponent":
            continue
        if "QUERY_AND_PHYSICS" in str(component.get_collision_enabled()):
            solid = True
            break
    rows.append(
        {
            "label": actor.get_actor_label(),
            "class": actor.get_class().get_name(),
            "center": [round(origin.x), round(origin.y), round(origin.z)],
            "size": [round(size[0]), round(size[1]), round(size[2])],
            "solid": solid,
        }
    )

result = sorted(rows, key=lambda row: row["label"])
