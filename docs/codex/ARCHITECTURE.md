# Terminal Lockdown architecture

## Verified-slice boundary

The first executable slice uses one authoritative `terminal_lockdown_controller`
Verse device. It owns the match generation, phase, active case, evidence,
decision transaction, team integrity/risk/progress/cash, and debug transitions.
Native buttons are thin inputs; the HUD device is output only. This intentionally
keeps the initial wiring auditable while the map is still a blank project.

## State ownership

- Match phase: controller only.
- Current case ID and truth: controller only; ordinary players never receive
  hidden truth.
- Evidence: stations call one controller method with the current Case ID.
- Decision: one guarded transaction checks phase, claim owner, Case ID,
  prerequisites, and the one-time resolution flag.
- Team values: controller only; clamped after each transaction.
- Player join/leave: subscriptions add/remove transient UI and release claims.
- Emergency: a generation token cancels stale asynchronous callbacks.

## Vertical-slice flow

`Waiting -> Briefing -> CaseReady -> Inspecting -> AwaitingDecision -> Resolving
-> CaseComplete -> CaseReady`.

Secondary returns to `AwaitingDecision`. Detain resolves through a short secure
interaction fallback in the initial slice; physical NPC escort remains feature-
required until the complete NPC Character Definition -> spawner -> nav -> jail
chain passes editor/session validation.

## Expansion seams

Once the slice is proven, focused managers split out behind the same controller
contracts: case generator, lane controller, arrest/jail manager, shift director,
emergency director, boss controller, economy, persistence, and player UI. No
station may mutate hidden truth or shared progression directly.

## Failure and recovery

- Old callbacks carry a match generation and Case ID and are ignored.
- Claim releases on owner leave, reset, emergency, or case completion.
- Missing optional art/VFX leaves gameplay intact.
- Missing required device refs prevents match start and logs one clear error.
- Timed activities have bounded fallbacks; no unbounded per-frame loops.

