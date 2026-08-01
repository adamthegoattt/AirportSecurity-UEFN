import unreal

actors = unreal.get_editor_subsystem(unreal.EditorActorSubsystem).get_all_level_actors()
wanted = {
    "TL_PROD_LargeDetectorLeft",
    "TL_PROD_LargeDetectorRight",
    "TL_PROD_LargeDetectorTop",
    "TL_PROD_ScannerSideLeft",
    "TL_PROD_ScannerSideRight",
    "TL_PROD_ScannerCrown",
    "TL_ART_TerminalFloor",
    "TL_GEO_WallSouth",
    "TL_ART_WestWallSouth",
    "TL_PROD_WestWindowPane",
    "TL_PROD_CheckpointDecisionBase",
    "TL_BTN_Scan",
    "TL_BTN_Clear",
    "TL_BTN_Secondary",
}
found = set()
for actor in actors:
    label = actor.get_actor_label()
    if label not in wanted:
        continue
    found.add(label)
    origin, extent = actor.get_actor_bounds(False)
    print(
        "RESULT|label={}|center=({:.1f},{:.1f},{:.1f})|size=({:.1f},{:.1f},{:.1f})|loc={}".format(
            label, origin.x, origin.y, origin.z,
            extent.x * 2.0, extent.y * 2.0, extent.z * 2.0,
            actor.get_actor_location(),
        )
    )
print("MISSING|{}".format(sorted(wanted - found)))
print("ACTOR_COUNT|{}".format(len(actors)))
