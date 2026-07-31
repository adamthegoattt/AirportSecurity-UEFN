# Verse production invariants

These rules apply to Verse gameplay and all per-player UI in this directory.

- The active case owns its immutable identity, claim stage, evidence, destinations, and final-accounting state. A player may claim only the active unresolved case through a real station interaction.
- Guard every delayed coroutine and movement completion with run generation, case ID, and relevant emergency generation. Stale work must exit without changing a newer case.
- Resolve each case exactly once. Atomically guard decisions, custody, final accounting, rewards, penalties, queue advancement, detention intake, and results transitions against duplicates.
- Evidence requires the corresponding physical/player interaction. Never auto-complete evidence when UI opens, a timer expires, or a player approaches a station.
- Track UI per player. Remove every canvas and subscription on close, case change, phase change, reset, and player removal; prevent duplicate opens and stale callbacks.
- On disconnect, release owned claims safely, clean that player's UI, and leave the case recoverable without duplicating outcomes. A rejoining or join-in-progress player must receive current authoritative phase, case, station, emergency, and HUD state.
- Passenger, bag, Secondary, and detention transitions must remain case-linked. Never duplicate rewards, penalties, case advancement, passenger movement, detention, or cleanup.
- Keep production flags and development replay disabled except for an intentional local QA run; restore, compile, save, and live-test normal mode afterward.
