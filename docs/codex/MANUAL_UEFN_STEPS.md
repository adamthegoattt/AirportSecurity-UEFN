# Manual UEFN steps

This file is updated from actual placed actors. It is not evidence that pending
steps are complete.

## Current exact next actions

1. Restart UEFN so the newly enabled Python integration loads.
2. Execute the reviewed bridge bootstrap
   `C:\Users\chris\Documents\fortnite\bootstrap_uefn_bridge_buffered.py`.
3. Run the project-local one-block placement proof.
4. Save the current map, run project validation, and record its exact output.
5. Copy `terminal_lockdown.verse` into the live project `Content` folder and use
   **Verse > Build Verse Code**.
6. Place `TL_GameManager` only after the custom Verse class compiles.
7. Wire every editable reference in the generated manifest; do not leave native
   device references at class defaults.
8. Launch Session and run `S-01` from `TEST_MATRIX.md`.

## Planned wiring manifest

| Verse actor | Class | Editable field | Expected actor/device | Required | Test |
|---|---|---|---|---|---|
| `TL_GameManager` | `terminal_lockdown_controller` | `StartButton` | `TL_StartShift` / `button_device` | Yes | Starts one briefing |
| `TL_GameManager` | `terminal_lockdown_controller` | `ScanButton` | `TL_ScanTraveler` / `button_device` | Yes | Reveals body evidence once |
| `TL_GameManager` | `terminal_lockdown_controller` | `DocumentButton` | `TL_CheckDocuments` / `button_device` | Yes | Reveals document evidence once |
| `TL_GameManager` | `terminal_lockdown_controller` | `ClearButton` | `TL_ClearTraveler` / `button_device` | Yes | Guarded decision transaction |
| `TL_GameManager` | `terminal_lockdown_controller` | `SecondaryButton` | `TL_SecondaryTraveler` / `button_device` | Yes | Adds definitive evidence/time cost |
| `TL_GameManager` | `terminal_lockdown_controller` | `DetainButton` | `TL_DetainTraveler` / `button_device` | Yes | Guarded detention transaction |
| `TL_GameManager` | `terminal_lockdown_controller` | `StatusHUD` | `TL_StatusHUD` / `hud_message_device` | Yes | Context and audit feedback |

