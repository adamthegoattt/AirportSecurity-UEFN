# Test matrix

Last reconciled: 2026-07-28 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| B-01 | Project/map opens | PASS | Active `AirportSecurity`; `/AirportSecurity/AirportSecurity` |
| B-02 | Saved production inventory | PASS | 155 actors; 143 unique `TL_`; no proof/trial labels |
| B-03 | Builder idempotency | PASS | Rerun `created=0`, `updated=143`, `duplicates=0` |
| B-04 | Verse compile | PASS | Original build and fresh 2026-07-28 no-source build succeeded |
| B-05 | Validation/cook/activation | PASS | Local validation complete; candidate validated; content activated on all platforms |
| B-06 | Luggage pool and residue audit | PASS (EDITOR) | Three production `TL_BAG_` actors; no proof/debug/replay labels; map validation 1/1 valid and 0 warnings |
| C-01 | Start/autostart exactly once | PASS | Production replay reached Shift 1 once after reload |
| C-02 | Clean Clear | PASS | Shift 1 body/clear production handlers |
| C-03 | Secondary | PASS | Shift 3 body/bag/doc/secondary production handlers |
| C-04 | Correct detention/intake | PASS | Detention and custody movement; +175 transaction |
| C-05 | Duplicate custody | PASS | Second intake rejected by `CustodyCommitted` guard |
| C-06 | False detention | PASS | Production handlers recorded 1 false detention, 1 resolved, integrity 95, risk 4, cash -100 |
| C-07 | Runner capture | PASS | DETAIN intercept -> intake -> custody; 1 correct/resolved, cash 175 |
| C-08 | Runner escape | PASS | Ten-second no-intercept path; 1 resolved, integrity 90, risk 16 |
| C-09 | Resistant response | PASS (FALLBACK) | Response -> physical intake -> custody; 1 correct/resolved, cash 175; no combat AI claim |
| C-10 | Linked luggage motion / X-ray result | PASS (COMPILE + EDITOR) | Three class-backed props wired to controller; guarded inbound, tunnel, and exit `MoveTo` paths compile; live-session proof pending |
| C-11 | Player document interface | PASS (COMPILE + EDITOR) | Per-player UI compiles with fictional identity, portrait placeholder, route/access checks, evidence status, duplicate-open guard, return control, claim release, and cleanup |
| C-12 | Physical Clear / Secondary / Detain station | PASS (COMPILE + EDITOR) | Three large green/yellow/red pads, enlarged underlying Button devices, dynamic labels, evidence-gated enablement, submit lockout, and committed-outcome feedback are saved |
| M-00 | Deterministic claim regression | PASS | One-client production-handler harness released/reclaimed CaseId 7 and rejected duplicate decision; not multiplayer QA |
| M-01 | Two-player contention | NOT RUN | One connected client only |
| M-02 | Claim owner disconnect/rejoin | NOT RUN | Handler and deterministic owner-loss regression pass; genuine disconnect/rejoin still required |
| E-01 | Shift 5 power outage success | PASS | Scan denied offline; power restored; progression resumed |
| E-02 | Emergency timeout | PASS | Extended live replay logged one timeout penalty and recovery in each of two runs |
| E-03 | Shift 4/6 response | IMPLEMENTED FALLBACK | Response button state path; needs stronger physical proof |
| X-01 | Boss detected victory | PASS | Four response stages -> victory -> results |
| X-02 | Boss missed branch | PASS | Extended live replay logged Shift 7 missed-boss victory in each of two runs |
| R-01 | Results -> waiting replay | PASS | Production replay marker and clean reset |
| R-02 | Extended replay twice | PASS | Two complete QA2 sequences returned to waiting; production flag then restored false |
| R-03 | Failure-branch replay | PASS | QA3 covered C-06 through C-09 and a clean post-branch case; flag restored false before normal activation |
| P-01 | Full 21-case pacing | NOT RUN | Requires normal no-skip run and balance record |
| P-02 | Representative performance | NOT RUN | 4/8/16-player measurements pending |
| P-03 | Current post-reference live activation | PASS (CONNECTED BOOT) | Fortnite connected and controller HUD/case state was observed; fresh-session traversal remains manual QA |

Never classify one-client automation as real multiplayer testing.

## Custody milestone delta — 2026-07-28 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| C-13 | Remote custody rejection | IMPLEMENTED / LIVE RETEST BLOCKED | `IsAgentNear` checks intake before claim/commit; live session startup was blocked at this dated milestone |
| C-14 | Remote runner capture rejection | IMPLEMENTED / LIVE RETEST BLOCKED | Decision-lane proximity required before intercept; stale/duplicate guards retained |
| C-15 | Remote resistant response rejection | IMPLEMENTED / LIVE RETEST BLOCKED | Response-zone proximity required before response begins |
| C-16 | Visible pooled jail state and reset | PASS (STATIC/VALIDATION) | One reusable occupant plus cell board wired; 242-actor audit found exactly both actors and no residue; live visual retest pending |
| C-17 | Verse build after custody changes | PASS | UEFN `Built successfully` |
| C-18 | Map validation after custody changes | PASS | 1 requested, 1 checked, 1 valid, 0 invalid, 0 warnings |

## Response-event milestone delta - 2026-07-28 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| RE-01 | Response station visible, signed, and wired | PASS (STATIC/VALIDATION) | Granter, remover, remote manager, siren, two red point lights, and board audited in `TerminalLockdown/Gameplay/ResponseEvent` |
| RE-02 | Event equipment is temporary and non-duplicating | PASS (CODE/VALIDATION) | Shared cleanup removes Signal Remote A from all players and disables issue/input on success, timeout, reset, result, emergency, boss, and case transitions |
| RE-03 | Response requires physical participation | PASS (CODE/VALIDATION) | Primary Signal Remote event is rejected outside an 850-unit response-room radius; replacement issue also requires station proximity |
| RE-04 | Hostile behavior is bounded and non-gory | PASS (CODE/VALIDATION) | Existing active Character follows four response-room waypoints with case/run/generation guards; no gore or unbounded spawns |
| RE-05 | Success cleanup and custody handoff | IMPLEMENTED / LIVE RETEST BLOCKED | Success stops siren/lights, recalls equipment, disables response devices, and moves suspect to physical intake; Epic handshake blocks current live capture |
| RE-06 | Timeout cleanup and consequence | IMPLEMENTED / LIVE RETEST BLOCKED | 30-second timeout performs identical cleanup, hides suspect, applies +10 risk/-8 integrity once, and finishes case |
| RE-07 | Join-in-progress equipment safety | IMPLEMENTED / LIVE RETEST BLOCKED | Players joining `HostileResponse` receive one registered loadout; shared all-player removal handles completion/reset |
| RE-08 | Final Verse build | PASS | UEFN reported `Built successfully` after final device wiring and QA-harness adjustment |
| RE-09 | Final map validation and residue audit | PASS | 1/1 valid, 0 invalid, 0 warnings; 249 actors; seven response actors; no proof/debug/replay labels |
| RE-10 | Runtime normal/alert/threat/cleanup captures | BLOCKED (EXTERNAL) | Two clean Launch Session attempts fail at Epic handshake with `errors.com.epicgames.common.processing`; no editor state claimed as runtime proof |

## Feedback-and-alert milestone delta - 2026-07-28 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| FA-01 | Six feedback devices exist and are controller-wired | PASS (STATIC/VALIDATION) | Actor audit found six Audio Players in `TerminalLockdown/Gameplay/Feedback`; controller package contains all six editable names and assigned package IDs |
| FA-02 | Scanner, bag, decision, custody, power, alert, and results triggers compile | PASS (CODE/VALIDATION) | Final UEFN Verse build reported `Built successfully`; selected cues are serialized in the six actor packages |
| FA-03 | Final map validation and residue audit | PASS | 1/1 valid, zero invalid, zero warnings; 255 actors; no proof/debug/replay labels |
| FA-04 | Live sound, normal/alert comparison, and reference-angle proof | BLOCKED (EXTERNAL) | Epic launch handshake returns `errors.com.epicgames.common.processing`; no editor-only image is promoted as runtime proof |

## Complete reference-match delta - 2026-07-29 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| ART-01 | Managed visual pass creates the complete expected set | PASS | Final builder run reported 104 managed actors and `saved=true` |
| ART-02 | Builder idempotence / stale cleanup | PASS | Repeat run reported `stale_removed=0`; actor audit found no duplicate labels |
| ART-03 | Eleven supplied reference roles represented | PASS (STATIC/EDITOR) | Terminal, waiting, checkpoint, scanner, bag, decision, detention, corridor, power, office/ammo, and runway/aircraft zones are present |
| ART-04 | Legacy visual overlap removed | PASS | 24 superseded legacy visual groups hidden without deleting gameplay devices |
| ART-05 | Final Verse build | PASS | UEFN reported `Built successfully` after the reference pass |
| ART-06 | Final map validation / residue audit | PASS | 1/1 valid, 0 invalid, 0 warnings; 282 actors; 270 unique `TL_`; no residue |
| SPAWN-01 | Spawn transforms and clearance | PASS (STATIC) | Pads `(500,+/-1250,64)`, starts Z 180, yaw 0; >=465 cm nearest static clearance |
| SPAWN-02 | Island/device spawn configuration | PASS (EDITOR) | Spawn Location=Spawn Pads; random selection; both pads Always and island-start enabled |
| SPAWN-03 | Fresh-session spawn-to-checkpoint traversal | MANUAL QA | Long-lived edit-session respawn camera was inconclusive; current automation cannot hold movement/capture mouse reliably |
| ART-07 | Eleven final runtime reference-angle captures | MANUAL QA | Requires a newly started play session and human camera positioning; no editor-only frame is labeled runtime proof |

## State and routing hardening delta - 2026-07-29 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| SR-01 | Reject illegal/unavailable interaction before case claim | PASS (CODE/RUNTIME) | Scan, bag, document, secondary, and decision handlers validate prerequisites before `TryClaim`; replay completed claim/reclaim and duplicate-decision milestones |
| SR-02 | Keep one synchronized active-case identity | PASS (CODE/RUNTIME) | `terminal_active_case` tracks case/run/shift/template/owner/evidence/destination/phase and stale movement callbacks were rejected in live logs |
| SR-03 | Final threat counts exactly once on both branches | PASS (RUNTIME) | Latest post-fix replay: detected logged `Resolved=4, Correct=4, Missed=0`; isolated missed branch logged `Resolved=2, Correct=1, Missed=1`, each advancing final accounting once |
| SR-04 | Blocked passenger and bag routes cannot softlock silently | PASS (RUNTIME WITH FALLBACK) | Active-passenger movement generations supersede interrupted routes before retry; queue/bag movers retain stale, retry, teleport, and safe-hide fallbacks; no Verse runtime error |
| SR-05 | Clean shipping configuration after QA | PASS (FINAL STATIC/COMPILE) | `DebugEnabled=false`; `AutomatedReplayEnabled=false`; final production compile/push/activation completed at 01:20:33 UTC |
| SR-06 | Fresh client spawn presentation | FAIL (PRESENTATION) | Live client joined, but the starting view remains overbright/open and building controls are enabled |
| SR-07 | Human full-loop and real multiplayer contention | NOT TESTED | Requires manual scanner-to-cell traversal, a 21-case pacing run, and at least two clients |
| SR-08 | Custody cannot commit before passenger intake readiness | PASS (CODE/RUNTIME) | `PassengerAtIntake` is synchronized into the active case; premature input rejects; runner and resistant custody each reached intake/cell and logged `Resolved=1` |
| SR-09 | Failure branch leaves the next case clean | PASS (RUNTIME) | Final QA3 run logged false detention, runner capture, runner escape, resistant response, and post-branch clean case at `Resolved=1`, with no final `[QA3 FAIL]` marker |
