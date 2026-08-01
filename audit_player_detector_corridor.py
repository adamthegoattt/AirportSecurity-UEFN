import unreal


actors = unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors()
rows = []

for actor in actors:
    center, extent = actor.get_actor_bounds(False)
    minimum = unreal.Vector(center.x - extent.x, center.y - extent.y, center.z - extent.z)
    maximum = unreal.Vector(center.x + extent.x, center.y + extent.y, center.z + extent.z)

    # Straight, shoulder-width player route from the active spawn to the detector.
    intersects = (
        maximum.x >= -2800.0
        and minimum.x <= 470.0
        and maximum.y >= -1425.0
        and minimum.y <= -1175.0
        and maximum.z >= 100.0
        and minimum.z <= 280.0
    )
    if not intersects:
        continue

    collision = []
    for component in actor.get_components_by_class(unreal.PrimitiveComponent):
        try:
            enabled = str(component.get_collision_enabled()).split(".")[-1]
        except Exception:
            enabled = "UNKNOWN"
        if enabled != "NO_COLLISION":
            collision.append((component.get_name(), enabled))

    rows.append(
        (
            actor.get_actor_label(),
            actor.get_class().get_name(),
            (round(center.x, 1), round(center.y, 1), round(center.z, 1)),
            (round(extent.x * 2.0, 1), round(extent.y * 2.0, 1), round(extent.z * 2.0, 1)),
            (round(minimum.x, 1), round(maximum.x, 1)),
            collision,
        )
    )

for row in sorted(rows, key=lambda item: (item[4][0], item[0])):
    print("PLAYER_CORRIDOR|{}".format(repr(row)))

print("PLAYER_CORRIDOR_COUNT|{}".format(len(rows)))
