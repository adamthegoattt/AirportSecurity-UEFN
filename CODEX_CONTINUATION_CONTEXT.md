# Codex continuation context

This file is generated only from local Git data and the supplied structured validation record.

## Repository range

- Branch: `codex/airport-reference-rebuild`
- Base SHA: `55eac73cc3d7e7b32abf7b7aebccc23b523b9ba9`
- Head SHA: `1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a`
- Range: `55eac73cc3d7e7b32abf7b7aebccc23b523b9ba9..1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a`

## Commits, oldest first

```text
1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a	2026-07-30	feat: make airport checkpoint routes physical and walkable
```

## Diff stat

```text
 Content/AirportSecurity.umap                       | Bin 56330 -> 56330 bytes
 Content/Python/build_airport_production_pass.py    |  47 ++
 .../0/NM/0KVSRW1HN8MD1NQQ3TDMX5.uasset             | Bin 53577 -> 53577 bytes
 .../6/8T/DSHQO1AUSMVF7SCPI69FHT.uasset             | Bin 66072 -> 66072 bytes
 .../9/VT/5P4UM2ZRJGXDA994P4KKD1.uasset             | Bin 7699 -> 14245 bytes
 .../E/XP/4BCC1KVA52WV26Q6Y051BR.uasset             | Bin 7699 -> 14245 bytes
 Content/terminal_lockdown_controller.verse         | 491 ++++++++++++++++-----
 7 files changed, 417 insertions(+), 121 deletions(-)
```

## Changed files

- `M` `Content/AirportSecurity.umap`
- `M` `Content/Python/build_airport_production_pass.py`
- `M` `Content/__ExternalActors__/AirportSecurity/0/NM/0KVSRW1HN8MD1NQQ3TDMX5.uasset`
- `M` `Content/__ExternalActors__/AirportSecurity/6/8T/DSHQO1AUSMVF7SCPI69FHT.uasset`
- `M` `Content/__ExternalActors__/AirportSecurity/9/VT/5P4UM2ZRJGXDA994P4KKD1.uasset`
- `M` `Content/__ExternalActors__/AirportSecurity/E/XP/4BCC1KVA52WV26Q6Y051BR.uasset`
- `M` `Content/terminal_lockdown_controller.verse`

## Important changed binary files

- `M` `Content/AirportSecurity.umap` — 56330 bytes — SHA-256 `3b844be63209b7ab27902b6b6b77fc7a4f879ac54b693cbc09bff2ba5147d6fa`
- `M` `Content/__ExternalActors__/AirportSecurity/0/NM/0KVSRW1HN8MD1NQQ3TDMX5.uasset` — 53577 bytes — SHA-256 `c1d3df371fe596a4cde15150df217fdce2ab9013840af7683dfaa094cfddd888`
- `M` `Content/__ExternalActors__/AirportSecurity/6/8T/DSHQO1AUSMVF7SCPI69FHT.uasset` — 66072 bytes — SHA-256 `f347bf8b9b1f382d7c5f576c2feaa2bd5df556acf35118af78b0a8b5f006a462`
- `M` `Content/__ExternalActors__/AirportSecurity/9/VT/5P4UM2ZRJGXDA994P4KKD1.uasset` — 14245 bytes — SHA-256 `9b157b98acfdc0b2440eed06dcdbca249c7d67eb1e14d362a8a5f9e0573d976a`
- `M` `Content/__ExternalActors__/AirportSecurity/E/XP/4BCC1KVA52WV26Q6Y051BR.uasset` — 14245 bytes — SHA-256 `28ba3ee4170394080b59e11ad0350457cac6325689dfa8c8b73a9ad79f06be88`

## Screenshots added in this range

- (none)

## Structured validation

```json
{
  "base_sha": "55eac73cc3d7e7b32abf7b7aebccc23b523b9ba9",
  "branch": "codex/airport-reference-rebuild",
  "controller_actor": "TL_Controller",
  "editor_final_state": {
    "all_saved_indicator": true,
    "map": "/AirportSecurity/AirportSecurity",
    "pending_push_count": "NOT_APPLICABLE_WITH_SESSION_DISCONNECTED",
    "revision_control_edits": 0,
    "saved": true,
    "session": "DISCONNECTED_FINAL_RELAUNCH_BLOCKED_BY_UEFN_SERVICES"
  },
  "implementation_head": "1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a",
  "known_unverified_items": [
    "Live walk, sprint, crouch, reverse-direction, and off-center scanner traversal without jumping",
    "Persisted screenshot of the moving passenger centered inside the scanner",
    "Manual body/bag/document/CLEAR case",
    "Manual SECONDARY passenger-and-bag route and reveal",
    "Manual correct and false detention",
    "Manual three-step power restoration and stale-timeout recovery",
    "Manual results/replay cleanup",
    "Real two-client claim contention, disconnect recovery, and join-in-progress HUD"
  ],
  "map": "/AirportSecurity/AirportSecurity",
  "multiplayer_test_status": "UNVERIFIED",
  "non_blocking_environment_warnings": [
    "Repeated Epic Connect messaging authentication warnings appeared in the editor log; they did not prevent compile, validation, or the observed live runtime path.",
    "The final post-commit Launch Session attempt was blocked because UEFN services were unavailable."
  ],
  "production_flags": {
    "AutoStartEnabled": false,
    "AutomatedReplayEnabled": false,
    "DebugEnabled": false,
    "verification": "Each checkbox was visually inspected as false in the saved TL_Controller details panel after the final production save. Verse defaults are also false."
  },
  "relevant_errors": [],
  "screenshots": [
    "docs/codex/proof-2026-07-29/10_native_scanner_and_conveyors.png",
    "docs/codex/proof-2026-07-29/11_power_cabinets.png",
    "docs/codex/proof-2026-07-29/12_furnished_detention_cell.png"
  ],
  "session_date": "2026-07-30",
  "tests": [
    {
      "name": "UEFN Verse build",
      "observed": "Compile Verse completed with the UEFN tooltip 'Built successfully.' after the final production save. The prior detailed log also recorded VerseBuild: SUCCESS.",
      "status": "PASS"
    },
    {
      "name": "Live map validation",
      "observed": "356 actors valid, 0 invalid, 0 not validated, 0 errors, 0 warnings, and no remaining disallowed fallbacks.",
      "status": "PASS"
    },
    {
      "name": "Production builder idempotency",
      "observed": "Second builder run: created 0, updated 91, deleted_stale 0, production_actor_count 91, actor count remained 356, no duplicate TL labels, level and dirty packages saved.",
      "status": "PASS"
    },
    {
      "name": "Scanner floor geometry and collision audit",
      "observed": "Terminal floor top, north scanner pad top, and south scanner pad top are all 88.0 cm. Decorative scanner pad static meshes use NoCollision; their bounds overlap only for query. The scan button is outside the aperture at (1120, -1850, 180).",
      "status": "PASS"
    },
    {
      "name": "Production intentional startup",
      "observed": "With production flags disabled in a live Fortnite session, the persistent HUD remained SHIFT 0/7, CASE 0/3, CLOCK 0s, POWER ONLINE, ALERT NORMAL and directed the player to the physical staffing desk. No stale QA replay started.",
      "status": "PASS"
    },
    {
      "name": "Runtime passenger scan and clear path probe",
      "observed": "The disabled-by-default QA probe invoked the same production handlers. Fortnite displayed BODY SCANNER ACTIVE and the UEFN Verse log recorded '[QA] Shift 1 body/clear path complete' at 2026-07-30 07:45:18 UTC. No Verse runtime error was observed. This was not a manually driven case.",
      "status": "PARTIAL"
    },
    {
      "name": "Manual scanner walk, sprint, crouch, both directions and off-center",
      "observed": "Direct held movement input could not be sustained by the available desktop automation API. Geometry and collision were audited, but live traversal must still be performed by a human or an input-capable test harness.",
      "status": "UNVERIFIED"
    },
    {
      "name": "Passenger scanner traversal",
      "observed": "The live runtime reached the production BODY SCANNER ACTIVE sequence and completed the Shift 1 body/clear marker. A persisted player-eye screenshot of the passenger inside the aperture was not captured.",
      "status": "PARTIAL"
    },
    {
      "name": "Complete normal manually driven case",
      "observed": "The production session was launched and intentional waiting state verified, but a complete case was not manually driven because held movement input was unavailable.",
      "status": "UNVERIFIED"
    },
    {
      "name": "Manual secondary, detention, power emergency, results and replay",
      "observed": "Production code and actor wiring were compiled and structurally validated, but these branches were not manually traversed in the live client during this session.",
      "status": "UNVERIFIED"
    },
    {
      "name": "Two-client contention and disconnect recovery",
      "observed": "Only one Fortnite client was available.",
      "status": "UNVERIFIED"
    },
    {
      "name": "Final production session relaunch",
      "observed": "After the final save, compile, validation, and commits, Launch Session was attempted again. UEFN remained Session Disconnected and reported that Unreal Editor for Fortnite services were currently unavailable.",
      "status": "FAIL"
    }
  ],
  "uefn_version": "5.8"
}
```

## Current worktree status at generation time

```text
 M CODEX_CONTINUATION_PROMPT.md
 M docs/codex/validation_2026-07-30.json
```

## Relevant text diffs

### Content/Python/build_airport_production_pass.py

```text
diff --git a/Content/Python/build_airport_production_pass.py b/Content/Python/build_airport_production_pass.py
index 3e10fbf..45333f1 100644
--- a/Content/Python/build_airport_production_pass.py
+++ b/Content/Python/build_airport_production_pass.py
@@ -60,8 +60,19 @@ def color_actor(actor, color_name):
     except Exception:
         return False
 
 
+def make_decorative_nonblocking(actor):
+    """Keep a thin visible surface without adding a player collision lip."""
+    for component in actor.get_components_by_class(unreal.StaticMeshComponent):
+        component.set_collision_enabled(unreal.CollisionEnabled.NO_COLLISION)
+    for property_name in ("no_collision", "no_pawn_collision", "no_physics_collision"):
+        try:
+            actor.set_editor_property(property_name, True)
+        except Exception:
+            pass
+
+
 def center_actor(actor, center):
     origin, _ = actor.get_actor_bounds(False)
     location = actor.get_actor_location()
     actor.set_actor_location(
@@ -312,23 +323,57 @@ for key, path in CLASSES.items():
         raise RuntimeError("Approved production class failed to load: " + path)
     classes[key] = loaded
 
 recolored = []
+scanner_pad_adjustments = []
+terminal_floor = next((actor for actor in actors_before if actor.get_actor_label() == "TL_ART_TerminalFloor"), None)
+terminal_floor_top = None
+if terminal_floor is not None:
+    floor_origin, floor_extent = terminal_floor.get_actor_bounds(False)
+    terminal_floor_top = floor_origin.z + floor_extent.z
 for actor in actors_before:
     label = actor.get_actor_label()
     if not label.startswith("TL_ART_"):
         continue
     suffix = label.removeprefix("TL_ART_")
     color = ART_COLORS.get(suffix)
     if color and color_actor(actor, color):
         recolored.append(label)
+    if suffix in ("ScannerSouthPad", "ScannerNorthPad") and terminal_floor_top is not None:
+        pad_origin, pad_extent = actor.get_actor_bounds(False)
+        location = actor.get_actor_location()
+        desired_origin_z = terminal_floor_top - pad_extent.z
+        actor.set_actor_location(
+            unreal.Vector(location.x, location.y, location.z + desired_origin_z - pad_origin.z),
+            False,
+            False,
+        )
+        make_decorative_nonblocking(actor)
+        adjusted_origin, adjusted_extent = actor.get_actor_bounds(False)
+        scanner_pad_adjustments.append(
+            {
+                "label": label,
+                "top": round(adjusted_origin.z + adjusted_extent.z, 3),
+                "floor_top": round(terminal_floor_top, 3),
+            }
+        )
 
 created = []
 for spec in BOXES:
     created.append(spawn_box(classes, *spec).get_actor_label())
 for spec in PROPS:
     created.append(spawn_prop(classes, *spec).get_actor_label())
 
+# The wired scan button was previously centered in the walk-through opening.
+# Keep it as the reliable interaction fallback, but mount it beside the arch so
+# the full scanner aperture is clear in both directions.
+scan_button_relocated = False
+for actor in all_actors():
+    if actor.get_actor_label() == "TL_BTN_Scan":
+        actor.set_actor_location(unreal.Vector(1120.0, -1850.0, 180.0), False, False)
+        scan_button_relocated = True
+        break
+
 stale = sorted(EXISTING)
 for label in stale:
     ACTORS.destroy_actor(EXISTING[label])
 
@@ -355,8 +400,10 @@ result = {
     "created": sum(1 for label in created if label not in existing_labels),
     "updated": sum(1 for label in created if label in existing_labels),
     "deleted_stale": len(stale),
     "recolored_art_actors": len(recolored),
+    "scanner_pad_adjustments": scanner_pad_adjustments,
+    "scan_button_relocated": scan_button_relocated,
     "removed_old_seats": len(removed_old_seats),
     "production_actor_count": len(created),
     "actor_count_before": len(actors_before),
     "actor_count_after": len(actors_after),
```
### Content/terminal_lockdown_controller.verse

```text
diff --git a/Content/terminal_lockdown_controller.verse b/Content/terminal_lockdown_controller.verse
index 046d82c..db4cbdc 100644
--- a/Content/terminal_lockdown_controller.verse
+++ b/Content/terminal_lockdown_controller.verse
@@ -172,8 +172,13 @@ terminal_lockdown_controller := class(creative_device):
 
     @editable
     DebugEnabled:logic = false
 
+    # Production runs wait for an officer to use the physical START SHIFT
+    # control. This remains an opt-in convenience for isolated local testing.
+    @editable
+    AutoStartEnabled:logic = false
+
     # Development-only end-to-end replay. Keep false in production. When
     # enabled, it invokes the same public interaction handlers used by players
     # and writes [QA] markers to the live Verse log.
     @editable
@@ -202,8 +207,9 @@ terminal_lockdown_controller := class(creative_device):
     var PassengerReadyForScan:logic = false
     var ScanInProgress:logic = false
     var BagScanInProgress:logic = false
     var SecondaryPassengerReady:logic = false
+    var SecondaryBagReady:logic = false
     var PassengerAtIntake:logic = false
     var ActivePassengerMoveGeneration:int = 0
     var ResolutionCommitted:logic = false
     var CustodyCommitted:logic = false
@@ -233,8 +239,13 @@ terminal_lockdown_controller := class(creative_device):
     var PersistentHUDRoot:[player]canvas = map{}
     var PersistentHUDText:[player]text_block = map{}
     var UpgradeRootUI:[player]canvas = map{}
     var UpgradeOpenShift:[player]int = map{}
+    var QueueFrontMarker:vector3 = vector3{}
+    var QueueMiddleMarker:vector3 = vector3{}
+    var QueueRearMarker:vector3 = vector3{}
+    var PowerHomePosition:vector3 = vector3{}
+    var PowerHomeRotation:rotation = IdentityRotation()
 
     OnBegin<override>()<suspends>:void=
         StartButton.InteractedWithEvent.Subscribe(OnStartButton)
         ScanButton.InteractedWithEvent.Subscribe(OnScanButton)
@@ -250,24 +261,27 @@ terminal_lockdown_controller := class(creative_device):
         PowerButton.InteractedWithEvent.Subscribe(OnPowerButton)
         GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
         GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
 
+        CaptureRouteMarkers()
         ConfigureButtons()
         ConfigurePhysicalPresentation()
         spawn{PersistentHUDLoop()}
-        spawn{AutoStartWaitingRun()}
+        if (AutoStartEnabled?):
+            spawn{AutoStartWaitingRun()}
         if (AutomatedReplayEnabled?):
             spawn{RunAutomatedReplay()}
         ShowAll("TERMINAL LOCKDOWN | Press START SHIFT at the briefing desk.", 8.0)
         TerminalLog(DebugEnabled, "[BOOT] Controller ready; waiting for players")
 
     RunAutomatedReplay()<suspends>:void=
-        # The physical passenger needs just over three seconds to reach the
-        # scanner after AutoStartWaitingRun opens Shift 1. Keep the harness
-        # behind the real movement and asynchronous scan/bag timings so every
-        # logged milestone represents a committed production handler result.
-        Sleep(6.5)
+        # The disabled harness intentionally starts the same physical run that
+        # an officer starts at the briefing desk; production no longer begins
+        # a shift automatically when a player joins.
+        Sleep(1.0)
         for (Player : GetPlayspace().GetPlayers()):
+            OnStartButton(Player)
+            Sleep(5.5)
             TerminalLog(true, "[QA] Automated replay begin")
 
             # Shift 1: physical passenger, body evidence, and clear decision.
             OnScanButton(Player)
@@ -881,8 +895,9 @@ terminal_lockdown_controller := class(creative_device):
         set PassengerReadyForScan = false
         set ScanInProgress = false
         set BagScanInProgress = false
         set SecondaryPassengerReady = false
+        set SecondaryBagReady = false
         set PassengerAtIntake = false
         set FinalCaseAccountingCommitted = false
         set QueueFrontIndex = 0
         set QueueGeneration += 1
@@ -931,23 +946,55 @@ terminal_lockdown_controller := class(creative_device):
         spawn{RunScannerSequence(CurrentCaseId, RunGeneration, ScannerGeneration, CurrentTemplate)}
         TerminalLog(DebugEnabled, "[SCAN] Started|CaseId={CurrentCaseId}|Template={CurrentTemplate}|Generation={ScannerGeneration}")
 
     RunScannerSequence(ExpectedCaseId:int, ExpectedRun:int, ExpectedScannerGeneration:int, Template:int)<suspends>:void=
-        Sleep(0.5)
+        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | ENTERING")
+        EnteredScanner := MoveActivePassengerChecked(
+            ScannerCenterPosition(),
+            ScannerEntryPosition(),
+            0.8,
+            ExpectedCaseId,
+            ExpectedRun,
+            "scanner-enter"
+        )
         if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
             return
+        if (not EnteredScanner?):
+            set ScanInProgress = false
+            set Phase = terminal_game_phase.CaseReady
+            SetBoard(CheckpointBoard, "SCANNER ROUTE RESET | RETRY BODY SCAN")
+            return
         if (not PowerOnline?):
             set ScanInProgress = false
             SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
             return
-        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 50%")
+        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 25%")
+        Sleep(0.35)
+        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
+            return
+        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 75%")
         Sleep(ScannerSweepStageSeconds())
         if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
             return
         if (not PowerOnline?):
             set ScanInProgress = false
             SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
             return
+        ExitedScanner := MoveActivePassengerChecked(
+            ScannerExitPosition(),
+            ScannerCenterPosition(),
+            0.8,
+            ExpectedCaseId,
+            ExpectedRun,
+            "scanner-exit"
+        )
+        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
+            return
+        if (not ExitedScanner?):
+            set ScanInProgress = false
+            set Phase = terminal_game_phase.CaseReady
+            SetBoard(CheckpointBoard, "SCANNER EXIT RESET | RETRY BODY SCAN")
+            return
         set BodyChecked = true
         set ScanInProgress = false
         set Phase = terminal_game_phase.AwaitingDecision
         SyncActiveCase()
@@ -996,10 +1043,10 @@ terminal_lockdown_controller := class(creative_device):
         var TunnelReached:logic = false
         if (BagIndex = 0):
             set TunnelReached = MovePropChecked(
                 BagPropSmall,
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
+                BagXRayPosition(),
+                BagEntryPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1007,10 +1054,10 @@ terminal_lockdown_controller := class(creative_device):
             )
         else if (BagIndex = 1):
             set TunnelReached = MovePropChecked(
                 BagPropMedium,
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
+                BagXRayPosition(),
+                BagEntryPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1018,10 +1065,10 @@ terminal_lockdown_controller := class(creative_device):
             )
         else:
             set TunnelReached = MovePropChecked(
                 BagPropHardShell,
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
+                BagXRayPosition(),
+                BagEntryPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1043,10 +1090,10 @@ terminal_lockdown_controller := class(creative_device):
         var ExitReached:logic = false
         if (BagIndex = 0):
             set ExitReached = MovePropChecked(
                 BagPropSmall,
-                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
+                BagExitPosition(),
+                BagXRayPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1054,10 +1101,10 @@ terminal_lockdown_controller := class(creative_device):
             )
         else if (BagIndex = 1):
             set ExitReached = MovePropChecked(
                 BagPropMedium,
-                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
+                BagExitPosition(),
+                BagXRayPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1065,10 +1112,10 @@ terminal_lockdown_controller := class(creative_device):
             )
         else:
             set ExitReached = MovePropChecked(
                 BagPropHardShell,
-                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
+                BagExitPosition(),
+                BagXRayPosition(),
                 1.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1263,18 +1310,24 @@ terminal_lockdown_controller := class(creative_device):
         set Phase = terminal_game_phase.SecondaryScreening
         set CurrentDestination = terminal_case_destination.Secondary
         CloseAllDocumentInterfaces()
         set SecondaryPassengerReady = false
+        set SecondaryBagReady = false
         set CurrentCustodyMode = 4
         SetDecisionControlsAvailable(false)
         CustodyButton.SetInteractionText(TerminalMessage("PERFORM SECONDARY CHECK"))
         CustodyButton.Enable()
         SyncActiveCase()
         SetBoard(CaseBoard, "CASE {CurrentCaseId} | ROUTING TO SECONDARY")
-        SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER IN TRANSIT")
-        ShowAll("SECONDARY SELECTED | Follow the passenger to the controlled room, then perform the additional check at intake.", 8.0)
+        SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER + BAG IN TRANSIT")
+        ShowAll("SECONDARY SELECTED | Follow the passenger and linked bag to the controlled room, then perform the additional check at intake.", 8.0)
         TerminalLog(DebugEnabled, "[SECONDARY] Routed|CaseId={CurrentCaseId}|Template={CurrentTemplate}")
         spawn{MovePassengerToSecondary(CurrentCaseId, RunGeneration)}
+        if (Shift >= 2):
+            set BagGeneration += 1
+            spawn{MoveActiveBagToSecondary(CurrentCaseId, RunGeneration, BagGeneration, ActiveBagIndex)}
+        else:
+            set SecondaryBagReady = true
 
     OnDetainButton(Agent:agent):void=
         if (Phase = terminal_game_phase.Runner):
             CaptureRunner(Agent)
@@ -1437,9 +1490,9 @@ terminal_lockdown_controller := class(creative_device):
         if (not PassengerAtIntake?):
             ShowAgent(Agent, "SUSPECT IN TRANSIT | Wait for detention intake to report ready.", 4.0)
             TerminalLog(DebugEnabled, "[CUSTODY] Premature intake rejected for CaseId={CurrentCaseId}")
             return
-        if (not IsAgentNear(Agent, vector3{X := 5000.0, Y := 1450.0, Z := 70.0}, CustodyProximityRadius)?):
+        if (not IsAgentNear(Agent, CustodyButton.GetTransform().Translation, CustodyProximityRadius)?):
             ShowAgent(Agent, "TOO FAR FROM INTAKE | Escort the secured suspect to the jail gate.", 5.0)
             TerminalLog(DebugEnabled, "[CUSTODY] Remote intake rejected for CaseId={CurrentCaseId}")
             return
         if (CustodyCommitted?):
@@ -1469,9 +1522,12 @@ terminal_lockdown_controller := class(creative_device):
             return
         if (not SecondaryPassengerReady?):
             ShowAgent(Agent, "SECONDARY PASSENGER IN TRANSIT | Wait for the room status to turn ready.", 4.0)
             return
-        if (not IsAgentNear(Agent, vector3{X := 5000.0, Y := 1450.0, Z := 70.0}, 750.0)?):
+        if (Shift >= 2, not SecondaryBagReady?):
+            ShowAgent(Agent, "SECONDARY BAG IN TRANSIT | Wait for the linked bag at the inspection table.", 4.0)
+            return
+        if (not IsAgentNear(Agent, CustodyButton.GetTransform().Translation, 750.0)?):
             ShowAgent(Agent, "SECONDARY CHECK OUT OF RANGE | Enter the controlled screening room.", 5.0)
             return
         if (SecondaryChecked?):
             TerminalLog(DebugEnabled, "[SECONDARY] Duplicate check rejected for CaseId={CurrentCaseId}")
@@ -1480,8 +1536,9 @@ terminal_lockdown_controller := class(creative_device):
         if (not Claimed?):
             return
         set SecondaryChecked = true
         set SecondaryPassengerReady = false
+        set SecondaryBagReady = false
         set CurrentCustodyMode = 0
         if (TeamCash >= 25):
             set TeamCash -= 25
         set Phase = terminal_game_phase.AwaitingDecision
@@ -1500,20 +1557,20 @@ terminal_lockdown_controller := class(creative_device):
         SyncActiveCase()
         var EscapeReached:logic = false
         if (Shift = 4):
             RouteA := MoveActivePassengerChecked(
-                vector3{X := 5200.0, Y := 900.0, Z := 70.0},
-                vector3{X := 4200.0, Y := 720.0, Z := 70.0},
+                RunnerRouteAPosition(),
+                SecurePadPosition(),
                 4.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 "runner-route-a"
             )
             if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                 return
             ExitA := MoveActivePassengerChecked(
-                vector3{X := 7000.0, Y := 1600.0, Z := 70.0},
-                vector3{X := 5200.0, Y := 900.0, Z := 70.0},
+                RunnerExitAPosition(),
+                RunnerRouteAPosition(),
                 6.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 "runner-exit-a"
@@ -1521,20 +1578,20 @@ terminal_lockdown_controller := class(creative_device):
             if (RouteA? and ExitA?):
                 set EscapeReached = true
         else:
             RouteB := MoveActivePassengerChecked(
-                vector3{X := 5150.0, Y := -850.0, Z := 70.0},
-                vector3{X := 4200.0, Y := -350.0, Z := 70.0},
+                RunnerRouteBPosition(),
+                OffsetPosition(DecisionPassengerPosition(), 300.0, -350.0, 0.0),
                 4.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 "runner-route-b"
             )
             if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                 return
             ExitB := MoveActivePassengerChecked(
-                vector3{X := 7000.0, Y := -1800.0, Z := 70.0},
-                vector3{X := 5150.0, Y := -850.0, Z := 70.0},
+                RunnerExitBPosition(),
+                RunnerRouteBPosition(),
                 6.0,
                 ExpectedCaseId,
                 ExpectedRun,
                 "runner-exit-b"
@@ -1560,10 +1617,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToDepartureAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Departure
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 7000.0, Y := 1100.0, Z := 70.0},
-            vector3{X := 5200.0, Y := 900.0, Z := 70.0},
+            DeparturePosition(),
+            DepartureRetryPosition(),
             3.0,
             ExpectedCaseId,
             ExpectedRun,
             "departure"
@@ -1577,10 +1634,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToIntake(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Detention
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
-            vector3{X := 4200.0, Y := 720.0, Z := 70.0},
+            IntakePosition(),
+            SecurePadPosition(),
             4.0,
             ExpectedCaseId,
             ExpectedRun,
             "detention-intake"
@@ -1604,10 +1661,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToSecurePad(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Detention
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 4200.0, Y := 720.0, Z := 70.0},
-            vector3{X := 3900.0, Y := 0.0, Z := 70.0},
+            SecurePadPosition(),
+            DecisionPassengerPosition(),
             1.5,
             ExpectedCaseId,
             ExpectedRun,
             "secure-pad"
@@ -1624,19 +1681,22 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToSecondary(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Secondary
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 5400.0, Y := 2600.0, Z := 70.0},
-            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
+            SecondaryPassengerPosition(),
+            IntakePosition(),
             4.0,
             ExpectedCaseId,
             ExpectedRun,
             "secondary"
         )
         if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.SecondaryScreening and CurrentCustodyMode = 4):
             if (MoveReached?):
                 set SecondaryPassengerReady = true
-                SetBoard(SecondaryBoard, "SECONDARY READY\nPERFORM ADDITIONAL CHECK")
+                if (Shift < 2 or SecondaryBagReady?):
+                    SetBoard(SecondaryBoard, "SECONDARY READY\nPASSENGER + BAG PRESENT")
+                else:
+                    SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER READY | BAG IN TRANSIT")
                 SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER IN SECONDARY ROOM")
             else:
                 set CurrentCustodyMode = 0
                 set Phase = terminal_game_phase.AwaitingDecision
@@ -1645,14 +1705,60 @@ terminal_lockdown_controller := class(creative_device):
                 SetBoard(SecondaryBoard, "SECONDARY ROUTE OFFLINE\nRETURN TO DECISION")
                 ShowAll("SECONDARY ROUTE RESET | Return to the decision desk and choose a final action.", 7.0)
             SyncActiveCase()
 
+    MoveActiveBagToSecondary(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, BagIndex:int)<suspends>:void=
+        var BagReached:logic = false
+        if (BagIndex = 0):
+            set BagReached = MovePropChecked(
+                BagPropSmall,
+                SecondaryBagPosition(),
+                BagExitPosition(),
+                2.0,
+                ExpectedCaseId,
+                ExpectedRun,
+                ExpectedBagGeneration,
+                "secondary-bag-small"
+            )
+        else if (BagIndex = 1):
+            set BagReached = MovePropChecked(
+                BagPropMedium,
+                SecondaryBagPosition(),
+                BagExitPosition(),
+                2.0,
+                ExpectedCaseId,
+                ExpectedRun,
+                ExpectedBagGeneration,
+                "secondary-bag-medium"
+            )
+        else:
+            set BagReached = MovePropChecked(
+                BagPropHardShell,
+                SecondaryBagPosition(),
+                BagExitPosition(),
+                2.0,
+                ExpectedCaseId,
+                ExpectedRun,
+                ExpectedBagGeneration,
+                "secondary-bag-hard-shell"
+            )
+        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration or Phase <> terminal_game_phase.SecondaryScreening):
+            return
+        if (BagReached?):
+            set SecondaryBagReady = true
+            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | SECONDARY TABLE READY")
+            if (SecondaryPassengerReady?):
+                SetBoard(SecondaryBoard, "SECONDARY READY\nPASSENGER + BAG PRESENT")
+        else:
+            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | SECONDARY ROUTE FAULT")
+            ShowAll("SECONDARY BAG ROUTE RESET | Retry the case decision or use the final action controls.", 6.0)
+
     MovePassengerToResponse(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Response
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 5200.0, Y := -1900.0, Z := 70.0},
-            vector3{X := 5000.0, Y := -1200.0, Z := 70.0},
+            ResponsePassengerPosition(),
+            ResponsePassengerRetryPosition(),
             4.0,
             ExpectedCaseId,
             ExpectedRun,
             "response"
@@ -1671,10 +1777,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerIntoCellAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Cell
         SyncActiveCase()
         MoveReached := MoveActivePassengerChecked(
-            vector3{X := 5550.0, Y := 1450.0, Z := 70.0},
-            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
+            CellPosition(),
+            IntakePosition(),
             2.0,
             ExpectedCaseId,
             ExpectedRun,
             "cell"
@@ -1723,8 +1829,9 @@ terminal_lockdown_controller := class(creative_device):
         set BagScanInProgress = false
         set DocumentsChecked = false
         set SecondaryChecked = false
         set SecondaryPassengerReady = false
+        set SecondaryBagReady = false
         set PassengerAtIntake = false
         set ResolutionCommitted = false
         set CustodyCommitted = false
         set FinalCaseAccountingCommitted = false
@@ -1758,10 +1865,10 @@ terminal_lockdown_controller := class(creative_device):
         SyncActiveCase()
         if (ActiveBagIndex = 0):
             StartReached := MovePropChecked(
                 BagPropSmall,
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
+                BagStagePosition(),
+                BagStageRetryPosition(),
                 0.1,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1771,10 +1878,10 @@ terminal_lockdown_controller := class(creative_device):
                 return
             BagPropSmall.Show()
             ArrivalReached := MovePropChecked(
                 BagPropSmall,
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
+                BagEntryPosition(),
+                BagStagePosition(),
                 1.5,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1784,10 +1891,10 @@ terminal_lockdown_controller := class(creative_device):
                 return
         else if (ActiveBagIndex = 1):
             StartReached := MovePropChecked(
                 BagPropMedium,
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
+                BagStagePosition(),
+                BagStageRetryPosition(),
                 0.1,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1797,10 +1904,10 @@ terminal_lockdown_controller := class(creative_device):
                 return
             BagPropMedium.Show()
             ArrivalReached := MovePropChecked(
                 BagPropMedium,
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
+                BagEntryPosition(),
+                BagStagePosition(),
                 1.5,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1810,10 +1917,10 @@ terminal_lockdown_controller := class(creative_device):
                 return
         else:
             StartReached := MovePropChecked(
                 BagPropHardShell,
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
+                BagStagePosition(),
+                BagStageRetryPosition(),
                 0.1,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1823,10 +1930,10 @@ terminal_lockdown_controller := class(creative_device):
                 return
             BagPropHardShell.Show()
             ArrivalReached := MovePropChecked(
                 BagPropHardShell,
-                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
-                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
+                BagEntryPosition(),
+                BagStagePosition(),
                 1.5,
                 ExpectedCaseId,
                 ExpectedRun,
                 ExpectedBagGeneration,
@@ -1854,10 +1961,10 @@ terminal_lockdown_controller := class(creative_device):
         set CurrentDestination = terminal_case_destination.Scanner
         SyncActiveCase()
         PassengerActive.Hide()
         MoveResult0 := MoveActivePassengerChecked(
-            vector3{X := -650.0, Y := -2150.0, Z := 70.0},
-            vector3{X := -650.0, Y := -2450.0, Z := 70.0},
+            QueuePassengerStagePosition(),
+            OffsetPosition(QueuePassengerStagePosition(), 0.0, -300.0, 0.0),
             0.1,
             ExpectedCaseId,
             ExpectedRun,
             "scanner-stage"
@@ -1866,30 +1973,30 @@ terminal_lockdown_controller := class(creative_device):
             SetBoard(CheckpointBoard, "PASSENGER ROUTE RESET | CASE {CurrentCaseId}")
             return
         PassengerActive.Show()
         MoveResult1 := MoveActivePassengerChecked(
-            vector3{X := -100.0, Y := -2150.0, Z := 70.0},
-            vector3{X := -650.0, Y := -2150.0, Z := 70.0},
+            OffsetPosition(QueuePassengerStagePosition(), 550.0, 0.0, 0.0),
+            QueuePassengerStagePosition(),
             1.0,
             ExpectedCaseId,
             ExpectedRun,
             "scanner-approach-a"
         )
         if (not MoveResult1? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
             return
         MoveResult2 := MoveActivePassengerChecked(
-            vector3{X := 450.0, Y := -1900.0, Z := 70.0},
-            vector3{X := -100.0, Y := -2150.0, Z := 70.0},
+            OffsetPosition(ScannerEntryPosition(), -250.0, -600.0, 0.0),
+            OffsetPosition(QueuePassengerStagePosition(), 550.0, 0.0, 0.0),
             1.0,
             ExpectedCaseId,
             ExpectedRun,
             "scanner-approach-b"
         )
         if (not MoveResult2? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
             return
         MoveResult3 := MoveActivePassengerChecked(
-            vector3{X := 900.0, Y := -1300.0, Z := 70.0},
-            vector3{X := 450.0, Y := -1900.0, Z := 70.0},
+            ScannerEntryPosition(),
+            OffsetPosition(ScannerEntryPosition(), -250.0, -600.0, 0.0),
             1.0,
             ExpectedCaseId,
             ExpectedRun,
             "scanner-position"
@@ -1902,10 +2009,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToDecision(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Decision
         SyncActiveCase()
         MoveResult := MoveActivePassengerChecked(
-            vector3{X := 3900.0, Y := 0.0, Z := 70.0},
-            vector3{X := 3250.0, Y := -650.0, Z := 70.0},
+            DecisionPassengerPosition(),
+            DocumentPassengerPosition(),
             3.0,
             ExpectedCaseId,
             ExpectedRun,
             "decision"
@@ -1919,10 +2026,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToBaggage(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
         set CurrentDestination = terminal_case_destination.Baggage
         SyncActiveCase()
         MoveResult := MoveActivePassengerChecked(
-            vector3{X := 2700.0, Y := -650.0, Z := 70.0},
-            vector3{X := 2050.0, Y := -1100.0, Z := 70.0},
+            BaggagePassengerPosition(),
+            BaggagePassengerRetryPosition(),
             2.0,
             ExpectedCaseId,
             ExpectedRun,
             "baggage"
@@ -1937,10 +2044,10 @@ terminal_lockdown_controller := class(creative_device):
     MovePassengerToDocumentDesk(ExpectedCa

[diff truncated after 30000 characters]
```
