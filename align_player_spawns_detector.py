import unreal


actor_subsystem = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
actors = actor_subsystem.get_all_level_actors()
by_label = {actor.get_actor_label(): actor for actor in actors}


def center_xy(actor, x, y):
    origin, _ = actor.get_actor_bounds(False)
    location = actor.get_actor_location()
    actor.set_actor_location(
        unreal.Vector(location.x + x - origin.x, location.y + y - origin.y, location.z),
        False,
        True,
    )


targets = {
    "Player 1 Spawn Pad": (-2810.0, -1335.0),
    "Player 2 Spawn Pad": (-3010.0, -1265.0),
}
changed = []
missing = []

with unreal.ScopedEditorTransaction("Align player starts with detector opening"):
    for label, target in targets.items():
        actor = by_label.get(label)
        if actor is None:
            missing.append(label)
            continue
        actor.modify()
        actor.set_actor_rotation(unreal.Rotator(pitch=0.0, yaw=0.0, roll=0.0), False)
        center_xy(actor, *target)
        changed.append(label)

saved = bool(unreal.EditorLoadingAndSavingUtils.save_current_level())

starts = []
for actor in actor_subsystem.get_all_level_actors():
    if actor.get_class().get_name() != "FortPlayerStartCreative":
        continue
    location = actor.get_actor_location()
    if -3300.0 <= location.x <= -2400.0 and -1550.0 <= location.y <= -1050.0:
        starts.append((round(location.x, 1), round(location.y, 1), round(location.z, 1)))

print(
    "SPAWN_ALIGNMENT_RESULT|{}".format(
        {
            "changed": changed,
            "missing": missing,
            "spawn_centers": targets,
            "runtime_starts": sorted(starts),
            "saved": saved,
        }
    )
)
