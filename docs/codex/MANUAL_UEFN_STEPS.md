# Manual UEFN steps

Last updated: 2026-07-28 PDT

The original restart/bridge/first-placement instructions are complete and are
retained in Git history. The current live project already contains the compiled,
wired, saved, validated Terminal Lockdown checkpoint.

## Current exact checks

1. Open `AirportSecurity.uefnproject` in compatibility version 41.20.
2. Open `/AirportSecurity/AirportSecurity`.
3. Select `TL_Controller` and confirm references for 12 Buttons, 7 Billboards,
   4 Characters, and `TL_HUD_Status` remain assigned.
4. Keep `DebugEnabled=false` and `AutomatedReplayEnabled=false` except during an
   intentional local QA run; return both to false before checkpointing.
5. Build Verse. Expected result: `Built successfully`.
6. Refresh/launch the connected session. Expected log results include completed
   local validation, successful candidate validation, completed cook/update,
   and successful activation.
7. For real multiplayer QA, launch a genuine second Fortnite client/player,
   contend for one case, disconnect the claimant during inspection, and verify
   the remaining player completes the case exactly once.
8. The deterministic one-client owner-loss, missed-boss, timeout, false
   detention, runner capture/escape, resistant response, and clean-reset
   harness is already logged as passing. Do not rerun it by default and do not
   describe it as genuine two-client or normal-speed pacing coverage.

## Production dependency rule

Before replacing a GridPlane or adding an NPC, material, audio, VFX, camera, or
AI device, prove one exact candidate in isolation through assignment, placement,
save, validation, cook, live session, cleanup, and replication where relevant.
