# Terminal Lockdown execution plan

Last updated: 2026-07-28 PDT

## Goal

Turn the new `AirportSecurity` UEFN island into an original cooperative airport
inspection game named **Terminal Lockdown**. The first release boundary is a
reliable end-to-end passenger case; later systems expand only while compile,
validation, and editor evidence stay green.

## Baseline

- Live project: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity`
- UEFN compatibility: 41.20; editor reports Unreal Editor 5.8.
- Map: `/AirportSecurity/AirportSecurity`.
- Existing content before this task: map, default HLOD layer, GameFeatureData,
  four grid planes, four player spawners, Island Settings, Day/Night actor, level
  bounds, and generated external actors. No Verse source or airport art existed.
- Editor status before changes: **All Saved**, **No Changes**, 14 actors.
- UEFN Python was disabled; enabled on 2026-07-28. Editor restart is required
  before starting the local bridge.
- Direct UEFN HTTP bridge check before restart: connection refused on port 8765.
- Lore CLI baseline status could not deserialize revision states; UEFN UI is the
  authoritative clean-baseline observation for this new project.

## Milestones

| Milestone | Status | Exit evidence |
|---|---|---|
| Audit and safety documents | In progress | Plan, worklog, ledger, architecture, tests, validation log |
| Python bridge and asset proof | Pending | Bridge ping; one primitive placed, saved, validated |
| Terminal graybox | Pending | Named TL geometry/device inventory and saved map |
| Passenger vertical slice | Pending | Verse compile + one case from briefing to Clear/Detain |
| Shift and emergency slice | Pending | Shift progression and at least one runner/lockdown path |
| Final threat and results | Pending | Detected/missed debug branches reach results |
| Session validation | Pending | Launch Session smoke test and cleanup proof |

## Build order

1. Restart UEFN, start the reviewed local Python bridge, and inventory the
   editor world through `unreal` reflection.
2. Run a one-object placement proof using an exact primitive mesh, material,
   actor class, and placement method. Save and run UEFN validation.
3. Build an idempotent compact terminal graybox under `TL_` actor labels.
4. Place only locally loadable Creative device classes. Compile Verse before
   placing the custom Verse controller.
5. Wire exact native Verse objects to the controller; reject missing refs.
6. Launch a session and exercise Clear, Detain, stale-input rejection, reset,
   one emergency, and both final-branch debug paths as the build permits.

## Scope rule

A resolved asset path is never approval. A candidate enters production only
after its exact placement method is saved, validated, and session-tested. Until
then the core loop uses device/UI fallbacks and the ledger says
`NEEDS_EDITOR_VERIFICATION`.

