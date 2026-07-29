# Asset placement ledger

Status values: `UNSEEN`, `CANDIDATE`, `FOUND`, `LOADABLE`,
`REFERENCE_ALLOWED`, `PLACEMENT_METHOD_SUPPORTED`, `PLACED_IN_TEST`, `COOKED`,
`SESSION_VERIFIED`, `APPROVED_FOR_PRODUCTION`, `REJECTED`,
`NEEDS_EDITOR_VERIFICATION`.

| Purpose | Exact path | Type/class | Source | Existing | Modifiable | Collision checked | Intended placement method | Evidence | Status | Fallback |
|---|---|---|---|---|---|---|---|---|---|---|
| Graybox block | `/Game/Creative/Sets/PropSets/Primitives/Rounds/Mesh/CP_L_Squared_Cube_Full` | Static mesh on `FortStaticMeshActor` | Fortnite-provided | Yes | Read-only asset; actor modifiable | Pending | Editor Python: spawn `FortStaticMeshActor`, assign mesh, scale, save | Same exact method worked in another project, which is discovery evidence only; this project still requires its own placement/validation/session proof | CANDIDATE | Existing GridPlane floor + native device-only slice |
| Graybox material: navy/black | `/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_Marble_Black` | Material instance | Fortnite-provided | Yes | Read-only | Pending | Assign material slot 0 to the proof block | Project-local proof pending | CANDIDATE | Default mesh material |
| Graybox material: cyan | `/Game/Creative/Sets/PropSets/Primitives/Customization/Materials/MI_Primitive_WorldGrid_NeuralCosmos` | Material instance | Fortnite-provided | Yes | Read-only | Pending | Assign to placed primitive actor | Project-local proof pending | CANDIDATE | Default mesh material + billboard text |
| Player interaction | `/CreativeCoreDevices/Device_Button_V2.Device_Button_V2_C` | Creative Button actor / `button_device` | Fortnite-provided | Yes | Actor options modifiable | Pending | Editor-spawned native device, editable Verse reference | Local class/API confirmed; placement/save/session pending | LOADABLE | Contextual player interaction in a single start button |
| HUD status | `/CreativeCoreDevices/Device_HUDMessage_V2.Device_HUDMessage_V2_C` | HUD Message actor / `hud_message_device` | Fortnite-provided | Yes | Actor options modifiable | N/A | Editor-spawned native device, editable Verse reference | Local class/API confirmed; placement/save/session pending | LOADABLE | Billboard and Verse log output |
| Passenger visuals | Not selected | NPC Character Definition/spawner chain | Unknown | No | Unknown | Pending | Pre-placed NPC Spawner + editable reference | No character definition is approved yet | NEEDS_EDITOR_VERIFICATION | Button/HUD evidence case preserves gameplay |
| Luggage visual | Not selected | Pre-placed pooled prop | Unknown | No | Unknown | Pending | Pre-placed pool only | No candidate approved | NEEDS_EDITOR_VERIFICATION | Static station and large-region UI/HUD evidence |

No item in this ledger is treated as usable merely because it loads.

