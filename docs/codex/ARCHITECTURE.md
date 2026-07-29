# Terminal Lockdown architecture

Last reconciled: 2026-07-28 PDT

## Canonical paths

- Live UEFN project: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity`
- Active map: `/AirportSecurity/AirportSecurity`
- Canonical live Verse: `Content/terminal_lockdown_controller.verse` and
  `Content/terminal_lockdown_types.verse`
- Canonical editor builder: `Content/Python/build_terminal_lockdown.py`
- Workspace mirror: `C:\Users\chris\Documents\secure the airport fortnite\AirportSecurityBuild`

UEFN compiles and saves the live project. The workspace mirror is not an
automatic synchronization target. At checkpoint `5ece958`, controller, types,
and builder matched their live copies by SHA-256. In the extended replay cycle,
the controller mirror/live copy was updated together and verified at SHA-256
`A1727B49AA6FA4DBFA093EAB2012C168204C253D0269D661E3F4F0E81C7F6989`.

## Authoritative state ownership

`terminal_lockdown_controller` owns run generation, emergency generation,
phase, shift, case ID/template, evidence flags, claim owner, exactly-once
resolution/custody guards, integrity, risk, cash, emergency state, boss branch,
results, and replay reset. Native devices are thin inputs/outputs.

The state path is:

`Waiting -> Briefing -> CaseReady -> Inspecting -> AwaitingDecision ->
Resolving -> CaseReady/UpgradeBreak -> Emergency -> Boss -> Results -> Waiting`.

Detention branches through `Runner`, `HostileResponse`, and `Custody` before
jail intake. Generation and case guards prevent stale movement/timeouts from
mutating a new run.

## Physical production fallback

- Three pre-placed Character devices provide a visible fixed queue.
- One active Character device is hidden/repositioned/shown and moved through
  scanner, departure, response, intake, and cell destinations.
- Linked luggage is a pre-placed GridPlane parcel plus a case-specific evidence
  board.
- Fictional documents are presented on a dedicated Billboard.
- Clear, Secondary, Detain, custody, power, response, upgrade, and start use
  physical Button devices.
- Shift 5 power outage disables the scanner until the utility console restores
  power.

These are session-proven conservative fallbacks, not a claim that an NPC
Spawner, autonomous crowd, X-ray UI, or combat AI is already implemented.

## Saved level inventory

Final reflection audit at the validated checkpoint found 155 actors total and
exactly 143 unique `TL_` production actors: 118 GridPlane, 12 Button, 7
Billboard, 4 Character, 1 HUD Message, and 1 Verse controller. No proof/trial
labels remained.

## Recovery contracts

- Run and emergency generations invalidate stale async tasks.
- Case ID guards all passenger movement completion.
- Claim releases on owner leave and case/reset transitions.
- `ResolutionCommitted` and `CustodyCommitted` reject duplicate transactions.
- The disabled replay harness exercises claim release/reclaim, duplicate
  decision rejection, missed-boss victory, and emergency timeout through the
  production handlers; it does not substitute for real multiplayer QA.
- Reset hides the active passenger, restores power, disables custody, clears
  claims, increments generations, and returns every status board to waiting.
- Missing optional art cannot replace a working gameplay fallback.

## Known architecture gaps

- Only one connected Fortnite client has been exercised.
- Join-in-progress and simultaneous two-player contention remain unproven.
- Queue characters are static stand-ins rather than a fully advancing pool.
- Resistant response is a reliable button/movement fallback, not proven AI
  combat.
- Persistence is not implemented.

## Historical note

The original architecture described an unwired first slice in a blank 14-actor
project. That baseline is superseded by the validated Terminal Lockdown
reference pass above and is retained in Git history.
