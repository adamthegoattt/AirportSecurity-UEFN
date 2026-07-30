# Validation log

## Historical baseline — 2026-07-28 PDT

- Project originally opened with 14 actors, no Verse source, and Python disabled.
- The initial bridge connection was refused until Python was enabled and UEFN
  restarted.
- Lore offline/local status could not deserialize revision states; no destructive
  Lore repair was attempted.

## Validated reference pass — 2026-07-28 PDT

- Complete terminal build saved: `created=63`, `updated=80`,
  `deleted_proofs=4`, `expected=143`, `actors_total=155`.
- Idempotency rerun: `created=0`, `updated=143`, no duplicates.
- Reflection audit: 118 GridPlane, 12 Button, 7 Billboard, 4 Character, 1 HUD
  Message, 1 Verse; all `TL_` labels unique; no proof/trial labels.
- Verse build and Push Verse Changes succeeded.
- Content activation succeeded on all platforms.
- Live production replay passed body/clear, full evidence/secondary,
  detention/duplicate custody guard, power outage/restore, detected boss
  victory, and replay reset.
- QA flags were returned to false; the final reload emitted no new QA marker or
  relevant compile/validation/runtime failure.

## Fresh continuation baseline — 2026-07-28 PDT

- UEFN visible state before testing: `AirportSecurity`, `Game in Progress`,
  `All Saved`, `0 Edits - 0 Pending Push`.
- No-source-change Verse build: PASS; editor reported `Built successfully`.
- Refresh Session local validation: PASS; `Project AirportSecurity up to date`,
  `FlowStep_RunLocalValidation(): Complete`, upload channel completed.
- Candidate validation/cook/update: PASS; session distribution completed and
  `Server Summary - Successfully activated content on all platforms`.
- Fortnite client remained connected, responsive, at 60 FPS with 0% packet
  loss and one player.
- Real two-player testing remains pending.

## Extended replay QA — 2026-07-28 PDT

- Added a disabled-by-default regression extension to `RunAutomatedReplay` and
  parameterized `EmergencyTimeout` so production still uses the editable
  45-second wait while intentional QA can invoke the same handler with one
  second.
- Verse compile: PASS. UEFN reported `Built successfully`; log reported global
  compile `SUCCESS` and `VerseBuild: SUCCESS -- Build complete`.
- Live update/refresh: PASS. Candidate validation, cook/update, distribution,
  and activation completed; final normal-mode activation logged `Server Summary
  - Successfully activated content on all platforms` at 00:57:39 UTC.
- Two complete extended replay sequences logged:
  - owner loss released CaseId 7;
  - claim release/reclaim and duplicate-decision guard complete;
  - Shift 7 missed-boss branch reached victory;
  - emergency timeout penalty and recovery complete;
  - reset returned to waiting.
- Returned `AutomatedReplayEnabled` to false, saved the map, refreshed the
  session, and confirmed no QA2 marker later than 00:55:29 UTC.
- Final editor state: `Game in Progress`, `All Saved`, `0 Edits - 0 Pending
  Push`. One-client deterministic evidence is not classified as multiplayer.

## Failure branch replay QA — 2026-07-28 PDT

- Extended the disabled-by-default replay through real `PrepareNextCase`, body,
  bag, document, decision, runner, response, custody, movement, finish, and reset
  handlers. No production default or asset dependency changed.
- Verse compile: PASS at 01:18:21 and 01:18:24 UTC; both log entries ended with
  `VerseBuild: SUCCESS -- Build complete`.
- QA activation: PASS at 01:20:56 UTC.
- Exact branch evidence:
  - false detention: `FalseDetentions=1|Resolved=1|Integrity=95|Risk=4|Cash=-100`;
  - runner capture: `Correct=1|Resolved=1|Integrity=100|Risk=0|Cash=175`;
  - runner escape: `Correct=1|Resolved=1|Integrity=90|Risk=16|Cash=0`;
  - resistant response: `Correct=1|Resolved=1|Integrity=100|Risk=0|Cash=175`;
  - post-branch clean case: `Correct=1|Resolved=1|Integrity=100|Risk=0|Cash=100`.
- `[QA3] Failure-branch replay complete; returned to waiting` logged at
  01:22:32 UTC.
- Returned `AutomatedReplayEnabled` to false, saved, and completed a clean
  normal-mode activation at 01:24:10 UTC. No QA3 marker and no relevant error
  appeared after that activation.

## Reference-match luggage milestone - 2026-07-28 PDT

- Added three Asteria commerce-luggage Blueprint props with stable labels
  `TL_BAG_Small`, `TL_BAG_Medium`, and `TL_BAG_HardShell`; wired all three
  controller editables in UEFN and saved the map.
- Added guarded inbound conveyor, X-ray tunnel, result, and exit movement tied
  to the active case/template. Verse compilation reported `Built successfully`.
- Removed the physical `TL_BTN_Debug` actor, its editable reference, setup, and
  handler. Production flags remain `DebugEnabled=false` and
  `AutomatedReplayEnabled=false`.
- Fresh editor validation: result code 0; 1 requested, 1 checked, 1 valid,
  0 invalid, 0 warnings. Actor audit: 234 actors, exactly three `TL_BAG_`
  actors, and no proof/debug/replay label residue.
- Current live activation remained blocked outside project code at this dated
  milestone by `errors.com.epicgames.common.processing`; later checkpoints
  supersede that connection status.

## Document inspection interface - 2026-07-28 PDT

- Replaced the long world-board-only inspection path with a centered,
  per-player Verse UI. It presents fictional identity fields, a portrait
  placeholder, expiry, destination, flight/gate, access tier, and separate
  portrait, expiry, seal, route, and access consistency checks.
- Added duplicate-open protection, a keyboard/controller return button,
  explicit claim release on close, and cleanup on decision, case change,
  player removal, shift break, and reset. The world Billboard remains the
  fallback summary.
- Focused Verse build reported `Built successfully`. Fresh map validation again
  returned 1/1 valid with 0 invalid and 0 warnings; residue audit remained
  empty. Live UI interaction was pending at this dated milestone.

## Physical decision controls - 2026-07-28 PDT

- Added three large, spaced physical pads using the proven Fortnite green,
  yellow, and red cube classes. Existing Clear, Secondary, and Detain Button
  devices were enlarged and retained as the interaction/fallback layer.
- Added dedicated control Billboards and wired all three references to
  `TL_Controller`. Runtime presentation identifies each outcome, locks the
  station until required evidence is complete, disables after submission, and
  displays the committed decision.
- Focused Verse build reported `Built successfully`. Fresh map validation
  returned result code 0: 1 requested, 1 checked, 1 valid, 0 invalid, and
  0 warnings. Actor audit reported 240 actors, exactly three `TL_DECISION_`
  pads, three dedicated control boards, and no proof/debug/replay residue.
- The disposable cube proof was removed through supported editor actor
  destruction before the production controls were saved.

## Physical custody and jail state — 2026-07-28 PDT

- Added and wired `TL_NPC_JailOccupant` and `TL_BOARD_CellStatus`; both are
  single reusable devices, so repeated cases do not spawn unbounded actors.
- Added code-level player-distance gates for intake custody, runner intercept,
  and resistant response. Rejected remote actions occur before claim or reward
  state changes.
- Verse compile: PASS; UEFN reported `Built successfully`.
- Map validation: PASS; `num_requested=1`, `num_checked=1`, `num_valid=1`,
  `num_invalid=0`, `num_warnings=0`.
- Actor audit: 242 level actors, exactly one `TL_NPC_JailOccupant`, exactly one
  `TL_BOARD_CellStatus`, and no proof/debug/replay actor labels.
- Live behavior retest is pending because two clean Launch Session attempts
  failed at Epic's handshake with `errors.com.epicgames.common.processing`.
  `DebugEnabled=false` and `AutomatedReplayEnabled=false` remain the production
  defaults.

## Physical response event - 2026-07-28 PDT

- Added and wired seven production actors in
  `TerminalLockdown/Gameplay/ResponseEvent`: Item Granter, Item Remover, Signal
  Remote Manager, Audio Player, two Point Light devices, and one Billboard.
- The initial legacy customizable-light blueprint candidates were rejected at
  wiring time because they were not compatible with Verse
  `customizable_light_device`. They were replaced through the editor API with
  `/CRD_PointLight/Device_PointLight_V2.Device_PointLight_V2_C`; both final
  lights are red and controller-wired.
- Audio is `Timer Siren Cue` with restart and loop enabled. Response issue and
  cleanup use registered Signal Remote A items, with all-player recall on every
  terminal branch.
- Final Verse compile: PASS; UEFN tooltip reported `Built successfully`.
- Final map validation: PASS; `num_requested=1`, `num_checked=1`,
  `num_valid=1`, `num_invalid=0`, `num_warnings=0`.
- Actor audit: 249 level actors. Exact response packages:
  - granter `E/2Q/DLQ3FIK63E3RJNM277FZ9L`;
  - remover `4/PL/O6AFUI3KG7PSIHHK7WJJAI`;
  - remote manager `2/JF/QX60TNVYDUZY0449D9TVFW`;
  - alarm `6/7N/D6UEG0JPPW96GBEU9S2OH4`;
  - light A `7/XS/QQEYTUQU9O0D740HMMWT43`;
  - light B `4/Z3/MWBIDVDRJH660ANESYIWPO`;
  - board `9/M2/41AYRYTM0Z216J0APHNKNI`.
- The ResponseEvent ActorFolder external object is
  `6/DK/VBSOL9IHO7SITNB7MK63OU`; two older untracked ReferenceProof and
  ReferenceMatch folder objects remain intentionally excluded from staging.
- A live runtime state-capture chain is still blocked by Epic's
  `errors.com.epicgames.common.processing` handshake error. The controlled
  Character patrol is therefore documented as the safe fallback, and no true
  combat-AI or live-state claim is made.

## Airport feedback and alert states - 2026-07-28 PDT

- Added six saved Audio Players in `TerminalLockdown/Gameplay/Feedback` for
  scanner start/result, bag scan, decision press, positive, and negative cues.
  All are global, non-looping, and restart on activation.
- Controller serialization contains the six editable property names and the
  six assigned external-actor package IDs; each audio package contains its
  selected cue reference.
- Final Verse compile: PASS; UEFN tooltip reported `Built successfully`.
- Final map validation: PASS; `num_requested=1`, `num_checked=1`,
  `num_valid=1`, `num_invalid=0`, `num_warnings=0`.
- Actor audit: 255 level actors; all six feedback actors in the production
  folder; three pooled bags and both custody actors present; no
  proof/debug/replay actor labels.
- Saved editor state is `All Saved`. `DebugEnabled=false` and
  `AutomatedReplayEnabled=false` remain the production defaults.
- Live feedback/alert testing and eleven final reference-angle captures remain
  blocked by Epic's `errors.com.epicgames.common.processing` handshake. No
  screenshot-proof commit was created.

## Complete reference-match production pass - 2026-07-29 PDT

- Canonical idempotent builder:
  `Content/Python/build_reference_match_pass.py`.
- Final repeated execution: `created=104`, `stale_removed=0`,
  `hidden_legacy_visuals=24`, `spawn_pads_normalized=2`,
  `player_starts_repositioned=2`, `saved=true`, `actor_count=282`.
- Actor/label audit: 282 actors, 270 unique `TL_` labels, 104 unique
  `TL_ART_*` labels, zero duplicate labels, and no proof/debug/replay residue.
- Final Verse compilation: PASS; UEFN reported `Built successfully`.
- Final map validation: PASS; `num_requested=1`, `num_checked=1`,
  `num_valid=1`, `num_invalid=0`, `num_warnings=0`.
- Spawn audit: both Player Spawn Pads at `(500,-1250,64)` and
  `(500,1250,64)`, yaw 0; matching player starts at Z 180; each has at least
  465 cm measured static clearance. Island Settings select Spawn Pads; both
  devices are enabled Always and are valid island starts.
- Connected-session boot and controller HUD/case state were observed. A final
  manual respawn in the long-lived edit session did not provide conclusive
  camera-location evidence after the move. Fresh-session traversal and eleven
  runtime camera captures remain honest manual QA because automated input
  cannot reliably hold movement or capture the Fortnite mouse.
- Final application state: UEFN open, `All Saved`, `Session Connected`, game
  stopped; Fortnite open. Publishing was not performed.

## State and routing hardening validation - 2026-07-29 PDT

- Changed production sources: `Content/terminal_lockdown_controller.verse` and
  `Content/terminal_lockdown_types.verse`.
- UEFN Verse compile: PASS (`Built successfully`; script linking and
  `VerseBuild: SUCCESS`).
- Connected-session refresh: PASS. Local validation completed, scratch push and
  candidate validation succeeded, upload completed, and content activated on
  all platforms.
- Runtime state replay: PASS for clear, body/bag/document/secondary, detention
  duplicate guard, power outage/restore, claim release/reclaim, emergency
  timeout/recovery, and both final-threat accounting branches.
- Movement evidence included direct arrivals, stale-callback rejection, and
  retry/teleport fallback when concurrent QA movement blocked a route. No Verse
  runtime error was observed.
- Live-client smoke: PASS for join/game-in-progress, approximately 50 FPS, and
  zero observed packet loss. FAIL for spawn presentation: the initial view is
  overbright/open and building controls remain available.
- Not tested: human end-to-end traversal, two-client claim contention and owner
  disconnect, normal-speed 21-case pacing, and representative multiplayer
  performance.
- No map actors/devices were added or changed in this checkpoint; the prior
  282-actor reference-match audit remains the applicable map inventory.

## Final custody-route race regression - 2026-07-29 PDT

- A bounded replay first exposed that runner/response interception could start
  a detention move while the previous active-passenger `MoveTo` was still
  unwinding. The overlapping calls could both remain suspended and prevent the
  cell transfer from completing.
- Added active-passenger movement generations, an explicit
  `PassengerAtIntake` invariant, and a custody readiness rejection. A newer
  route now supersedes an interrupted route before that route can retry.
- Final connected replay PASS: false detention, runner capture, runner escape,
  resistant response/custody, and the clean post-branch case each logged
  `Resolved=1`; no `[QA3 FAIL]` marker or Verse runtime error occurred in the
  final run.
- Shift 7 exactly-once accounting remained intact after the routing fix. The
  detected branch advanced to `Resolved=4, Correct=4, Missed=0`; the isolated
  missed branch logged `Resolved=2, Correct=1, Missed=1` after its own reset.
- One QA-only compile failed while formatting a `logic` value directly inside
  a diagnostic string. The fallback was explicit pass/fail log branches; the
  corrected QA build and the later shipping build both compiled successfully.
- Final shipping refresh PASS at `2026-07-30 01:20:33 UTC`: local validation,
  candidate validation, upload, cook/distribution, and activation completed on
  all platforms. No QA marker appeared after that refresh.
- Final production state: `DebugEnabled=false`,
  `AutomatedReplayEnabled=false`, UEFN `All Saved`, session connected, and test
  game stopped.

## Production closure validation - 2026-07-29 PDT

- Static/code review PASS: the live project, `work_live_patch`, and prior clean
  checkpoint were reconciled before editing. Existing queue, evidence,
  documents, outcomes, routing, emergency, response, and reset systems were
  preserved.
- Verse compilation PASS at `2026-07-30 05:05:12 UTC`; no package compile error
  remained. The earlier local variable-name ambiguity was corrected before the
  final build.
- Connected-session refresh PASS: module 42 completed local validation, upload,
  candidate resolution, distribution, client/server cooking, and all-platform
  activation at `05:07:37 UTC`.
- Connected runtime replay PASS: body/clear; body/bag/document/secondary;
  detention intake and duplicate guard; three Shift 5 power interactions plus
  one Fast Scanner purchase; detected and missed final-threat branches; claim
  release/reclaim; emergency timeout; false detention; runner capture; runner
  escape; resistant response/custody; and post-branch clean case.
- Final QA values included `ScannerUpgrade=1`, `Cash=850`, detected accounting
  `Resolved=4 Correct=4 Missed=0`, isolated missed accounting
  `Resolved=2 Correct=1 Missed=1`, and `Resolved=1` for every isolated QA3
  branch. No final `[QA3 FAIL]` marker or Verse runtime error appeared.
- Shipping-state PASS: `AutomatedReplayEnabled` was unchecked and saved, while
  `DebugEnabled` remained false. A new normal session was launched and did not
  emit a new automated-replay marker.
- Still manual/not tested: real two-client contention and disconnect recovery,
  normal-speed human 21-case pacing, representative multiplayer performance,
  and final human reference-angle traversal/capture.
