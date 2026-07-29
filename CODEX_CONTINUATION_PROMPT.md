# AIRPORTSECURITY / TERMINAL LOCKDOWN — ROLLING AUTONOMOUS CONTINUATION PROMPT

Prompt version: **1.0**
Generated: **2026-07-28 PDT**
Canonical checkpoint: **Terminal Lockdown - Validated Reference Pass**
Git checkpoint: **5ece9583b1b352f12ff5534bbba70ffa327c45e1** on `main`
Target project: **AirportSecurity**
Target experience: **Terminal Lockdown**

---

# 0. COMPLETENESS GATE — READ BEFORE DOING ANYTHING

This is a rolling execution prompt for continuing the existing AirportSecurity
UEFN project. It is not a request to make a new design, a new project, or a
detached prototype.

Before performing any project mutation, read this file from the first line to
the final line and confirm that the exact marker below is present at the end:

`END_OF_AIRPORTSECURITY_CONTINUATION_PROMPT_V1`

If the marker is missing, do not execute this prompt. Finish regenerating the
prompt from the current project, verify it, and only then begin implementation.
Never execute a partially written, truncated, or unverified continuation prompt.

Once the marker is present, use this prompt as a complete execution brief. Work
from the actual live project state, not from assumptions. At the end of every
validated development checkpoint, regenerate this same file in full from the
new project state before using the next version. Do not begin work from the next
version until its own end marker and required sections have been verified.

The rolling sequence is:

1. Read the complete current prompt.
2. Audit the live project and distinguish current evidence from stale notes.
3. Select the highest-value unfinished milestone that can be completed safely.
4. Implement it in the canonical live project.
5. Compile, validate, launch, runtime-test, and fix it.
6. Update the handoff, architecture, ledger, test matrix, validation log, final
   report, and worklog with factual evidence.
7. Create a safe local Git checkpoint when the milestone is genuinely green.
8. Regenerate this prompt completely from the new checkpoint.
9. Verify the regenerated file and its end marker.
10. Continue with the next highest-value milestone unless blocked by a real
    user-only action, unavailable second client, external authentication, or a
    safety boundary.

Do not recursively chain from unfinished prose. Do not say “continued” while
only planning. Each cycle must leave the game more complete or more reliably
validated than the cycle before it.

---

# 1. CANONICAL SOURCE OF TRUTH

The live UEFN project is:

`C:\Users\chris\Documents\Fortnite Projects\AirportSecurity`

The active project files are:

- `AirportSecurity.uefnproject`
- `AirportSecurity.uplugin`
- `Content/AirportSecurity.umap`
- `Content/__ExternalActors__/AirportSecurity/`
- `Content/__ExternalObjects__/AirportSecurity/`
- `Content/terminal_lockdown_controller.verse`
- `Content/terminal_lockdown_types.verse`
- `Content/Python/build_terminal_lockdown.py`
- `Content/Python/init_unreal.py`
- `Content/Python/uefn_listener.py`
- `docs/codex/`
- `CODEX_HANDOFF.md`

The live project is now also a Git repository with remote:

`https://github.com/adamthegoattt/AirportSecurity-UEFN.git`

The workspace mirror is:

`C:\Users\chris\Documents\secure the airport fortnite\AirportSecurityBuild`

At prompt generation time, the live controller, type file, and terminal builder
matched the workspace copies by SHA-256. This does not imply future automatic
synchronization. Before editing, verify which copy UEFN compiles. The live
`Fortnite Projects\AirportSecurity` folder is authoritative for UEFN, map actor
data, external actors, saved device references, compile, validation, and live
session behavior. Keep the workspace mirror synchronized only deliberately and
never assume that changing it updates the live project.

Truth precedence for this continuation:

1. Current live UEFN/Fortnite runtime behavior and current logs.
2. Saved live map, external actors/objects, Verse, and builder scripts.
3. `CODEX_HANDOFF.md` at the current Git checkpoint.
4. Current Git diff and file timestamps.
5. Updated validation/test/asset documentation that cites concrete evidence.
6. Older planning documents and historical notes.

Several `docs/codex` files at checkpoint `5ece958` still contain pre-build
“pending” tables. They are historical and contradict the later validated
handoff. Do not regress the project to match those stale tables. Reconcile them
to the current state while preserving useful historical facts.

Never edit Unreal binary assets directly outside UEFN-supported operations.
Never delete external actors to hide an error. Never rebuild from scratch.

---

# 2. REMEMBER THE ORIGINAL GAME

The initial game is an original cooperative Fortnite airport-security game
called **Terminal Lockdown**, built in the existing **AirportSecurity** UEFN
project.

The fantasy is not a menu simulator. Players are terminal safety officers in a
bright stylized airport. They process physical travelers, inspect linked bags
and fictional documents, make fair evidence-based decisions, detain genuine
threats, manage escalating shifts, and respond when the terminal changes from
normal screening into a lockdown or emergency-response space.

The intended normal player loop is:

`Waiting area -> passenger queue -> body scanner -> linked bag inspection ->
document/identity check -> Clear / Secondary / Detain -> departures or custody`

The intended detention loop is:

`Correct Detain -> compliant, runner, or resistant branch -> secure -> short
escort or controlled movement -> detention intake -> jail -> exactly-once reward`

The intended run loop is:

`Briefing -> seven shifts -> three cases per shift -> staged mechanic unlocks ->
upgrade breaks -> emergencies in later shifts -> final disguised threat ->
detected or missed branch -> results -> clean replay`

The airport must remain readable as an airport without project documentation.
It should contain these spatial roles, based on the supplied external reference
images but expressed as an original Fortnite environment:

- Bright main terminal hall with high ceiling and structural beams.
- Tall blue-tinted runway windows and an airport/aircraft silhouette outside.
- Waiting seats with open sightlines to the checkpoint.
- Central checkpoint sign and obvious body-scanner lane.
- Nearby bag-inspection surface and document desk.
- Large physical Clear, Secondary, and Detain inputs.
- Detention intake and visible secure cell within a short route.
- Small darker security office and response-supply point.
- Restricted corridor leading to a compact industrial power room.
- Departure/escape route visible beyond the checkpoint.
- Service/response space that supports emergencies in the same terminal.

The eleven original reference roles are:

1. Security office and response/ammunition supply.
2. Power room and online/offline utility console.
3. Restricted corridor.
4. Runway window and aircraft silhouette.
5. Wide main terminal.
6. Scanner and active passenger.
7. Checkpoint and linked bag area.
8. Physical decision buttons.
9. Detention cell.
10. Response refill station.
11. Wide waiting area.

The screenshots are external design references only. Never import them into the
project. Do not copy their platform UI, store offers, logos, exact signs, fonts,
faces, character designs, or protected art. Keep the environment fictional,
original, family-friendly, and clearly Fortnite-native.

Evidence must be fair. Threat truth must never be inferred from a passenger’s
skin tone, gender, clothing, fictional nationality, or appearance. Every
non-clean case needs observable body, bag, document, behavior, or intelligence
evidence. Secondary must be a useful uncertainty-management action rather than
a disguised wrong answer.

Combat and custody remain stylized: use terms such as respond, intercept,
incapacitate, secure, detain, and jail intake. No gore or execution framing.

Do not drift into unrelated features while the main loop or validation is
incomplete. Do not prioritize publishing, monetization, promotional art, a
second terminal, large exterior scenery, complex cinematics, huge inventories,
or dozens of enemy archetypes ahead of the core airport loop.

---

# 3. VALIDATED CHECKPOINT TO PRESERVE

Checkpoint name: **Terminal Lockdown - Validated Reference Pass**
Checkpoint date: **2026-07-28 PDT**

At this checkpoint:

- The active map is `/AirportSecurity/AirportSecurity`.
- UEFN compatibility is `41.20`.
- The project has a safe local Git checkpoint at commit `5ece9583...`.
- UEFN and a connected Fortnite client were left running and responsive.
- The last observed editor state was `Game in Progress`, `All Saved`, and
  `0 Edits - 0 Pending Push`, with `TL_Controller` selected.
- `TL_Controller.DebugEnabled=false`.
- `TL_Controller.AutomatedReplayEnabled=false`.
- The saved level contained 155 actors total.
- Exactly 143 uniquely named production actors use the `TL_` prefix.
- No `TL_PROOF_` or trial leftovers remained.
- Actor counts were 118 GridPlane geometry/prop actors, 12 Buttons, 7
  Billboards, 4 Character devices, 1 HUD Message device, and 1 Verse device.

Validated build evidence:

`created=63|updated=80|deleted_proofs=4|expected=143|actors_total=155|level_saved=True|packages_saved=True`

Validated idempotency rerun:

`created=0|updated=143|deleted_proofs=0|expected=143|actors_total=155`

Verse build and activation evidence:

- `[Push Verse Changes] operation successful`
- `Successfully activated content on all platforms`
- No new relevant Verse compile, validation, or runtime error was reported
  after returning QA flags to false.

The automated runtime replay exercised production handlers for:

- Shift 1 body scan and Clear.
- Shift 3 body, bag, document, and Secondary.
- Correct detention and duplicate custody-intake rejection.
- Shift 5 scanner-offline power outage and utility restore.
- Shift 7 detected-boss victory.
- Results-to-waiting clean reset.

Preserve this evidence and do not claim broader runtime coverage than it proves.
The replay used one connected Fortnite client. It did not prove simultaneous
two-player contention, real disconnect/rejoin recovery, a real-time full
21-case pacing run, representative performance, or final-art quality.

---

# 4. AUDITED IMPLEMENTATION FACTS

## 4.1 Authoritative Verse controller

`Content/terminal_lockdown_controller.verse` is the authoritative high-level
orchestrator. It is approximately 1,262 physical lines at this checkpoint. Do
not rewrite it wholesale for style. Extend or refactor only when doing so
directly enables a validated feature, removes a demonstrated state bug, or
creates a materially stronger test seam.

Editable dependencies:

- 12 `button_device` references: Start, Scan, Bag, Documents, Clear,
  Secondary, Detain, Response, Upgrade, Debug, Custody, Power.
- 1 `hud_message_device` reference.
- 4 `character_device` references: three queue stand-ins and one active
  passenger.
- 7 `billboard_device` references: checkpoint, case, bag, document, power,
  custody, emergency.
- Cases per shift, emergency timeout, debug flag, and automated replay flag.

The controller owns:

- Phase.
- Run generation and emergency generation.
- Shift and case progression.
- Current case ID and deterministic template.
- Integrity, risk, cash, correctness, false detentions, and missed threats.
- Evidence flags.
- Resolution and custody exactly-once guards.
- Power state.
- Custody mode.
- Current claim owner.

Important entry points and contracts:

- `OnBegin`: subscribes device/player events, configures presentation, starts
  autostart, and optionally runs the development replay.
- `OnStartButton` / `AutoStartWaitingRun`: initialize one guarded run.
- `PrepareNextCase` / `StagePassenger`: reset evidence, choose a template,
  update boards, show/move the active passenger, and guard stale callbacks by
  case/run generation.
- `OnScanButton`, `OnBagButton`, `OnDocumentButton`: claim the case and collect
  evidence once.
- `OnClearButton`, `OnSecondaryButton`, `OnDetainButton`, `ResolveDecision`:
  enforce phase/evidence/claim prerequisites and commit one decision.
- `BeginDetention`, `CaptureRunner`, `OnCustodyButton`, movement coroutines:
  route compliant, runner, and resistant cases and guard jail intake.
- `FinishCase`, `BeginUpgradeBreak`, `OnUpgradeButton`: advance three cases per
  shift through seven shifts.
- `BeginEmergency`, `EmergencyTimeout`, `OnPowerButton`, `OnResponseButton`:
  run the emergency lifecycle and cancel stale timeouts.
- `BeginBoss`, `FinishVictory`, `FinishDefeat`, `ResetToWaiting`: final threat,
  results, defeat, and clean replay.
- `RunAutomatedReplay`: development-only production-handler regression path.
  Keep the editable flag false except during an intentional local QA run, and
  return it to false before a checkpoint.

## 4.2 Current phases and decisions

`Content/terminal_lockdown_types.verse` defines:

- Phases: Waiting, Briefing, CaseReady, Inspecting, AwaitingDecision,
  Resolving, Runner, HostileResponse, Custody, Emergency, UpgradeBreak,
  BossJammer, BossBreach, BossVulnerable, BossSecure, Results.
- Decisions: Clear, Secondary, Detain.
- Boss branches: None, Detected, Missed.

## 4.3 Current case catalog

The deterministic template catalog contains 12 cases:

1. Nova Harbor commuter — Clear.
2. Restricted-item carrier — Detain; body evidence.
3. Expired credential hold — Secondary; document evidence.
4. Jammer smuggler — Detain; bag/document evidence.
5. Portrait mismatch alert — Detain; document evidence.
6. Nervous but valid traveler — Clear.
7. Drone battery policy case — Secondary; bag evidence.
8. Armed infiltrator — Detain; runner branch and body/bag evidence.
9. Elite access-card infiltrator — Detain; resistant branch and body/document
   evidence.
10. Closed-gate courier — Secondary; document evidence.
11. Final-boarding VIP — Clear.
12. The Breacher disguise — final Detain target with bag/document evidence.

Shift schedule is three cases per shift. Shift 1 teaches body screening, Shift 2
adds baggage, Shift 3 adds identity documents, Shift 4 is rush hour, Shift 5 is
system fault/power outage, Shift 6 is lockdown, and Shift 7 is final boarding.

## 4.4 Current physical implementation boundary

The current passenger implementation is a proven conservative fallback using
four pre-placed `character_device` actors, not a fully autonomous crowd or NPC
Spawner/Character Definition system. Three queue characters remain as visible
queue stand-ins. One active character is hidden, repositioned, shown, and moved
through queue, scan, departure, response, intake, and cell destinations with
generation guards.

The current luggage is a linked, project-owned physical GridPlane parcel on the
bag surface plus bag evidence on a dedicated world board. The current document
presentation is a world-space Billboard with fictional name, destination, and
document result. These are functioning production fallbacks, not final X-ray or
portrait UI.

The current normal decision path uses three physical Button devices near the
decision desk. Detention uses an intake Button, world status, and controlled
active-passenger movement. Resistant response uses a response Button and
physical movement rather than a fully proven combat AI encounter.

The Shift 5 power outage is the strongest complete emergency contract: scanner
is disabled, the checkpoint reports offline, the player travels to the utility
console, power is restored, scanner availability returns, rewards apply once,
and the run advances. Shifts 4 and 6 have functional response/emergency state
paths but are less physically developed than the power event.

## 4.5 Idempotent builder

`Content/Python/build_terminal_lockdown.py` is the current production builder.
It:

- Refuses to run outside a world whose path contains `AirportSecurity`.
- Finds actors by stable `TL_` labels.
- Duplicates the already validated `GridPlane1` actor for geometry instead of
  introducing restricted hard references.
- Reuses and updates correctly typed actors.
- Removes only actors with the explicit `TL_PROOF_` prefix.
- Places native Button, HUD Message, Character, Billboard, and compiled Verse
  device classes from exact paths.
- Relocates the two supplied spawn pads to the safe entrance.
- Verifies every expected label exists exactly once.
- Saves the current level and dirty packages.
- Prints `TL_BUILD_OK` and one `TL_LEDGER` record per expected actor.

Do not change its idempotency or safety boundary casually. Any builder extension
must use stable project-owned labels, search before creating, preserve unknown
actors, verify class compatibility, save explicitly, and prove a second run
creates zero duplicates.

## 4.6 Current terminal zones

The builder contains named geometry for:

- Approach plaza and terminal floors.
- Main shell walls, roof ribs, cross beams, entry canopy/sign.
- Briefing desk and command header.
- Lane dividers, queue rails, bollards, two scanner silhouettes.
- South/north bag belts, document desk, decision desk/header.
- Secondary-screening room.
- Response/security room and consoles.
- Upgrade kiosk and departure gate.
- Waiting carpet and three seat rows.
- Window wall, runway apron, and aircraft silhouette.
- Restricted corridor.
- Power room, console, and cabinets.
- Security office, desk, monitors, supply table/crate.
- Detention floor, walls, bars, and cell.
- Active and queued luggage parcels.

These are production graybox/silhouette actors built from validated GridPlane
placements. Do not remove them simply to replace them with prettier assets. A
replacement must pass the same or stronger reference, assignment, placement,
save, validation, session, collision, and multiplayer-visibility evidence first.

---

# 5. NON-NEGOTIABLE ASSET AND PLACEMENT CONTRACT

For every production dependency—asset, actor class, device class, NPC
definition, material, prop, sound, VFX, camera, animation, or runtime spawn—
prove the exact intended method before scaling it.

Required proof chain:

1. Exact identity and path.
2. Class/type.
3. Source/ownership: project-owned, Fortnite-provided, plugin, Fab-referenced,
   imported, read-only, or unknown.
4. Reference validation.
5. Property-assignment validation when applicable.
6. Exact placement or spawn method.
7. Evidence that the method supports this class in this project/version.
8. Minimal isolated placement/assignment.
9. Save result.
10. Reopen or reflection re-query when practical.
11. UEFN validation/cook result.
12. Launch Session result.
13. Runtime behavior and actual spawn result when relevant.
14. Multiplayer visibility/replication for player-visible objects.
15. Collision/pathing behavior when relevant.
16. Named safe fallback.

Only after this chain may a dependency be marked
`APPROVED_FOR_PRODUCTION` in `docs/codex/ASSET_PLACEMENT_LEDGER.md`.

A path resolving is not proof. `load_asset` succeeding is not proof. A class
appearing in a digest is not proof. A Content Browser thumbnail is not proof.
Never use path overrides, same-name shadow assets, redirector tricks, config
remaps, copied hidden paths, or binary rewriting to bypass validation.

All new project-owned actors require unique AirportSecurity/TerminalLockdown
names. Builders must remain idempotent. Scale placements in small batches and
validate after each meaningful batch.

The asset ledger is currently stale and must be reconciled carefully. Do not
blindly promote old CANDIDATE entries. Use the exact builder output, saved actor
inventory, compile/validation evidence, and live-session result to update each
category. Preserve an honest distinction between session-proven fallback
geometry/devices and unproven proposed art replacements.

---

# 6. ENGINEERING AND STATE SAFETY CONTRACT

Keep one authoritative state machine. The existing controller remains the owner
of run, shift, phase, case truth, team values, emergencies, boss branch, and
results unless a focused manager is actually wired into the live path and its
ownership is explicit.

Preserve generation-token cancellation. Every delayed task or movement callback
must prove that its expected run, case, emergency, passenger, or claim is still
current before mutating state.

Preserve exactly-once guards for:

- Passenger decisions.
- Custody/jail intake.
- Runner escape/capture consequences.
- Emergency success/failure.
- Shift completion.
- Upgrade purchase.
- Boss result.
- Run result and any later persistent reward.

Claims must identify the current passenger/case, lane, owner, and generation.
Release safely on resolution, reset, emergency interruption, owner departure,
timeout, or new run. Two players must never resolve the same passenger twice.

Do not add unused manager files or abstract systems that are not wired into the
active map. Prefer a small validated vertical slice over broad unplaced code.

Do not request or access webcam, microphone, camera roll, or personal sensors.
Gameplay camera devices are allowed only after exact lifecycle testing. Decline
unrelated operating-system camera prompts.

Do not publish the island, purchase/import paid content, restart/shut down the
computer, sign out, or close UEFN/Fortnite at the end. Leave the editor or a
representative live session open in a useful state.

Do not force-push. Do not delete, rename, or mass-format unrelated work. Do not
rewrite the stable controller merely to make it look cleaner. Do not commit
credentials, local revision-control caches, autosaves, logs, temp files, or
oversized generated output.

GitHub visibility and authentication are external repository administration,
not game production. Keep gameplay development local when remote authentication
is unavailable. Local checkpoint commits are encouraged after validated
milestones. Do not push automatically unless the user explicitly requests it.

---

# 7. CURRENT GAPS — HONEST PRIORITY ORDER

The validated checkpoint is a strong production graybox, not a finished island.
Work in this order unless live evidence reveals a more urgent regression.

## Priority 0 — restore documentary truth and re-prove baseline

Before adding risky features:

1. Check Git status and preserve unrelated work.
2. Confirm the live UEFN project and map.
3. Verify all 12 Button, 7 Billboard, 4 Character, 1 HUD, and controller
   references remain assigned on `TL_Controller`.
4. Confirm Debug and Automated Replay are false.
5. Build Verse without source changes.
6. Run project validation.
7. Launch/resume a session and reach the first case.
8. Search current UEFN/Fortnite logs for relevant Verse/build/validation errors.
9. Reconcile stale `docs/codex` current-status sections with
   `CODEX_HANDOFF.md`, source, builder evidence, and runtime results. Preserve
   old facts as dated history rather than pretending they are current.

Exit only when the baseline remains green and documentation no longer reports
the validated production build as “pending.”

## Priority 1 — real two-player claim and recovery QA

Highest-value known validation gap:

- Two players approach the same active passenger.
- Only one becomes claim owner.
- The second cannot collect/submit in a way that double-resolves.
- The owner disconnects or leaves during inspection.
- The claim releases or transfers safely.
- The remaining player completes the case once.
- Shared cash, integrity, risk, shift count, and case count update once.
- Join-in-progress receives a safe current phase/status.

Use a genuine second Fortnite client if the environment supports it. If only one
client is possible, create the narrowest deterministic contention/recovery test
harness that invokes production claim/decision paths, but continue marking real
two-client coverage as incomplete. Do not call one-client replay multiplayer
validation.

## Priority 2 — untested failure branches and replay robustness

Session-test and record:

- Missed final-threat branch: final disguise incorrectly cleared, boss begins
  with additional risk/integrity consequence, all response stages resolve,
  results appears, replay resets cleanly.
- Emergency timeout: allow a later-shift emergency to time out, confirm one
  failure penalty, normal power/stations restore, and the run resumes safely.
- Runner escape after no intercept.
- False detention.
- Reset/results replay twice without stale passenger, claim, boards, power,
  timers, or duplicate progress.

## Priority 3 — full seven-shift pacing and balance

Run all 21 routine cases without debug skips. Record per shift:

- Case templates and required evidence.
- Correct/incorrect decisions.
- Cash, integrity, and risk deltas.
- Emergency timing.
- Upgrade affordability and effect.
- Total run length.
- Confusing or repetitive prompts.
- Dead time between queue, inspection, decisions, detention, power, and exit.

Tune only from observed play. Preserve deterministic debug access for regression.

## Priority 4 — productionize one weaker physical branch

After Priority 1-3 are green, choose one high-value branch based on runtime
weakness, preferably:

1. Make Shift 4 or 6 a visibly physical emergency with a clear spatial
   objective and complete cleanup, or
2. Improve resistant-suspect response from button simulation toward a proven
   physical AI/guard encounter, or
3. Improve queue transfer so queued characters visibly advance rather than
   remaining static stand-ins.

Do one minimal placement-method proof first. Keep current reliable fallback until
the replacement passes save, validation, session, reset, and replay tests.

## Priority 5 — reference-quality presentation pass

Once core branches and replay remain green, improve the largest reference gaps:

1. Normal-versus-lockdown lighting contrast.
2. Scanner clean/detected feedback readable at a glance.
3. Passenger/case/claim marker clarity.
4. Linked bag evidence presentation.
5. Document readability and safe modal/world-board cleanup.
6. Custody/tether/intake feedback.
7. Alarm audio and objective stingers.
8. Departure and jail visual destinations.
9. Original signage and lane markings.
10. Approved airport props/material replacements.

Do not replace all graybox elements at once. Prove one family, replace a small
batch, validate, runtime-check, compare from representative viewpoints, and
keep or revert that family based on evidence.

## Priority 6 — later production work

Only after the core game is stable:

- Performance testing at representative player counts.
- Small versioned persistence schema for tutorial completion/career credits and
  a few durable upgrades.
- Accessibility and controller/mobile interaction review.
- More case variety through data rather than duplicated branch code.
- Release/publish preparation when explicitly requested by the user.

Never persist transient actor references, current passenger, open UI, active
emergency, or live claim ownership.

---

# 8. REQUIRED VALIDATION LOOP

After every material source, device, map, asset, or wiring change:

1. Save modified content.
2. Build Verse.
3. Fix new compile errors before stacking more work.
4. Run UEFN validation and distinguish pre-existing warnings from new failures.
5. Confirm no duplicate `TL_` labels or proof leftovers were introduced.
6. Push Verse/content changes to the connected session when required.
7. Launch or resume the actual AirportSecurity session.
8. Exercise the changed player-facing path through production handlers.
9. Test cancel/reset/emergency/replay cleanup where relevant.
10. Search current UEFN and Fortnite logs for new relevant errors.
11. Update the asset ledger, test matrix, validation log, worklog, architecture,
    manual steps, final report, and handoff with exact evidence.

A feature is not complete merely because:

- Verse compiles.
- A class exists.
- An asset path resolves.
- A device is placed but unwired.
- A widget appears but cannot close safely.
- A passenger or bag is visible but not linked to the current case.
- HUD text claims an emergency while the terminal remains unchanged.
- A one-player replay is labeled multiplayer testing.

Minimum regression scenarios to retain:

### Clean traveler

Passenger stages, claim succeeds, required checks are completed, Clear is
accepted, passenger exits, reward/progress applies once, next case stages.

### Secondary

Ambiguous/policy case exposes fair evidence, Secondary resolves or reveals the
needed evidence, costs/rewards are correct, and final cleanup succeeds.

### Correct detention

Major evidence is visible, Detain begins custody, intake finalizes once,
passenger reaches the cell, and next case stages.

### False detention

Clean traveler is detained, one penalty applies, traveler/case cleans up, and
the queue continues.

### Runner/resistant

Runner capture and escape are distinct; resistant response reaches custody;
neither branch leaves stale hostile/custody state.

### Emergency

Inspection suspends safely, terminal/objective changes, success and timeout are
distinct, temporary state cleans up, power/stations restore, next shift resumes.

### Full run

All shifts progress, final threat detected and missed branches can reach
results, and replay starts a clean new run.

### Claim conflict

Two real players or the strongest honest deterministic harness attempt the same
case; only one transaction resolves and owner loss recovers safely.

Repetition target after major state-machine work:

- Ten consecutive mixed cases.
- Chosen emergency twice across fresh runs.
- Results-to-replay twice.
- Three clean boot/start smoke tests when practical.

---

# 9. DOCUMENTATION UPDATE CONTRACT

Do not create redundant status documents. Update the existing files and keep
them mutually consistent:

- `CODEX_HANDOFF.md`: current checkpoint, date, player-visible state, systems,
  files, entry points, actors/devices, validation/runtime evidence, known issues,
  unfinished tasks, and exact next steps.
- `docs/codex/EXEC_PLAN.md`: current priorities and milestone status.
- `docs/codex/WORKLOG.md`: concise timestamped implementation, failures,
  fallbacks, and evidence.
- `docs/codex/ARCHITECTURE.md`: canonical paths and current ownership/flow.
- `docs/codex/ASSET_PLACEMENT_LEDGER.md`: every new candidate and exact method.
- `docs/codex/TEST_MATRIX.md`: actual scenario status and evidence.
- `docs/codex/VALIDATION_LOG.md`: compile, validation, activation, runtime/log
  results.
- `docs/codex/MANUAL_UEFN_STEPS.md`: only real remaining user/editor actions;
  remove obsolete pending actions.
- `docs/codex/FINAL_BUILD_REPORT.md`: dated factual current build report and
  eleven-role reference match.

When reconciling stale docs, preserve dates and historical context. Do not
rewrite history as if early pending work never existed. Mark it superseded by
the validated checkpoint and add current evidence.

At each validated milestone, update `CODEX_HANDOFF.md` first, then regenerate
this continuation prompt from the final live files and handoff. The new prompt
must include:

- New checkpoint name/date/commit if committed.
- Exact new file and actor changes.
- What runtime paths were truly validated.
- What failed and what fallback was chosen.
- Current highest-value unfinished milestone.
- Updated no-regression contracts.
- A new unique end marker/version.

Verify the new prompt is complete before using it.

---

# 10. EXECUTION BEHAVIOR

Begin with evidence, then act. Spend only enough time auditing to avoid building
on stale state. Do not stop after writing a plan.

Use the existing local UEFN bridge, builder, logs, and Windows app control when
they are working. Do not clone or build another general-purpose tooling project.
If a method fails twice in materially different ways or consumes roughly 25-35
minutes without player-visible progress, choose the strongest supported fallback
and continue. Record the failure honestly.

Keep UEFN green in small batches. Save before risky changes. If a new approach
breaks validation and cannot be repaired promptly, return to the most recent
validated local Git checkpoint without deleting unrelated user work, then choose
a simpler path. Never use destructive Git reset or checkout operations without
explicit authority.

Ask the user only for a short, concrete, truly blocking action—for example,
signing into a required service, launching a second Fortnite client, resolving
a CAPTCHA, or performing an editor-only operation that automation cannot safely
complete. Continue safe independent work while waiting whenever possible.

Leave UEFN or the live Fortnite session open on a useful representative state.
Do not close the game or editor when a cycle finishes.

---

# 11. FIRST EXECUTION FROM THIS VERSION

After confirming this prompt’s final marker, perform this exact first cycle:

1. Inspect `git status`, current UEFN/Fortnite processes, active map, current
   editor/session status, and latest logs.
2. Confirm the live project still matches checkpoint `5ece958` plus any newer
   intentional user changes.
3. Rebuild Verse and run project validation without changing gameplay.
4. Launch/resume and prove the first clean case still works.
5. Reconcile the stale `docs/codex` current-state tables with the validated
   checkpoint, source, builder inventory, and runtime evidence.
6. Select Priority 1 if a second client is available. If not, implement or run
   the narrowest deterministic claim/owner-loss regression harness, then keep
   real two-client validation marked pending.
7. Runtime-test the missed-boss and emergency-timeout branches if they can be
   reached safely in the same cycle.
8. Fix demonstrated state bugs before adding art.
9. Update all required documents and `CODEX_HANDOFF.md`.
10. Create a local checkpoint commit only after compile, validation, runtime,
    and log checks are green.
11. Regenerate this prompt completely as version 2 from that new state.
12. Verify the version 2 end marker, then continue with the next highest-value
    unfinished milestone.

If the current editor/session state contradicts the handoff, trust fresh
evidence, document the discrepancy, and repair the smallest safe regression.

The objective is visible, connected, replayable, tested airport-security
gameplay—not another list of systems and not an attractive shell disconnected
from the case loop.

---

END_OF_AIRPORTSECURITY_CONTINUATION_PROMPT_V1
