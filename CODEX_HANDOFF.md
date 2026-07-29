# AirportSecurity UEFN handoff

## Checkpoint

- Name: **Terminal Lockdown - Validated Reference Pass**
- Date: **2026-07-28 PDT**
- Project: `AirportSecurity`
- Map: `/AirportSecurity/AirportSecurity`
- Intended Git repository: `AirportSecurity-UEFN` (private)

## Current game state

- The validated pre-existing graybox was preserved and expanded into the
  Terminal Lockdown airport-security experience.
- UEFN and the connected Fortnite client were left running and responsive.
- The last verified editor state was `Game in Progress`, `All Saved`, and
  `0 Edits - 0 Pending Push`, with `TL_Controller` selected.
- The production controller has `DebugEnabled=false` and
  `AutomatedReplayEnabled=false`.
- Final level inventory: 155 actors total, including exactly 143 uniquely named
  `TL_` production actors and no proof/trial leftovers.

## Systems implemented

- Reference-zoned terminal shell, briefing, queues, checkpoint, bag area,
  document desk, decision desk, secondary room, detention cell, restricted
  corridor, power room, security office/response supply, waiting area,
  runway-window aircraft silhouette, upgrade kiosk, and exit.
- Physical passenger queue and active-passenger movement through scanner,
  departure, response, detention intake, and jail-cell destinations.
- Active-case-linked luggage, document identity/destination/evidence, world
  boards, and HUD objectives.
- Body, bag, and document inspections with `CLEAR`, `SECONDARY`, and `DETAIN`.
- Compliant detainee, runner, and resistant-suspect branches; custody intake
  awards exactly once.
- Seven shifts with deterministic templates, staged evidence unlocks, three
  cases per shift, upgrade breaks, team cash/integrity/risk, and grading.
- Emergencies for Shifts 4-6, including the complete Shift 5 power-outage and
  scanner-disable/restore contract.
- Detected and missed final-threat branches, four-stage response, victory,
  results, defeat, and clean replay reset.
- Player case claiming, stale case/run/emergency guards, duplicate-resolution
  protection, autostart fallback, and owner-disconnect recovery.

## Files changed or added

- `AirportSecurity.uefnproject` - live project configuration, including Python
  enablement used by the reviewed editor bridge.
- `Content/AirportSecurity.umap` - active airport level.
- `Content/__ExternalActors__/AirportSecurity/` and
  `Content/__ExternalObjects__/AirportSecurity/` - saved world-partition actor
  and object data for the level.
- `Content/terminal_lockdown_controller.verse` - authoritative gameplay state
  machine and device coordination.
- `Content/terminal_lockdown_types.verse` - game phase, decision, and boss
  branch types.
- `Content/Python/build_terminal_lockdown.py` - idempotent 143-actor builder and
  exact placement ledger output.
- `Content/Python/init_unreal.py`, `uefn_listener.py`, and listener license -
  reviewed local editor automation bridge.
- `Content/Python/probe_airportsecurity.py` and
  `prove_airportsecurity_primitive.py` - retained historical audit/proof tools;
  the rejected proof actors themselves were removed from the level.
- `docs/codex/` - architecture, execution record, asset ledger, tests,
  validation log, worklog, rebuild instructions, and final report.
- `.gitignore` and this `CODEX_HANDOFF.md` - Git/bootstrap handoff files.

## Verse entry points

- `terminal_lockdown_controller.OnBegin` - subscribes all devices/player
  events, configures the physical presentation, and starts the guarded fallback.
- `OnStartButton` and `AutoStartWaitingRun` - initialize a run exactly once.
- `PrepareNextCase` and `StagePassenger` - select the shift template, reset
  evidence, update boards, and move the active passenger to screening.
- `OnScanButton`, `OnBagButton`, and `OnDocumentButton` - collect evidence.
- `OnClearButton`, `OnSecondaryButton`, `OnDetainButton`, and
  `ResolveDecision` - enforce prerequisites and commit one decision.
- `BeginDetention`, `CaptureRunner`, `OnCustodyButton`, and passenger movement
  coroutines - complete arrest and jail intake.
- `FinishCase`, `BeginUpgradeBreak`, and `OnUpgradeButton` - advance cases and
  the seven-shift progression.
- `BeginEmergency`, `EmergencyTimeout`, `OnPowerButton`, and
  `OnResponseButton` - emergency and response lifecycle.
- `BeginBoss`, `FinishVictory`, `FinishDefeat`, and `ResetToWaiting` - final
  threat, results, and replay.
- `RunAutomatedReplay` - development-only production-handler replay; keep its
  editable flag false outside an intentional local QA run.

## Devices and actors added

- 118 `/Game/Valkyrie/GridPlane.GridPlane_C` architecture/physical-prop actors.
- 12 Buttons: `TL_BTN_Start`, `TL_BTN_Scan`, `TL_BTN_Bag`,
  `TL_BTN_Documents`, `TL_BTN_Clear`, `TL_BTN_Secondary`, `TL_BTN_Detain`,
  `TL_BTN_Response`, `TL_BTN_Upgrade`, `TL_BTN_Debug`, `TL_BTN_Custody`, and
  `TL_BTN_Power`.
- 7 Billboards: checkpoint, case, bag, document, power, custody, and emergency.
- 4 Character devices: three queued passengers and one active passenger.
- 1 HUD Message device: `TL_HUD_Status`.
- 1 Verse device: `TL_Controller`.

## Validation and runtime results

- Complete build:
  `created=63|updated=80|deleted_proofs=4|expected=143|actors_total=155|level_saved=True|packages_saved=True`.
- Idempotency rerun:
  `created=0|updated=143|deleted_proofs=0|expected=143|actors_total=155`.
- Final reflection audit: 143 `TL_` actors, no duplicate `TL_` labels, no
  proof/trial labels; class counts 118 GridPlane, 12 Button, 7 Billboard,
  4 Character, 1 HUD Message, and 1 Verse device.
- Verse build succeeded. Final hot reload reported `[Push Verse Changes]
  operation successful` and `Successfully activated content on all platforms`.
- Live automated replay passed Shift 1 body/clear, Shift 3
  body/bag/document/secondary, detention and duplicate custody guard, Shift 5
  scanner-offline/power restore, Shift 7 detected boss victory, and
  results-to-waiting reset.
- After returning the QA flag to false, the final reload emitted no new QA
  marker, Verse error, validation failure, or build failure.

## Known issues

- Runtime validation used one connected Fortnite client. Simultaneous
  two-player case contention and live leave/rejoin recovery were not exercised.
- The replay covered major unlock and failure boundaries rather than a
  real-time 21-routine-case pacing run.
- Representative multiplayer performance has not been measured.
- The terminal is a validated production graybox/silhouette pass, not a final
  bespoke art, audio, or VFX pass.
- Lore offline/local status previously reported an inability to deserialize
  revision states. No destructive Lore repair was attempted; `.lore/` is local
  revision-control state and is intentionally excluded from Git.

## Unfinished tasks

- Two-client contention and disconnect/rejoin runtime QA.
- Full-duration seven-shift pacing and balance pass across all 21 routine cases.
- Performance capture with representative player counts.
- Reference-quality art replacement, lighting, audio, VFX, animation, and UX
  polish under the same asset/placement validation contract.
- Optional persistence, progression tuning, accessibility, and publish/release
  preparation. Publishing was not performed.

## Exact recommended next steps

1. Pull this checkpoint and open `AirportSecurity.uefnproject` in the matching
   UEFN/Fortnite version (compatibility 41.20).
2. Confirm `TL_Controller` still has all 12 Button, 7 Billboard, 4 Character,
   and 1 HUD editable references assigned; keep debug and automated replay off.
3. Launch two Fortnite clients. Have both interact with one active case, then
   disconnect the claimant during `Inspecting`; verify the second client can
   reclaim and finish without duplicate progress.
4. Run all three cases in Shifts 1-7 without debug skips. Record decision
   accuracy, cash, integrity, risk, emergency timings, and total session length.
5. Exercise the missed final-threat branch and the emergency-timeout failure
   path, which compile but were not the branches selected by the live replay.
6. Capture frame time, memory, and network behavior with 4, 8, and 16 players.
7. Before replacing any graybox element, validate the exact asset path, actor
   class, and placement method with one disposable proof; save, validate, cook,
   and session-check it before production use.
8. Commit each accepted art/system milestone separately. Do not modify or
   remove the current checkpoint until the replacement path passes equivalent
   runtime evidence.
