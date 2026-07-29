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
| C-11 | Player document interface | PASS (COMPILE + EDITOR) | Per-player 720x760 UI compiles with fictional identity, portrait placeholder, number, expiry, route, access, five consistency checks, evidence status, duplicate-open guard, return control, claim release, and case/reset/removal cleanup; live UI proof pending |
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
| P-03 | Current post-reference live activation | BLOCKED EXTERNAL | Two clean launches stopped at Epic `errors.com.epicgames.common.processing`; editor validation and Verse compile pass |

Never classify one-client automation as real multiplayer testing.
