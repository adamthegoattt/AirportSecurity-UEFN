import unreal


subsystem = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
actors = list(subsystem.get_all_level_actors())

candidate_labels = {
    "TL_ART_TerminalFloor",
    "TL_ART_ScannerNorthPad",
    "TL_ART_ScannerSouthPad",
    "TL_PROD_CheckpointHeader",
    "TL_PROD_ScannerSideLeft",
    "TL_PROD_ScannerSideRight",
    "TL_PROD_ScannerCrown",
    "TL_PROD_NativeScanner",
    "TL_PROD_NativeScannerRight",
    "TL_PROD_ScannerInnerLightLeft",
    "TL_PROD_ScannerInnerLightRight",
    "TL_PROD_ScannerReadyStrip",
    "TL_PROD_ScannerControlPedestal",
    "TL_PROD_ScannerControlFace",
    "TL_PROD_ScannerStatusLight",
    "TL_PROD_ScannerExitResultTower",
    "TL_PROD_ScannerExitResultFace",
    "TL_PROD_ScannerThresholdStripeA",
    "TL_PROD_ScannerThresholdStripeB",
    "TL_PROD_ClosedLaneBarrier",
    "TL_PROD_OfficerBarrierA",
    "TL_PROD_OfficerBarrierB",
    "TL_PROD_BagConveyorIn",
    "TL_PROD_BagConveyorOut",
    "TL_BTN_Scan",
    "TL_BOARD_Checkpoint",
    "TL_PASSENGER_Active",
}


def actor_row(actor):
    origin, extent = actor.get_actor_bounds(False)
    location = actor.get_actor_location()
    collisions = []
    for component in actor.get_components_by_class(unreal.PrimitiveComponent):
        if component.get_class().get_name() != "BoxComponent":
            collisions.append(
                f"{component.get_class().get_name()}:{component.get_collision_enabled()}:{component.get_collision_profile_name()}"
            )
    return {
        "label": actor.get_actor_label(),
        "class": actor.get_class().get_name(),
        "location": [round(location.x, 2), round(location.y, 2), round(location.z, 2)],
        "bounds_size": [round(extent.x * 2, 2), round(extent.y * 2, 2), round(extent.z * 2, 2)],
        "bottom": round(origin.z - extent.z, 2),
        "top": round(origin.z + extent.z, 2),
        "solid": any("QUERY_AND_PHYSICS" in collision for collision in collisions),
    }


candidate_rows = [
    actor_row(actor)
    for actor in actors
    if actor.get_actor_label() in candidate_labels
]

controller = next((actor for actor in actors if actor.get_actor_label() == "TL_Controller"), None)
controller_refs = {}
if controller is not None:
    for candidate in (
        "CheckpointBoard",
        "checkpoint_board",
        "ScanButton",
        "scan_button",
        "ActivePassenger",
        "active_passenger",
        "QueuePassenger1",
        "queue_passenger1",
        "ScannerStartAudio",
        "scanner_start_audio",
        "ScannerResultAudio",
        "scanner_result_audio",
    ):
        try:
            value = controller.get_editor_property(candidate)
            if isinstance(value, unreal.Actor):
                controller_refs[candidate] = value.get_actor_label()
            else:
                controller_refs[candidate] = str(value)
        except Exception:
            pass

labels = [actor.get_actor_label() for actor in actors]
result = {
    "world": unreal.EditorLevelLibrary.get_editor_world().get_path_name(),
    "actor_count": len(actors),
    "duplicate_tl_labels": sorted(
        label for label in set(labels) if label.startswith("TL_") and labels.count(label) > 1
    ),
    "candidates": sorted(candidate_rows, key=lambda row: row["label"]),
    "controller_references": controller_refs,
}
