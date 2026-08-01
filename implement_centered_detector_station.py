"""Idempotently rebuild the live AirportSecurity detector decision station.

This pass only touches the scanner frame, its wired controls, the compact
decision console, and the final queue lead-in.  Existing Verse references are
preserved: TL_BTN_Clear is PASS and TL_BTN_Secondary is NO PASS/Secondary.
"""

import unreal


ACTORS = unreal.get_editor_subsystem(unreal.EditorActorSubsystem)
FOLDER = unreal.Name("TerminalLockdown/ProductionPass")
by_label = {actor.get_actor_label(): actor for actor in ACTORS.get_all_level_actors()}


def require(label):
    actor = by_label.get(label)
    if actor is None:
        raise RuntimeError("Required checkpoint actor is missing: " + label)
    return actor


def center_actor(actor, center):
    origin, _ = actor.get_actor_bounds(False)
    location = actor.get_actor_location()
    actor.set_actor_location(
        unreal.Vector(
            location.x + center[0] - origin.x,
            location.y + center[1] - origin.y,
            location.z + center[2] - origin.z,
        ),
        False,
        False,
    )


def size_actor(label, center, size, collision=None):
    actor = require(label)
    actor.modify()
    actor.set_actor_rotation(unreal.Rotator(), False)
    actor.set_actor_scale3d(unreal.Vector(1.0, 1.0, 1.0))
    _, extent = actor.get_actor_bounds(False)
    base = (
        max(extent.x * 2.0, 1.0),
        max(extent.y * 2.0, 1.0),
        max(extent.z * 2.0, 1.0),
    )
    actor.set_actor_scale3d(
        unreal.Vector(size[0] / base[0], size[1] / base[1], size[2] / base[2])
    )
    center_actor(actor, center)
    if collision is not None:
        for component in actor.get_components_by_class(unreal.StaticMeshComponent):
            component.set_collision_enabled(collision)
    return actor


def move_actor(label, location, scale=None, reset_rotation=False):
    actor = require(label)
    actor.modify()
    actor.set_actor_location(unreal.Vector(*location), False, False)
    if reset_rotation:
        actor.set_actor_rotation(unreal.Rotator(), False)
    if scale is not None:
        actor.set_actor_scale3d(unreal.Vector(*scale))
    return actor


def color_actor(label, color_name):
    actor = require(label)
    try:
        color_type = type(actor.get_editor_property("color"))
        actor.set_editor_property("allow_custom_material", False)
        for component in actor.get_components_by_class(unreal.StaticMeshComponent):
            if component.get_num_materials() > 0:
                component.set_material(0, None)
        actor.set_editor_property("color", getattr(color_type, color_name))
    except Exception as exc:
        raise RuntimeError("Could not recolor {}: {}".format(label, exc))


def set_nonblocking(actor):
    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
        component.set_collision_enabled(unreal.CollisionEnabled.NO_COLLISION)
    for property_name in ("no_collision", "no_pawn_collision", "no_physics_collision"):
        try:
            actor.set_editor_property(property_name, True)
        except Exception:
            pass


def set_billboard_text(label, text):
    actor = require(label)
    actor.modify()
    try:
        actor.set_editor_property("text", text)
    except Exception:
        pass


changed = []
removed = []

with unreal.ScopedEditorTransaction("Implement centered detector decision station"):
    # The route derives its scanner center from TL_BOARD_Checkpoint at X=350;
    # ScannerCenterPosition is therefore X=470, Y=-1300.  Center the one visible
    # frame on that authoritative route instead of the former remote X=-900 art.
    detector_specs = {
        "TL_PROD_LargeDetectorLeft": ((470.0, -1460.0, 243.0), (90.0, 80.0, 310.0)),
        "TL_PROD_LargeDetectorRight": ((470.0, -1140.0, 243.0), (90.0, 80.0, 310.0)),
        "TL_PROD_LargeDetectorTop": ((470.0, -1300.0, 433.0), (90.0, 400.0, 70.0)),
    }
    for label, (center, size) in detector_specs.items():
        size_actor(label, center, size, unreal.CollisionEnabled.QUERY_AND_PHYSICS)
        color_actor(label, "MIDNIGHT_BLUE")
        changed.append(label)

    # The frame has no threshold mesh.  These thin floor insets remain 6 cm
    # above the floor only as nonblocking markings, never as a traversal lip.
    for label, center, size in (
        ("TL_QUEUE_SWITCHBACK_ScannerLeadIn", (-120.0, -1600.0, 94.0), (180.0, 360.0, 6.0)),
        ("TL_QUEUE_SWITCHBACK_ScannerTurn", (0.0, -1450.0, 94.0), (140.0, 180.0, 6.0)),
        ("TL_QUEUE_SWITCHBACK_ScannerEntryPad", (180.0, -1300.0, 94.0), (300.0, 240.0, 6.0)),
    ):
        actor = size_actor(label, center, size, unreal.CollisionEnabled.NO_COLLISION)
        set_nonblocking(actor)
        changed.append(label)

    # Two-choice console: red NO PASS on the player's left, green PASS on the
    # right, both outside the Y=-1300 passenger capsule path.
    size_actor(
        "TL_PROD_CheckpointDecisionBase",
        (700.0, -1770.0, 165.0),
        (520.0, 260.0, 154.0),
        unreal.CollisionEnabled.QUERY_AND_PHYSICS,
    )
    size_actor(
        "TL_PROD_CheckpointDecisionTop",
        (700.0, -1770.0, 251.0),
        (520.0, 260.0, 18.0),
        unreal.CollisionEnabled.QUERY_AND_PHYSICS,
    )
    divider = by_label.get("TL_PROD_CheckpointDecisionDivider")
    if divider is None:
        divider = by_label.get("TL_PROD_CheckpointDecisionDividerLeft")
        if divider is not None:
            divider.modify()
            divider.set_actor_label("TL_PROD_CheckpointDecisionDivider")
            by_label["TL_PROD_CheckpointDecisionDivider"] = divider
            by_label.pop("TL_PROD_CheckpointDecisionDividerLeft", None)
    if divider is None:
        raise RuntimeError("Decision console divider is missing")
    size_actor(
        "TL_PROD_CheckpointDecisionDivider",
        (700.0, -1770.0, 276.0),
        (18.0, 210.0, 32.0),
        unreal.CollisionEnabled.NO_COLLISION,
    )
    extra_divider = by_label.get("TL_PROD_CheckpointDecisionDividerRight")
    if extra_divider is not None:
        removed.append(extra_divider.get_actor_label())
        ACTORS.destroy_actor(extra_divider)

    console_positions = {
        "TL_BTN_Secondary": (570.0, -1770.0, 295.0),
        "TL_BTN_Clear": (830.0, -1770.0, 295.0),
        "TL_PROD_CheckpointNoPassRim": (570.0, -1770.0, 277.0),
        "TL_PROD_CheckpointNoPassCap": (570.0, -1770.0, 297.0),
        "TL_PROD_CheckpointNoPassSymbolA": (570.0, -1770.0, 307.0),
        "TL_PROD_CheckpointNoPassSymbolB": (570.0, -1770.0, 307.0),
        "TL_PROD_CheckpointPassRim": (830.0, -1770.0, 277.0),
        "TL_PROD_CheckpointPassCap": (830.0, -1770.0, 297.0),
        "TL_PROD_CheckpointPassSymbolA": (807.0, -1775.0, 300.0),
        "TL_PROD_CheckpointPassSymbolB": (843.0, -1764.0, 313.0),
        "TL_PROD_CheckpointNoPassLabel": (570.0, -1595.0, 405.0),
        "TL_PROD_CheckpointPassLabel": (830.0, -1595.0, 405.0),
    }
    for label, location in console_positions.items():
        scale = (0.72, 0.72, 0.72) if label.startswith("TL_BTN_") else None
        actor = move_actor(label, location, scale, reset_rotation=label.startswith("TL_BTN_"))
        if label.startswith("TL_BTN_"):
            try:
                actor.set_editor_property("visible_during_game", False)
            except Exception:
                pass
        set_nonblocking(actor)
        changed.append(label)

    for label, yaw in (
        ("TL_PROD_CheckpointNoPassSymbolA", 45.0),
        ("TL_PROD_CheckpointNoPassSymbolB", -45.0),
        ("TL_PROD_CheckpointPassSymbolA", -40.0),
        ("TL_PROD_CheckpointPassSymbolB", 42.0),
    ):
        require(label).set_actor_rotation(unreal.Rotator(pitch=0.0, yaw=yaw, roll=0.0), False)

    color_actor("TL_PROD_CheckpointNoPassCap", "RED_ORANGE")
    color_actor("TL_PROD_CheckpointPassCap", "APPLE_GREEN")
    set_billboard_text("TL_PROD_CheckpointNoPassLabel", "NO PASS\nSECONDARY")
    set_billboard_text("TL_PROD_CheckpointPassLabel", "PASS\nCLEAR")

    # Scan remains an explicit handheld/operator action.  Mount its already
    # wired device on the small pedestal next to the two-choice console.
    move_actor("TL_BTN_Scan", (1040.0, -1770.0, 145.0), reset_rotation=True)
    set_nonblocking(require("TL_BTN_Scan"))
    size_actor(
        "TL_PROD_LargeDetectorControlPedestal",
        (1040.0, -1770.0, 143.0),
        (100.0, 120.0, 110.0),
        unreal.CollisionEnabled.QUERY_AND_PHYSICS,
    )
    size_actor(
        "TL_PROD_LargeDetectorControlFace",
        (1040.0, -1706.0, 155.0),
        (80.0, 8.0, 45.0),
        unreal.CollisionEnabled.NO_COLLISION,
    )
    changed.extend(("TL_BTN_Scan", "TL_PROD_LargeDetectorControlPedestal", "TL_PROD_LargeDetectorControlFace"))

    # Preserve DETAIN as the later explicit choice on a separate red station;
    # it no longer crowds the primary PASS/NO PASS console.
    detain_positions = {
        "TL_BTN_Detain": (1300.0, -2100.0, 295.0),
        "TL_PROD_CheckpointJailRim": (1300.0, -2100.0, 277.0),
        "TL_PROD_CheckpointJailCap": (1300.0, -2100.0, 297.0),
        "TL_PROD_CheckpointJailSymbolA": (1300.0, -2100.0, 307.0),
        "TL_PROD_CheckpointJailSymbolB": (1300.0, -2100.0, 307.0),
        "TL_PROD_CheckpointJailLabel": (1300.0, -1925.0, 405.0),
        "TL_PROD_CheckpointSecureLabel": (1605.0, -1660.0, 255.0),
    }
    for label, location in detain_positions.items():
        scale = (0.72, 0.72, 0.72) if label == "TL_BTN_Detain" else None
        actor = move_actor(label, location, scale, reset_rotation=label == "TL_BTN_Detain")
        set_nonblocking(actor)
        changed.append(label)
    require("TL_PROD_CheckpointJailSymbolA").set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=45.0, roll=0.0), False
    )
    require("TL_PROD_CheckpointJailSymbolB").set_actor_rotation(
        unreal.Rotator(pitch=0.0, yaw=-45.0, roll=0.0), False
    )
    size_actor(
        "TL_PROD_CheckpointSecurePad",
        (1605.0, -1800.0, 94.0),
        (280.0, 240.0, 6.0),
        unreal.CollisionEnabled.NO_COLLISION,
    )
    set_nonblocking(require("TL_PROD_CheckpointSecurePad"))
    changed.append("TL_PROD_CheckpointSecurePad")

    # Retire any older detector frame family if a previous builder left one in
    # the level.  The three LargeDetector pieces above are the one primary arch.
    retired_prefixes = (
        "TL_PROD_ScannerCrown",
        "TL_PROD_ScannerSideLeft",
        "TL_PROD_ScannerSideRight",
        "TL_PROD_ScannerShell",
    )
    for label, actor in list(by_label.items()):
        if label.startswith(retired_prefixes):
            removed.append(label)
            ACTORS.destroy_actor(actor)

saved = bool(unreal.EditorLoadingAndSavingUtils.save_current_level())
result = {
    "detector_center": [470.0, -1300.0],
    "clear_opening_cm": [240.0, 310.0],
    "console_center": [700.0, -1770.0],
    "changed": sorted(set(changed)),
    "removed": sorted(set(removed)),
    "saved": saved,
}
print("CENTERED_DETECTOR_STATION|{}".format(result))
