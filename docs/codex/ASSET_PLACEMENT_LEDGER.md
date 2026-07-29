# Asset placement ledger

Last reconciled: 2026-07-28 PDT

Status values: `CANDIDATE`, `LOADABLE`, `PLACED_IN_TEST`, `COOKED`,
`SESSION_VERIFIED`, `APPROVED_FOR_PRODUCTION`, `REJECTED`,
`NEEDS_EDITOR_VERIFICATION`.

| Purpose | Exact path / class | Source | Exact placement method | Save / validation / session evidence | Status | Fallback |
|---|---|---|---|---|---|---|
| Terminal architecture and physical parcels | Existing validated actor `GridPlane1`; class reported in the level as `/Game/Valkyrie/GridPlane.GridPlane_C` | Existing project/Fortnite-provided actor instance | `build_terminal_lockdown.py` duplicates `GridPlane1`, applies center/scale, stable `TL_` label, and saves the map/packages | 118 production instances; complete build saved; idempotency rerun created 0 and updated 143; local validation/cook/activation and live session passed | `APPROVED_FOR_PRODUCTION` for this exact duplicate/transform method | Keep existing production graybox until a replacement passes equal evidence |
| Player interactions | `/CreativeCoreDevices/Device_Button_V2.Device_Button_V2_C` / Verse `button_device` | Fortnite-provided | Editor Python spawn by exact class; stable label; editable reference on `TL_Controller` | 12 saved devices; Verse compile and activation passed; production handlers used by live replay | `APPROVED_FOR_PRODUCTION` for the current Button workflow | Preserve HUD/world-board fallback prompts |
| HUD status | `/CreativeCoreDevices/Device_HUDMessage_V2.Device_HUDMessage_V2_C` / `hud_message_device` | Fortnite-provided | Editor Python spawn; one editable controller reference | Saved, compiled, activated, and displayed during the live replay | `APPROVED_FOR_PRODUCTION` | Billboard status boards |
| World evidence/signage | `/CreativeCoreDevices/Device_Billboard_V2.Device_Billboard_V2_C` / `billboard_device` | Fortnite-provided | Editor Python spawn; seven editable controller references; runtime text update | Saved and reflected as 7 unique actors; compiled/activated; current case, bag, document, power, custody, and emergency text exercised | `APPROVED_FOR_PRODUCTION` | HUD-only text |
| Physical passenger fallback | `/CRD_Mannequin/Device_Character_V2.Device_Character_V2_C` / `character_device` | Fortnite-provided | Four pre-placed Character devices; controller `Show/Hide/MoveTo`; stale case/run guards | Saved and reflected as 4 unique devices; clear, detention, response, intake, cell, and reset paths exercised by production replay | `APPROVED_FOR_PRODUCTION` as current fallback | Keep fixed queue/active Character system if an NPC replacement fails |
| Verse controller | `/AirportSecurity/_Verse.terminal_lockdown_controller` | Project-owned compiled Verse | Spawn from compiled Verse class; stable `TL_Controller`; editable references wired in UEFN | Successful Verse builds, push/refresh, content activation, two extended live replays, then normal-mode reload with QA false | `APPROVED_FOR_PRODUCTION` | Restore the latest validated local Git checkpoint without destructive reset |
| Bespoke airport meshes/materials/audio/VFX | Not selected | Unknown | Must prove exact candidate and method in one disposable test before production | No replacement candidate has completed the required chain | `NEEDS_EDITOR_VERIFICATION` | Current validated GridPlane/devices/boards |
| NPC Spawner / Character Definition | Not selected | Unknown | Required proof: definition assignment -> spawner -> navigation -> save -> validation -> live session -> replication -> reset | Not implemented; current Character fallback remains authoritative | `NEEDS_EDITOR_VERIFICATION` | Four Character devices |
| Combat AI response | Not selected | Unknown | Required proof: exact spawner/AI class -> loadout -> activation -> cleanup -> multiplayer | Not implemented; resistant branch uses a response interaction and controlled movement | `NEEDS_EDITOR_VERIFICATION` | Current response Button/custody flow |

No path or class is considered production-approved merely because it loads.
Approval above applies only to the exact placement/assignment methods that were
saved, validated, activated, and exercised at the checkpoint.
