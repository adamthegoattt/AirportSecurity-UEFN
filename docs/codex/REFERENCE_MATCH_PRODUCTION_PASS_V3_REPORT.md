# Reference-match production pass V3 report

Date: 2026-07-29 PDT

## Outcome

The live `/AirportSecurity/AirportSecurity` map now contains a saved, idempotent
airport presentation pass layered over the existing seven-shift Terminal
Lockdown game. The pass adds explicit Fortnite-native surface materials, a full
runway window wall, a clean stylized passenger jet, terminal seating and queue
furniture, expanded checkpoint/bag/document/decision staging, and stronger
physical support spaces for the restricted corridor, power room, security
office, and detention area.

This is a substantial role-and-composition match, not a pixel-identical remake
of the supplied Roblox references. The original UEFN gameplay systems and
device wiring remain the source of truth.

## Saved environment state

- Final builder summary: `created=0`, `updated=177`, `deleted=0`,
  `expected=177`, `actor_count=274`, `saved=true`.
- The final idempotency run created no duplicate `TL_ART_` labels.
- The previous torn/broken aircraft kit was removed and replaced by a clean
  primitive passenger-jet silhouette with fuselage, wings, engines, tail,
  cockpit, door, and eight side windows.
- The approved Agency security scanner is staged at the bag/checkpoint area.
- All surface material assignments use explicit native asset paths registered
  in `Content/Python/build_reference_match_pass.py`.

## Live runtime validation

The automated replay switch was enabled only for validation, then restored to
`false`, compiled, pushed, and activated. The second replay run completed the
following production-handler branches with committed state:

- Shift 1 body scan and clear.
- Shift 3 body, bag, document, secondary, custody, and clear.
- Detention intake and duplicate-action guard.
- Shift 5 power outage and restore.
- Shift 7 detected-boss victory and missed-boss victory.
- Claim release/reclaim and duplicate-decision guard.
- Emergency timeout penalty and recovery.
- False detention, runner capture, runner escape, resistant response/custody,
  and a clean post-branch case.
- Normal reset to waiting after each replay suite.

No `VerseRuntimeError`, `Script error`, `LogVerse: Error`, or ensure failure was
present in the inspected final replay log range. The connected one-client
session reported 60 FPS, 29 ms ping, and 0% packet loss during observation.

The production-default compile then succeeded, all pending Verse changes were
pushed, content activation succeeded, and a follow-up launch produced no QA
markers, confirming `AutomatedReplayEnabled = false` in the shipped state.

## Known limits

- Visual fidelity is partial: the build captures airport roles, layout cues,
  glazing, furniture, checkpoint hierarchy, and the aircraft view, but does not
  reproduce the source game's art one-to-one.
- The jet is a stylized approved-primitive construction, not a bespoke or exact
  aircraft asset.
- Support-room screenshots are less representative than the main-terminal,
  checkpoint, and runway views.
- One connected client was used. Real two-client contention and owner-loss
  behavior remain unproven.
- A UEFN Project Validation command was not exposed in the installed editor
  menus during this pass; Verse compile/push, live activation, builder
  idempotency, and runtime log inspection were completed instead.
- No memory calculation was run. The actor count and live FPS are evidence, not
  a memory-budget certification.

## Evidence paths

- `proof/05_reference_main_terminal.png`
- `proof/06_reference_checkpoint.png`
- `proof/07_reference_runway_aircraft.png`
- `proof/08_reference_restricted_corridor.png`
- `proof/09_reference_power_room.png`
- `proof/10_reference_detention.png`

The proof directory is in the Codex workspace, outside the live UEFN Git
repository, so screenshots do not inflate the project checkpoint.
