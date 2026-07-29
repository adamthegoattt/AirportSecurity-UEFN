# Terminal Lockdown execution plan

Last updated: 2026-07-28 PDT (extended replay QA)

## Goal

Continue the validated Terminal Lockdown airport-security game in the live
`AirportSecurity` UEFN project. Preserve the reference-zoned terminal and
complete the remaining runtime, multiplayer, pacing, and presentation work
without restarting from scratch.

## Current checkpoint

- Name: `Terminal Lockdown - Validated Reference Pass`
- Git: `5ece9583b1b352f12ff5534bbba70ffa327c45e1` on `main`
- Map: `/AirportSecurity/AirportSecurity`
- Compatibility: 41.20
- Inventory: 155 total actors, 143 unique `TL_` production actors
- Production flags: Debug false; Automated Replay false
- Current continuation checkpoint: `Terminal Lockdown - Extended Replay QA`

## Milestones

| Milestone | Status | Evidence / exit requirement |
|---|---|---|
| Reference-zoned terminal | PASS | Main hall, queue/checkpoint, bag/doc/decision, detention, corridor, power, office/supply, waiting, runway silhouette, exit |
| Physical passenger fallback | PASS | Four Character devices; active passenger moves through clear/detention/response/cell paths |
| Linked bag and documents | PASS (fallback) | Physical parcel plus case-specific bag/document boards exercised in replay |
| Seven-shift controller | PASS | Deterministic 12-template catalog, three cases per shift, upgrades, emergencies, boss/results |
| Complete power emergency | PASS | Scanner offline, utility restore, reward, cleanup, progression |
| Detected boss and replay | PASS | Four-stage response -> victory -> results -> waiting |
| Fresh baseline validation | PASS 2026-07-28 | No-source Verse build successful; local validation, candidate validation, cook, connected-session activation completed |
| Deterministic claim/recovery regression | PASS | Production handlers released/reclaimed CaseId 7 and rejected a duplicate decision; one-client QA only |
| Two-player claim/recovery | PENDING | Two real clients contend; owner loss; exactly one resolution |
| Missed boss + emergency timeout | PASS | Extended live replay logged missed-boss victory and timeout penalty/recovery twice |
| Full 21-case pacing | PENDING | All shifts without debug skips, balance/timing record |
| Performance | PENDING | Representative player counts and memory/frame/network capture |
| Final art/audio/VFX | PENDING | Asset-contract-compliant replacement batches with live evidence |

## Immediate order

1. Keep the reconciled documents consistent with `CODEX_HANDOFF.md`.
2. Run genuine two-client contention/disconnect QA; keep the completed
   deterministic one-client regression classified separately.
3. Runtime-test runner capture/escape, false detention, and resistant response.
4. Run and tune the full 21-case pacing path.
5. Productionize one weaker physical branch, then begin small validated
   reference-quality presentation batches.

## Scope rule

Do not publish, add monetization, build another terminal, or replace validated
geometry while core branches and replay still have known runtime gaps. A
resolved asset path is never approval.
