# Codex continuation prompt — AirportSecurity physical-route verification and finish pass

Continue the existing Fortnite UEFN project. This is an implementation and live-verification session, not a documentation-only session.

## Exact repository state to inspect first

- Repository: `adamthegoattt/AirportSecurity-UEFN`
- Local project: `AirportSecurity`
- Primary map: `/AirportSecurity/AirportSecurity`
- Primary actor: `TL_Controller`
- Branch used for the implementation: `codex/airport-reference-rebuild`
- Session baseline: `55eac73cc3d7e7b32abf7b7aebccc23b523b9ba9`
- Implementation head: `1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a`
- Implementation range: `55eac73cc3d7e7b32abf7b7aebccc23b523b9ba9..1264a01b00c4255b8f5978f9da2ece2b7ddcdc7a`
- Implementation commit:
  - `1264a01 feat: make airport checkpoint routes physical and walkable`

The current repository HEAD may be one later documentation/generator commit. At startup, run `git rev-parse HEAD`, `git status --short`, and `git log --oneline --decorate -10`. Treat the later continuation commit as documentation-only unless its diff proves otherwise. Do not reset or discard later user work.

Read these files before changing anything:

- `CODEX_CONTINUATION_CONTEXT.md`
- `docs/codex/validation_2026-07-30.json`
- `Content/terminal_lockdown_controller.verse`
- `Content/Python/build_airport_production_pass.py`
- `Tools/generate_codex_continuation_context.py`

The generated context contains the actual text diffs, binary sizes and SHA-256 values, commit metadata, validation results, and generation-time worktree state. Do not rely only on this prompt or on commit messages.

## Files changed in the implementation range

- `Content/AirportSecurity.umap`
- `Content/Python/build_airport_production_pass.py`
- `Content/terminal_lockdown_controller.verse`
- `Content/__ExternalActors__/AirportSecurity/0/NM/0KVSRW1HN8MD1NQQ3TDMX5.uasset`
- `Content/__ExternalActors__/AirportSecurity/6/8T/DSHQO1AUSMVF7SCPI69FHT.uasset`
- `Content/__ExternalActors__/AirportSecurity/9/VT/5P4UM2ZRJGXDA994P4KKD1.uasset`
- `Content/__ExternalActors__/AirportSecurity/E/XP/4BCC1KVA52WV26Q6Y051BR.uasset`

The implementation commit contains 417 insertions and 121 deletions across the Verse controller, production builder, map, and four external actors.

## What is now implemented

### Production startup and controller lifecycle

- Normal production no longer starts a shift when a player merely joins.
- `AutoStartEnabled` is an editable, disabled-by-default local-test convenience.
- The normal run waits at `SHIFT 0/7` until an officer uses the physical START SHIFT control.
- The disabled QA replay now starts through `OnStartButton` instead of relying on production autostart.
- Shipping values were visually verified in the saved `TL_Controller` details panel:
  - `AutoStartEnabled=false`
  - `AutomatedReplayEnabled=false`
  - `DebugEnabled=false`

### World-derived physical routes

- Production movement no longer depends only on the old absolute world-coordinate literals.
- `CaptureRouteMarkers` captures queue and power anchors from already-wired actors.
- Route helpers derive scanner entry/center/exit, bag entry/X-ray/exit, document, decision, secondary, departure, detention, response, runner, and power positions from stable world transforms plus local offsets.
- Proximity validation for custody, secondary, and power repair now uses the actual device transforms.
- The existing checked movement helper still guards run/case identity, checks `MoveTo` results, retries once, and uses a bounded teleport fallback.

### Queue, scanner, bag, secondary, detention, and response behavior

- The active passenger stages from the queue and approaches the scanner entry through guarded physical moves.
- A body scan now moves the passenger from scanner entry to scanner center, displays staged amber sweep progress, then moves the passenger to scanner exit before committing `BodyChecked`.
- Later shifts route the passenger onward to baggage, documents, decision, secondary, detention, response, departure, or the cell through named position helpers.
- Linked bags move through entry, X-ray, and exit positions derived from the physical bag station.
- Secondary now routes both the passenger and the linked bag to a distinct station.
- Secondary completion waits for both `SecondaryPassengerReady` and `SecondaryBagReady` in bag-enabled shifts.
- Reset, emergency, and results paths clear the new secondary-bag state and hide/reset active bags.
- Detention, response, runner, and boss routes continue using case/run generation checks and checked movement.

### Physical power repair

- The outage repair is still one wired interaction device, but it no longer represents one remote instant restore.
- The physical control relocates between three distinct power-room stations: auxiliary/home, east circuit, and west/master circuit.
- Each step uses proximity checks against the control's actual current transform.
- Successful restoration returns the control to its home position and restores normal terminal state.

### Scanner floor and builder hardening

- `make_decorative_nonblocking` removes pawn/physics collision from thin decorative scanner pads.
- North and south scanner pad top surfaces are exactly flush with the terminal floor top at `88.0 cm`.
- The scanner interaction device moved outside the walk-through aperture to `(1120, -1850, 180)`.
- The scanner aperture remains approximately `590 cm` clear between the physical sides.
- The builder reports scanner-pad adjustment data and whether the scan button was relocated.
- The builder remained idempotent on the second final run: 0 created, 91 updated, 0 stale deleted, 356 actors before and after, and no duplicate `TL_` labels.

## Important systems already present before this range

Do not rebuild these from scratch. Inspect and preserve them while fixing any observed defects:

- Seven-shift production state machine and case schedules.
- Exactly-once final-case accounting and missed-threat grade protection.
- Claim legality ordering, owner-loss release, and stale task guards.
- Persistent player HUD with shift/case/clock/cash/integrity/risk/evidence/power/alert state.
- Player-facing document UI.
- Neutral body, bag, document, and secondary evidence rather than explicit correct-answer labels.
- Physical green CLEAR, amber SECONDARY, and red DETAIN presentations.
- Queue characters, active passenger, conveyor props, power room, restricted corridor, office, detention cell, windows, and aircraft presentation.
- Results, replay reset, emergency generation, response phases, and cleanup logic.

## Verified results from 2026-07-30

### PASS

- UEFN 5.8 Verse compile: final editor tooltip was `Built successfully.`; the detailed log also recorded `VerseBuild: SUCCESS`.
- Live map validation: 356 valid actors, 0 invalid, 0 not validated, 0 errors, 0 warnings, no disallowed fallbacks.
- Builder idempotency: 0 created, 91 updated, 0 stale deleted, actor count stayed 356, no duplicate labels, map saved.
- Scanner structural audit: floor top 88.0 cm, both pad tops 88.0 cm, decorative pad static meshes use `NoCollision`, and the scan button is outside the aperture.
- Intentional production startup: a production-flags-disabled Fortnite session stayed at `SHIFT 0/7 | CASE 0/3 | CLOCK 0s`, `POWER ONLINE | ALERT NORMAL`, waiting for the staffing-desk control. No stale QA replay started.

### PARTIAL

- A temporary disabled-by-default QA probe invoked the real production handlers. Fortnite displayed `BODY SCANNER ACTIVE`, and the Verse log recorded `[QA] Shift 1 body/clear path complete` at 2026-07-30 07:45:18 UTC.
- No Verse runtime error appeared during the observed probe.
- This proves the production handler chain reached and completed the first scan/clear case, but it is not a substitute for manual traversal.

### UNVERIFIED — do not claim these passed

- Walk through the scanner in both directions without jumping.
- Sprint through the scanner in both directions.
- Crouch-walk and slightly off-center approaches.
- A persisted player-eye screenshot of the moving passenger centered in the aperture.
- A fully manually driven body/bag/document/CLEAR case.
- Manual SECONDARY passenger-and-bag routing and evidence reveal.
- Manual correct detention, false detention, intake, and cell closure.
- Manual three-step power repair and stale-timeout recovery.
- Manual results/replay cleanup.
- Genuine two-client claim contention, disconnect recovery, and join-in-progress HUD.

The prior session could send discrete key presses but could not sustain held Fortnite movement, so it did not fake these results. Use a human-driven client or an input-capable harness and record exact outcomes.

## Current editor and session state

- UEFN map: `/AirportSecurity/AirportSecurity`
- Map saved; `All Saved` was visible.
- UEFN revision-control panel showed 0 edits and 0 pending push before the final session ended.
- The production flag state was pushed to the connected test session.
- The session then disconnected during/after the final refresh; UEFN ended at `Session Disconnected`.
- A final post-commit `Launch Session` attempt failed because UEFN reported that its services were currently unavailable.
- Verse compiled successfully after that disconnect.
- Repeated Epic Connect messaging authentication warnings were present but did not block compile, validation, the builder, or the observed runtime path.
- No relevant Verse or validation errors remain recorded.

Launch a fresh session after UEFN services recover, then reinspect all three production flags before manual testing.

## Current visible map state

The map is a bright, large modern terminal with a high white structural ceiling, full-height blue-daylight glazing, exterior aircraft, dark checkpoint equipment, queue seating/barriers, baggage conveyors, a staffed decision area, and darker secure support spaces. The production pass already includes recognizable scanner/conveyor assemblies, power cabinets, and a furnished detention cell rather than only anonymous placeholder blocks.

Relative to the reference images, the broad composition and readable gameplay zones are present. Remaining visual gaps include material richness, prop density, passenger variety, more believable scanner animation/VFX, clearer close-range evidence monitors, more detailed office/corridor furnishings, stronger emergency lighting contrast, and higher-quality player-eye screenshots of the finished loop.

## Available repository screenshots

- `docs/codex/proof-2026-07-29/10_native_scanner_and_conveyors.png`
- `docs/codex/proof-2026-07-29/11_power_cabinets.png`
- `docs/codex/proof-2026-07-29/12_furnished_detention_cell.png`

No new screenshot file was committed in the implementation range. Capture new player-eye-level screenshots during the next live verification; do not present the editor viewport as proof of walkability.

## Highest-impact next objectives

Work in this order and continue through fixes, validation, and commits:

1. Launch a fresh production-flags-disabled Fortnite session and manually traverse the scanner: walk, reverse walk, sprint both directions, crouch, and off-center, all without jumping. Record any snag precisely and fix geometry/collision immediately if found.
2. Manually drive one complete body/bag/document/CLEAR case. Confirm the passenger physically enters and exits the scanner, the linked bag moves, neutral evidence appears, the passenger reaches the decision station, and departure completes.
3. Manually run SECONDARY. Confirm the passenger and correct linked bag arrive at the distinct room before the check enables, additional evidence appears, and the passenger returns to decision.
4. Manually run correct detention and false detention. Verify proximity, exactly-once intake/reward, cell occupancy/closure, and physical false-detention release.
5. Trigger the power emergency. Walk to all three physical repair positions, verify offline scanner behavior and visible terminal change, restore power, and prove a stale timeout cannot penalize after restoration.
6. Complete results and replay, checking passengers, bags, HUD, lights, audio, doors, controls, and claims for clean reset.
7. Attempt a genuine two-client claim/disconnect test if the environment supports it. Keep it `UNVERIFIED` otherwise.
8. Capture player-eye screenshots of the normal checkpoint, scanner/bag flow, decision desk, power outage, and detention state.
9. Fix every defect actually observed, rerun Verse compile, builder idempotency, project validation, save, push, and commit substantive production changes.

Do not spend the session expanding `RunAutomatedReplay`, writing more reports, or replacing working systems before these manual gates are completed.

## Likely files and actor families for the next pass

Primary source files:

- `Content/terminal_lockdown_controller.verse`
- `Content/Python/build_airport_production_pass.py`
- `Content/AirportSecurity.umap`
- External actors changed by any `TL_Controller` editable update or production actor transform/collision fix

Likely actor families:

- `TL_Controller`
- `TL_ART_ScannerNorthPad`, `TL_ART_ScannerSouthPad`, `TL_ART_TerminalFloor`
- `TL_PROD_NativeScanner`, `TL_PROD_ScannerSideLeft`, `TL_PROD_ScannerSideRight`, `TL_PROD_ScannerCrown`
- `TL_BTN_Scan`, `TL_BTN_Bag`, `TL_BTN_Doc`, decision controls, custody control, and power control
- Queue characters and `TL_PASSENGER_Active`
- Bag props and `TL_PROD_BagConveyorIn` / `TL_PROD_BagConveyorOut`
- Secondary, detention, response, runner, and power-room anchors derived by the route helpers
- Emergency lights/audio and evidence boards/UI only where live testing exposes a real issue

## Completion rules for the next session

- Inspect the actual new Git range before editing.
- Preserve all user work and avoid destructive Git operations.
- Do not repeat the completed route refactor or recreate the existing production art pass without evidence of a defect.
- Production work must remain larger than documentation/test-harness work.
- Do not claim manual tests that were not personally observed.
- End with shipping flags false, map saved, Verse compiled, validation clean or an exact blocker recorded, and logical commits.
- Regenerate `docs/codex/validation_*.json`, `CODEX_CONTINUATION_CONTEXT.md`, and this prompt only after substantive production work and runtime validation.
- The next session must produce implementation when live testing finds defects; it must not stop at inspection or documentation.
