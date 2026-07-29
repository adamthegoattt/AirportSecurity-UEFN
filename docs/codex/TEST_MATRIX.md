# Test matrix

Last reconciled: 2026-07-28 PDT

| ID | Test | Status | Evidence / remaining requirement |
|---|---|---|---|
| B-01 | Project/map opens | PASS | Active `AirportSecurity`; `/AirportSecurity/AirportSecurity` |
| B-02 | Saved production inventory | PASS | 155 actors; 143 unique `TL_`; no proof/trial labels |
| B-03 | Builder idempotency | PASS | Rerun `created=0`, `updated=143`, `duplicates=0` |
| B-04 | Verse compile | PASS | Original build and fresh 2026-07-28 no-source build succeeded |
| B-05 | Validation/cook/activation | PASS | Local validation complete; candidate validated; content activated on all platforms |
| C-01 | Start/autostart exactly once | PASS | Production replay reached Shift 1 once after reload |
| C-02 | Clean Clear | PASS | Shift 1 body/clear production handlers |
| C-03 | Secondary | PASS | Shift 3 body/bag/doc/secondary production handlers |
| C-04 | Correct detention/intake | PASS | Detention and custody movement; +175 transaction |
| C-05 | Duplicate custody | PASS | Second intake rejected by `CustodyCommitted` guard |
| C-06 | False detention | PENDING RUNTIME | Compile path present; runtime evidence required |
| C-07 | Runner capture | IMPLEMENTED / PENDING DEDICATED RUNTIME | Production handler and movement path exist |
| C-08 | Runner escape | PENDING RUNTIME | Timeout/movement consequence requires dedicated evidence |
| C-09 | Resistant response | IMPLEMENTED FALLBACK | Response -> custody path; no proven combat AI |
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
| P-01 | Full 21-case pacing | NOT RUN | Requires normal no-skip run and balance record |
| P-02 | Representative performance | NOT RUN | 4/8/16-player measurements pending |

Never classify one-client automation as real multiplayer testing.
