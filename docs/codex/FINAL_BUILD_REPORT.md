# Final build report — extended replay QA checkpoint

Date: 2026-07-28 PDT

## Outcome

The live AirportSecurity project contains a compact original airport terminal
and a connected seven-shift Terminal Lockdown game. A physical Character-device
passenger stages at the scanner, the player collects body/bag/document evidence,
chooses Clear/Secondary/Detain, routes threats through runner/resistant/custody
states, restores power during a terminal outage, reaches a final threat, sees
results, and can reset to a clean waiting state.

## Implemented and live-session validated

- Reference-zoned 143-actor terminal production graybox.
- Body/clear, body/bag/document/secondary, detention/custody with duplicate
  rejection, Shift 5 power outage/restore, detected boss victory, and replay
  reset through production handlers.
- Successful Verse build, local validation, session candidate validation,
  cook/distribution, and content activation.
- Builder idempotency: second run created zero duplicate production actors.
- Deterministic production-handler claim release/reclaim and duplicate-decision
  regression.
- Missed final-threat victory and emergency-timeout penalty/recovery, each
  completed twice in the live session before the QA switch was restored false.

## Implemented but runtime coverage incomplete

- Real two-player contention and disconnect/rejoin recovery.
- Full real-time 21-case pacing and performance at representative counts.
- Dedicated false-detention, runner capture/escape, and resistant-response
  runtime passes.
- Shift 4/6 and resistant response are functional interaction fallbacks rather
  than fully physical AI encounters.

## Reference match

| Role | Status |
|---|---|
| Security office and response supply | PRESENT — graybox monitors, desk, supply table/crate |
| Power room | PRESENT / FUNCTIONAL — utility console changes real scanner availability |
| Restricted corridor | PRESENT |
| Runway windows and aircraft | PRESENT — original GridPlane silhouette |
| Main terminal wide | PRESENT — high shell, beams, open sightlines |
| Scanner and active passenger | PRESENT / FUNCTIONAL |
| Checkpoint and bag area | PRESENT / FUNCTIONAL FALLBACK |
| Physical decision buttons | PRESENT / FUNCTIONAL |
| Detention cell | PRESENT / FUNCTIONAL intake/cell movement |
| Response refill station | PRESENT AS RESPONSE SUPPLY; item-grant/refill loadout not yet productionized |
| Waiting area wide | PRESENT — three seat rows and terminal sightline |

## Asset placement statement

The production build uses exact saved and session-tested workflows for the
existing GridPlane duplicate method and native Button, HUD Message, Billboard,
Character, and Verse devices. No future art, audio, VFX, NPC, or AI candidate is
approved merely because its path loads.

## Known issues

- One connected Fortnite client was used for runtime replay.
- Real multiplayer remains unproven; one-client claim regression is not labeled
  as multiplayer validation.
- The environment remains a production graybox/silhouette rather than bespoke
  final art.
- Queue characters do not yet visibly advance as a pooled crowd.
- Persistence is not implemented.

## Recommended next target

Prove case-claim contention and owner-loss recovery with two real clients, then
exercise false detention and runner capture/escape through dedicated runtime
passes.
