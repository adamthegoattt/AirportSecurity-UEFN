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
