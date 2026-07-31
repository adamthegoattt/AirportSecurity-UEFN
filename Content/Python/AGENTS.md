# Environment builder rules

These rules apply to UEFN Python builders in this directory.

- Preserve intentional manual production work and existing device/Verse references.
- After editing a builder, run that exact live-project script through the editor, save the level and dirty packages, and confirm generated map/external-actor changes in Git.
- Rerun it to prove idempotency: no duplicate labels, no unintended creates, and a stable actor count unless the change intentionally alters inventory.
- A builder may update or delete only actors inside its explicit owned naming scope. Never remove unrelated or manually placed actors.
- Prefer approved native Fortnite/UEFN assets over visible primitive cubes. Prove new asset classes through placement, save, validation, cook/session, and cleanup before adopting them.
- Keep the scanner floor flush, routes walkable without jumping, collision intentional, and production/debug presentation separated.
