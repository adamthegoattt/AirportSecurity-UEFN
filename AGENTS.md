# AirportSecurity project target

Build a polished Fortnite airport-security game matching the reference images, with a complete player loop through queue entry, body scanning, baggage inspection, documents, Clear, Secondary, detention, emergencies, results, and replay.

## Verified project locations

- Active UEFN project: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\AirportSecurity.uefnproject`
- Active map: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\AirportSecurity.umap` (`/AirportSecurity/AirportSecurity`)
- Main Verse controller: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\terminal_lockdown_controller.verse`
- Verse types: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\terminal_lockdown_types.verse`
- UI source: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\terminal_lockdown_controller.verse` (body scan, X-ray, documents, HUD, and upgrades)
- Production builder: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\Python\build_airport_production_pass.py`
- Reference environment builder: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\Python\build_reference_match_pass.py`
- Base environment/gameplay builder: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\Python\build_terminal_lockdown.py`
- External actors: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\Content\__ExternalActors__\AirportSecurity`
- Reference images: `C:\Users\chris\Documents\secure the airport fortnite\reference_images\airport_security`
- Validation output: `C:\Users\chris\Documents\Fortnite Projects\AirportSecurity\docs\codex\validation_2026-07-30.json`

## Production priorities

1. Finished player-facing gameplay.
2. Physical representation inside the world.
3. Visual similarity to the references.
4. Reliable state management and multiplayer behavior.
5. Live testing.
6. Documentation only after production work.

## Forbidden shortcuts

- Billboards, default Fortnite Button devices, and static characters are not finished UI, stations, or functioning passengers.
- Opening UI does not complete an inspection; require player judgment without plain-text answers.
- Automated tests are not proof of normal gameplay.
- Builder edits count only after the builder runs and generated actors are saved.
- Unsaved editor work does not count. Do not accept teleporting or hiding passengers as successful movement.
- Do not run documentation-only or QA-only development sessions, or stop at inspection when implementation was requested.

## Implementation and UEFN requirements

For every implementation task, change real production Verse, UI, devices, map actors, or external actors. Preserve intentional manual placements. Run edited builders, confirm idempotency, save the active map and every modified asset, and confirm external-actor changes in Git. Keep the scanner platform flush with the floor and usable without jumping; fix collision and routes instead of hiding failures. Disable development labels and shipping debug/automated-replay flags during normal play.

Compile with UEFN **Build Verse** and require `Built successfully`. Validate the saved `/AirportSecurity/AirportSecurity` map. Use **Launch Session** or refresh the connected session for the exact saved build, start from a fresh player spawn, and exercise real player interactions rather than internal handlers. Label every result only `PASS`, `FAIL`, or `UNVERIFIED`; source inspection is never runtime proof.

A feature is complete only when it exists in saved production code or actors, is visible and usable in a live UEFN session, resets correctly, is committed, and is pushed.

## Git requirements

Before editing, record `git rev-parse HEAD` and `git status --short --branch`; preserve legitimate changes. Create coherent production commits, never force-push or destructively reset unknown work, push completed milestones automatically, then confirm the remote branch contains the final commit. Do not claim delivery for local-only work.

## Task scope and reporting

Finish one milestone deeply: body scanner; baggage and documents; Secondary and detention; main terminal visuals; or power failure and emergency lighting. At the end report starting/final commits, production files, map/external actors, player-visible behavior, live results, remaining failures, push confirmation, and production diff summary. Reports, logs, comments, screenshots, and documentation are supporting evidence only.
