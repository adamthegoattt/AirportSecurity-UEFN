using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Terminal Lockdown's authoritative inspection state machine. Device/HUD
# controls remain as reliable fallbacks while pre-placed Character devices,
# physical luggage, world evidence boards, detention, and power response make
# the normal path spatial and player-visible.
terminal_lockdown_controller := class(creative_device):

    @editable
    StartButton:button_device = button_device{}

    @editable
    ScanButton:button_device = button_device{}

    @editable
    BagButton:button_device = button_device{}

    @editable
    DocumentButton:button_device = button_device{}

    @editable
    ClearButton:button_device = button_device{}

    @editable
    SecondaryButton:button_device = button_device{}

    @editable
    DetainButton:button_device = button_device{}

    @editable
    ResponseButton:button_device = button_device{}

    @editable
    UpgradeButton:button_device = button_device{}

    @editable
    CustodyButton:button_device = button_device{}

    @editable
    PowerButton:button_device = button_device{}

    @editable
    PowerBackupButton:button_device = button_device{}

    @editable
    PowerRestartButton:button_device = button_device{}

    @editable
    SecondaryPassengerButton:button_device = button_device{}

    @editable
    SecondaryBagButton:button_device = button_device{}

    @editable
    SecondaryRecordsButton:button_device = button_device{}

    @editable
    StatusHUD:hud_message_device = hud_message_device{}

    @editable
    PassengerQueue1:character_device = character_device{}

    @editable
    PassengerQueue2:character_device = character_device{}

    @editable
    PassengerQueue3:character_device = character_device{}

    @editable
    PassengerActive:character_device = character_device{}

    @editable
    JailOccupant:character_device = character_device{}

    @editable
    BagPropSmall:creative_prop = creative_prop{}

    @editable
    BagPropMedium:creative_prop = creative_prop{}

    @editable
    BagPropHardShell:creative_prop = creative_prop{}

    @editable
    CheckpointBoard:billboard_device = billboard_device{}

    @editable
    CaseBoard:billboard_device = billboard_device{}

    @editable
    BagBoard:billboard_device = billboard_device{}

    @editable
    DocumentBoard:billboard_device = billboard_device{}

    @editable
    PowerBoard:billboard_device = billboard_device{}

    @editable
    CustodyBoard:billboard_device = billboard_device{}

    @editable
    CellBoard:billboard_device = billboard_device{}

    @editable
    EmergencyBoard:billboard_device = billboard_device{}

    @editable
    ClearBoard:billboard_device = billboard_device{}

    @editable
    SecondaryBoard:billboard_device = billboard_device{}

    @editable
    DetainBoard:billboard_device = billboard_device{}

    @editable
    ResponseGranter:item_granter_device = item_granter_device{}

    @editable
    ResponseRemover:item_remover_device = item_remover_device{}

    @editable
    ResponseRemote:signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    ResponseAlarm:audio_player_device = audio_player_device{}

    @editable
    ScannerStartAudio:audio_player_device = audio_player_device{}

    @editable
    ScannerResultAudio:audio_player_device = audio_player_device{}

    @editable
    BagScanAudio:audio_player_device = audio_player_device{}

    @editable
    DecisionPressAudio:audio_player_device = audio_player_device{}

    @editable
    PositiveAudio:audio_player_device = audio_player_device{}

    @editable
    NegativeAudio:audio_player_device = audio_player_device{}

    @editable
    ResponseLightA:customizable_light_device = customizable_light_device{}

    @editable
    ResponseLightB:customizable_light_device = customizable_light_device{}

    @editable
    ResponseLoadoutBoard:billboard_device = billboard_device{}

    @editable
    CasesPerShift:int = 3

    @editable
    EmergencyTimeoutSeconds:float = 45.0

    @editable
    CustodyProximityRadius:float = 600.0

    @editable
    RunnerCaptureRadius:float = 850.0

    @editable
    ResponseProximityRadius:float = 850.0

    @editable
    ResponseTimeoutSeconds:float = 30.0

    @editable
    ClaimInactivitySeconds:float = 90.0

    @editable
    SecondaryScreeningCost:int = 25

    # Production tuning hook used by the staged scanner. The between-shift
    # checkpoint capacitor shortens this second sweep stage for the run.
    @editable
    ScannerSweepSeconds:float = 1.4

    @editable
    DebugEnabled:logic = false

    # Production runs wait for an officer to use the physical START SHIFT
    # control. This remains an opt-in convenience for isolated local testing.
    @editable
    AutoStartEnabled:logic = true

    # Development-only end-to-end replay. Keep false in production. When
    # enabled, it invokes the same public interaction handlers used by players
    # and writes [QA] markers to the live Verse log.
    @editable
    AutomatedReplayEnabled:logic = false

    var Phase:terminal_game_phase = terminal_game_phase.Waiting
    var BossBranch:terminal_boss_branch = terminal_boss_branch.None
    var RunGeneration:int = 0
    var EmergencyGeneration:int = 0
    var Shift:int = 0
    var CasesInShift:int = 0
    var TotalCasesResolved:int = 0
    var ShiftElapsedSeconds:int = 0
    var CurrentCaseId:int = 0
    var CurrentTemplate:int = 0
    var TeamIntegrity:int = 100
    var TeamRisk:int = 0
    var TeamCash:int = 0
    var CorrectDecisions:int = 0
    var FalseDetentions:int = 0
    var MissedThreats:int = 0
    var BodyChecked:logic = false
    var BagChecked:logic = false
    var DocumentsChecked:logic = false
    var SecondaryChecked:logic = false
    var SecondaryCostPaid:logic = false
    var SecondaryFeeAmount:int = 0
    var SecondaryActionStage:int = 0
    var SecondaryPassengerChecked:logic = false
    var SecondaryBagChecked:logic = false
    var SecondaryRecordsChecked:logic = false
    var SecondaryPassengerRegions:int = 0
    var SecondaryBagHotspots:int = 0
    var PassengerReadyForScan:logic = false
    var ScanInProgress:logic = false
    var BagScanInProgress:logic = false
    var SecondaryPassengerReady:logic = false
    var SecondaryBagReady:logic = false
    var PassengerAtIntake:logic = false
    var ActivePassengerMoveGeneration:int = 0
    var PassengerGeneration:int = 0
    var PassengerLocation:terminal_passenger_location = terminal_passenger_location.Hidden
    var PassengerTarget:terminal_passenger_location = terminal_passenger_location.Hidden
    var BagLocation:terminal_bag_location = terminal_bag_location.Hidden
    var BodyObservation:terminal_body_observation = terminal_body_observation.None
    var BagObservation:terminal_bag_observation = terminal_bag_observation.None
    var DocumentObservation:terminal_document_observation = terminal_document_observation.None
    var ManualSearchRequested:logic = false
    var PassengerRouteRetries:int = 0
    var PassengerTeleportRecoveries:int = 0
    var PassengerHideRecoveries:int = 0
    var BagRouteRetries:int = 0
    var BagTeleportRecoveries:int = 0
    var BagHideRecoveries:int = 0
    var ResolutionCommitted:logic = false
    var CaseCompletionCommitted:logic = false
    var CustodyCommitted:logic = false
    var FinalCaseAccountingCommitted:logic = false
    var RunUpgradePurchased:logic = false
    var ScannerUpgradeLevel:int = 0
    var PayoutUpgradeLevel:int = 0
    var EmergencyUpgradeLevel:int = 0
    var UpgradeBreakResolved:logic = false
    var PowerRepairStage:int = 0
    var PowerRepairCommitted:logic = false
    var PowerOnline:logic = true
    var CurrentCustodyMode:int = 0
    var ClaimOwner:?player = false
    var ClaimGeneration:int = 0
    var ClaimStage:terminal_claim_stage = terminal_claim_stage.None
    var QueueFrontIndex:int = 0
    var ActivePassengerSlot:int = 0
    var QueueGeneration:int = 0
    var ScannerGeneration:int = 0
    var BagGeneration:int = 0
    var ActiveBagIndex:int = 0
    var DocumentGeneration:int = 0
    var ResponseGeneration:int = 0
    var CurrentDestination:terminal_case_destination = terminal_case_destination.None
    var ActiveCase:terminal_active_case = terminal_active_case{}
    var DocumentRootUI:[player]canvas = map{}
    var DocumentOpenCase:[player]int = map{}
    var DocumentOpenGeneration:[player]int = map{}
    var BodyScanRootUI:[player]canvas = map{}
    var BodyScanOpenGeneration:[player]int = map{}
    var XRayRootUI:[player]canvas = map{}
    var XRayOpenGeneration:[player]int = map{}
    var PersistentHUDRoot:[player]canvas = map{}
    var PersistentHUDText:[player]text_block = map{}
    var UpgradeRootUI:[player]canvas = map{}
    var UpgradeOpenShift:[player]int = map{}
    var QueueFrontMarker:vector3 = vector3{}
    var QueueMiddleMarker:vector3 = vector3{}
    var QueueRearMarker:vector3 = vector3{}
    var PowerHomePosition:vector3 = vector3{}
    var PowerHomeRotation:rotation = IdentityRotation()

    OnBegin<override>()<suspends>:void=
        StartButton.InteractedWithEvent.Subscribe(OnStartButton)
        ScanButton.InteractedWithEvent.Subscribe(OnScanButton)
        BagButton.InteractedWithEvent.Subscribe(OnBagButton)
        DocumentButton.InteractedWithEvent.Subscribe(OnDocumentButton)
        ClearButton.InteractedWithEvent.Subscribe(OnClearButton)
        SecondaryButton.InteractedWithEvent.Subscribe(OnSecondaryButton)
        DetainButton.InteractedWithEvent.Subscribe(OnDetainButton)
        ResponseButton.InteractedWithEvent.Subscribe(OnResponseButton)
        ResponseRemote.PrimarySignalEvent.Subscribe(OnResponseRemote)
        UpgradeButton.InteractedWithEvent.Subscribe(OnUpgradeButton)
        CustodyButton.InteractedWithEvent.Subscribe(OnCustodyButton)
        PowerButton.InteractedWithEvent.Subscribe(OnPowerButton)
        PowerBackupButton.InteractedWithEvent.Subscribe(OnPowerBackupButton)
        PowerRestartButton.InteractedWithEvent.Subscribe(OnPowerRestartButton)
        SecondaryPassengerButton.InteractedWithEvent.Subscribe(OnSecondaryPassengerButton)
        SecondaryBagButton.InteractedWithEvent.Subscribe(OnSecondaryBagButton)
        SecondaryRecordsButton.InteractedWithEvent.Subscribe(OnSecondaryRecordsButton)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        CaptureRouteMarkers()
        ConfigureButtons()
        ConfigurePhysicalPresentation()
        spawn{PersistentHUDLoop()}
        if (AutoStartEnabled?):
            spawn{AutoStartWaitingRun()}
        if (AutomatedReplayEnabled?):
            spawn{RunAutomatedReplay()}
        ShowAll("TERMINAL LOCKDOWN | Press START SHIFT at the briefing desk.", 8.0)
        TerminalLog(DebugEnabled, "[BOOT] Controller ready; waiting for players")

    RunAutomatedReplay()<suspends>:void=
        # The disabled harness intentionally starts the same physical run that
        # an officer starts at the briefing desk; production no longer begins
        # a shift automatically when a player joins.
        Sleep(1.0)
        for (Player : GetPlayspace().GetPlayers()):
            OnStartButton(Player)
            Sleep(5.5)
            TerminalLog(true, "[QA] Automated replay begin")

            # Shift 1: physical passenger, body evidence, and clear decision.
            OnScanButton(Player)
            Sleep(2.25)
            Sleep(2.25)
            PrimeAutomatedDecision(false, false)
            OnClearButton(Player)
            Sleep(7.0)
            TerminalLog(true, "[QA] Shift 1 body/clear path complete")

            # Shift 3: force a policy hold so body, linked bag, documents, and
            # secondary resolution all execute through the production handlers.
            set Shift = 3
            set CasesInShift = 0
            set CurrentCaseId += 1
            set CurrentTemplate = 3
            set BodyChecked = false
            set BagChecked = false
            set DocumentsChecked = false
            set SecondaryChecked = false
            set ResolutionCommitted = false
            set ClaimOwner = false
            set Phase = terminal_game_phase.CaseReady
            set PassengerReadyForScan = true
            SyncActiveCase()
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnSecondaryButton(Player)
            Sleep(9.0)
            PrimeAutomatedSecondaryFinal()
            OnCustodyButton(Player)
            OnClearButton(Player)
            Sleep(7.0)
            TerminalLog(true, "[QA] Shift 3 body/bag/doc/secondary path complete")

            # A correct detention must enter physical custody and award intake
            # exactly once; the second call verifies the duplicate guard.
            set Shift = 3
            set CasesInShift = 0
            set CurrentCaseId += 1
            set CurrentTemplate = 4
            set BodyChecked = false
            set BagChecked = false
            set DocumentsChecked = false
            set SecondaryChecked = false
            set ResolutionCommitted = false
            set CustodyCommitted = false
            set PassengerAtIntake = false
            set ClaimOwner = false
            set Phase = terminal_game_phase.CaseReady
            set PassengerReadyForScan = true
            SyncActiveCase()
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            Sleep(3.5)
            OnDetainButton(Player)
            Sleep(9.0)
            OnCustodyButton(Player)
            OnCustodyButton(Player)
            Sleep(5.0)
            TerminalLog(true, "[QA] Detention intake and duplicate guard complete")

            # Shift 5's real emergency contract: scanner disabled, an attempted
            # scan rejected, utility power restored, and upgrade break reached.
            set Shift = 5
            set CasesInShift = CasesPerShift
            BeginEmergency()
            Sleep(1.0)
            OnScanButton(Player)
            OnPowerButton(Player)
            Sleep(0.25)
            OnPowerButton(Player)
            Sleep(0.25)
            OnPowerButton(Player)
            Sleep(0.5)
            set TeamCash += 500
            PurchaseUpgrade(Player, 1)
            Sleep(0.5)
            TerminalLog(
                true,
                "[QA] Shift 5 staged power restore + upgrade complete|PowerStage={PowerRepairStage}|ScannerUpgrade={ScannerUpgradeLevel}|Cash={TeamCash}"
            )

            # Final detected branch: fully checked disguise, detention decision,
            # four response stages, victory, then clean replay reset.
            set Shift = 7
            set CasesInShift = 2
            set CurrentCaseId += 1
            set CurrentTemplate = 12
            set BodyChecked = true
            set BagChecked = true
            set DocumentsChecked = true
            set SecondaryChecked = false
            set ResolutionCommitted = false
            set FinalCaseAccountingCommitted = false
            set ClaimOwner = false
            set Phase = terminal_game_phase.AwaitingDecision
            SyncActiveCase()
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            TerminalLog(true, "[QA] Final detected accounting|Resolved={TotalCasesResolved}|Correct={CorrectDecisions}|Missed={MissedThreats}")
            Sleep(1.0)
            OnPowerButton(Player)
            OnResponseButton(Player)
            OnResponseRemote(Player)
            Sleep(4.1)
            OnCustodyButton(Player)
            Sleep(2.1)
            TerminalLog(true, "[QA] Shift 7 boss victory complete")
            OnResponseButton(Player)
            TerminalLog(true, "[QA] Replay reset complete")

            # One-client deterministic recovery harness. This is not a real
            # multiplayer test: it proves the production claim can be released,
            # reclaimed, and resolved once, while a duplicate decision cannot
            # advance progress again.
            OnStartButton(Player)
            Sleep(1.0)
            set PassengerReadyForScan = true
            OnScanButton(Player)
            Sleep(2.25)
            Sleep(2.25)
            set ClaimOwner = false
            TerminalLog(true, "[QA2] Simulated owner loss released CaseId={CurrentCaseId}")
            PrimeAutomatedDecision(false, false)
            OnClearButton(Player)
            OnClearButton(Player)
            Sleep(7.0)
            TerminalLog(true, "[QA2] Claim release/reclaim and duplicate decision guard complete")

            # Exercise the missed final-threat branch through the same decision
            # and response handlers used by players.
            set Shift = 7
            set CasesInShift = 2
            set CurrentCaseId += 1
            set CurrentTemplate = 12
            set BodyChecked = true
            set BagChecked = true
            set DocumentsChecked = true
            set SecondaryChecked = false
            set ResolutionCommitted = false
            set FinalCaseAccountingCommitted = false
            set ClaimOwner = false
            set Phase = terminal_game_phase.AwaitingDecision
            SyncActiveCase()
            PrimeAutomatedDecision(true, true)
            OnClearButton(Player)
            TerminalLog(true, "[QA2] Final missed accounting|Resolved={TotalCasesResolved}|Correct={CorrectDecisions}|Missed={MissedThreats}")
            Sleep(1.0)
            OnPowerButton(Player)
            OnResponseButton(Player)
            OnResponseRemote(Player)
            Sleep(4.1)
            OnCustodyButton(Player)
            Sleep(2.1)
            TerminalLog(true, "[QA2] Shift 7 missed boss branch reached victory")
            OnResponseButton(Player)

            # Run the real emergency-timeout handler with a short QA wait. The
            # production BeginEmergency task still uses the editable 45-second
            # timeout; its stale callback becomes harmless after this resolves.
            OnStartButton(Player)
            set Shift = 6
            set CasesInShift = CasesPerShift
            BeginEmergency()
            CurrentQAGeneration := EmergencyGeneration
            spawn{EmergencyTimeout(CurrentQAGeneration, 1.0)}
            Sleep(2.0)
            TerminalLog(true, "[QA2] Emergency timeout penalty and recovery complete")
            ResetToWaiting()
            TerminalLog(true, "[QA2] Extended replay complete; returned to waiting")

            # False detention through the production inspection, decision,
            # departure, penalty, and next-case handlers.
            OnStartButton(Player)
            set Shift = 3
            set CasesInShift = 0
            PrepareNextCase()
            Sleep(3.5)
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            FalseDetentionResolved := WaitForCaseResolution(1, 15.0)
            if (not FalseDetentionResolved?):
                TerminalLog(true, "[QA3 FAIL] False detention did not resolve before timeout")
            TerminalLog(
                true,
                "[QA3] False detention complete|FalseDetentions={FalseDetentions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()

            # Runner capture through the real Shift 6 template schedule,
            # DETAIN intercept, physical intake, and exactly-once custody path.
            OnStartButton(Player)
            set Shift = 6
            set CasesInShift = 0
            PrepareNextCase()
            Sleep(3.5)
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            Sleep(1.0)
            OnDetainButton(Player)
            RunnerAtIntake := WaitForCustodyIntake(35.0)
            if (RunnerAtIntake?):
                OnCustodyButton(Player)
                OnCustodyButton(Player)
            else:
                TerminalLog(true, "[QA3 FAIL] Runner never reached detention intake")
            RunnerCaptureResolved := WaitForCaseResolution(1, 15.0)
            if (not RunnerCaptureResolved?):
                TerminalLog(true, "[QA3 FAIL] Runner capture did not resolve before timeout")
            TerminalLog(
                true,
                "[QA3] Runner capture complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()

            # Runner escape through the real ten-second movement window and
            # one failure consequence. No intercept is submitted.
            OnStartButton(Player)
            set Shift = 6
            set CasesInShift = 0
            PrepareNextCase()
            Sleep(3.5)
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            RunnerEscapeResolved := WaitForCaseResolution(1, 40.0)
            if (not RunnerEscapeResolved?):
                TerminalLog(true, "[QA3 FAIL] Runner escape did not resolve before timeout")
            TerminalLog(
                true,
                "[QA3] Runner escape complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()

            # Resistant response through the real Shift 6 template schedule,
            # event start, cleanup, physical intake, and custody handlers. The
            # disabled-by-default harness resolves the event directly because
            # it cannot reposition its only client into the response room.
            OnStartButton(Player)
            set Shift = 6
            set CasesInShift = 1
            PrepareNextCase()
            Sleep(3.5)
            OnScanButton(Player)
            Sleep(2.25)
            OnBagButton(Player)
            Sleep(2.9)
            Sleep(2.25)
            OnDocumentButton(Player)
            Sleep(4.0)
            PrimeAutomatedDecision(true, true)
            OnDetainButton(Player)
            Sleep(9.0)
            SecureResponseThreat(Player)
            ResistantAtIntake := WaitForCustodyIntake(35.0)
            if (ResistantAtIntake?):
                OnCustodyButton(Player)
                OnCustodyButton(Player)
            else:
                TerminalLog(true, "[QA3 FAIL] Resistant suspect never reached detention intake")
            ResistantResponseResolved := WaitForCaseResolution(1, 15.0)
            if (not ResistantResponseResolved?):
                TerminalLog(true, "[QA3 FAIL] Resistant response did not resolve before timeout")
            TerminalLog(
                true,
                "[QA3] Resistant response complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )

            # A final clean run proves that branch-specific phase, custody,
            # passenger, claim, and board state does not leak across reset.
            ResetToWaiting()
            OnStartButton(Player)
            Sleep(3.5)
            OnScanButton(Player)
            Sleep(2.25)
            Sleep(2.25)
            PrimeAutomatedDecision(false, false)
            OnClearButton(Player)
            CleanCaseResolved := WaitForCaseResolution(1, 15.0)
            if (not CleanCaseResolved?):
                TerminalLog(true, "[QA3 FAIL] Post-branch clean case did not resolve before timeout")
            TerminalLog(
                true,
                "[QA3] Post-branch clean case complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()
            TerminalLog(true, "[QA3] Failure-branch replay complete; returned to waiting")
            return

    # The production scanners now require explicit player UI observations.
    # The disabled replay still exercises their timing and movement, then
    # establishes the same authoritative post-observation state before it
    # invokes the public decision handlers. This keeps QA deterministic without
    # adding a second gameplay path or weakening normal interaction checks.
    PrimeAutomatedDecision(WithBag:logic, WithDocuments:logic):void=
        set BodyChecked = true
        set BodyObservation = terminal_body_observation.NoAnomaly
        set BagChecked = WithBag
        if (WithBag?):
            set BagObservation = terminal_bag_observation.ClearImage
            set BagLocation = terminal_bag_location.ConveyorExit
        else:
            set BagObservation = terminal_bag_observation.None
            set BagLocation = terminal_bag_location.Hidden
        set DocumentsChecked = WithDocuments
        if (WithDocuments?):
            set DocumentObservation = terminal_document_observation.NoVisibleIssue
        else:
            set DocumentObservation = terminal_document_observation.None
        set ManualSearchRequested = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set PassengerReadyForScan = false
        set PassengerLocation = terminal_passenger_location.Decision
        set PassengerTarget = terminal_passenger_location.Decision
        set Phase = terminal_game_phase.AwaitingDecision
        set ResolutionCommitted = false
        set ClaimOwner = false
        SyncActiveCase()
        RefreshDecisionControls()

    PrimeAutomatedSecondaryFinal():void=
        set SecondaryChecked = true
        set SecondaryPassengerChecked = true
        set SecondaryBagChecked = true
        set SecondaryRecordsChecked = true
        set PassengerLocation = terminal_passenger_location.SecondaryPassenger
        set PassengerTarget = terminal_passenger_location.SecondaryPassenger
        set BagLocation = terminal_bag_location.SecondaryTable
        set Phase = terminal_game_phase.AwaitingDecision
        set ResolutionCommitted = false
        set ClaimOwner = false
        SyncActiveCase()
        SetSecondaryFinalControls()

    WaitForCaseResolution(TargetResolved:int, MaxWaitSeconds:float)<suspends>:logic=
        var Elapsed:float = 0.0
        loop:
            if (TotalCasesResolved >= TargetResolved):
                return true
            if (Elapsed >= MaxWaitSeconds):
                return false
            Sleep(0.5)
            set Elapsed += 0.5

    WaitForCustodyIntake(MaxWaitSeconds:float)<suspends>:logic=
        var Elapsed:float = 0.0
        loop:
            if (PassengerAtIntake?):
                return true
            if (Elapsed >= MaxWaitSeconds):
                return false
            Sleep(0.5)
            set Elapsed += 0.5

    AutoStartWaitingRun()<suspends>:void=
        Sleep(3.0)
        if (Phase = terminal_game_phase.Waiting):
            for (Player : GetPlayspace().GetPlayers()):
                PositionOfficerAtCheckpoint(Player)
                ShowAgent(Player, "Officer online. Opening Shift 1...", 3.0)
                OnStartButton(Player)
                return

    PositionOfficerAtCheckpoint(Player:player):void=
        if (Character := Player.GetFortCharacter[]):
            WorkstationPosition := vector3{X := 800.0, Y := -2100.0, Z := 100.0}
            WorkstationFacing := MakeRotationFromYawPitchRollDegrees(90.0, 0.0, 0.0)
            if (Character.TeleportTo[WorkstationPosition, WorkstationFacing]):
                TerminalLog(DebugEnabled, "[PLAYER] Officer positioned at checkpoint workstation")

    PositionOfficerAtCustody(Agent:agent):logic=
        if (Character := Agent.GetFortCharacter[]):
            IntakeDevicePosition := CustodyButton.GetTransform().Translation
            IntakeOfficerPosition := vector3{
                # The custody device and its pedestal are mounted on the open
                # platform. Keep the officer and escorted suspect on opposite
                # sides so neither blocks the other's verified arrival.
                X := IntakeDevicePosition.X + 180.0,
                Y := IntakeDevicePosition.Y,
                Z := IntakeDevicePosition.Z
            }
            IntakeFacing := MakeRotationFromYawPitchRollDegrees(0.0, 0.0, 0.0)
            if (Character.TeleportTo[IntakeOfficerPosition, IntakeFacing]):
                TerminalLog(DebugEnabled, "[PLAYER] Officer transferred to detention intake")
                return true
            FallbackIntakePosition := vector3{
                X := IntakeDevicePosition.X + 220.0,
                Y := IntakeDevicePosition.Y + 100.0,
                Z := IntakeDevicePosition.Z + 50.0
            }
            if (Character.TeleportTo[FallbackIntakePosition, IntakeFacing]):
                TerminalLog(DebugEnabled, "[PLAYER] Officer transferred to detention intake fallback")
                return true
            TerminalLog(true, "[PLAYER ERROR] Detention transfer blocked by collision")
        return false

    ConfigureButtons():void=
        StartButton.SetInteractionText(TerminalMessage("START SHIFT"))
        StartButton.SetInteractionTime(0.25)
        StartButton.SetMaxTriggerCount(0)
        ScanButton.SetInteractionText(TerminalMessage("BODY SCAN"))
        ScanButton.SetInteractionTime(0.0)
        ScanButton.SetMaxTriggerCount(0)
        BagButton.SetInteractionText(TerminalMessage("CHECK BAG"))
        BagButton.SetInteractionTime(0.75)
        BagButton.SetMaxTriggerCount(0)
        DocumentButton.SetInteractionText(TerminalMessage("CHECK DOCUMENTS"))
        DocumentButton.SetInteractionTime(0.5)
        DocumentButton.SetMaxTriggerCount(0)
        ClearButton.SetInteractionText(TerminalMessage("PASS | LET PASSENGER GO"))
        ClearButton.SetInteractionTime(0.0)
        ClearButton.SetMaxTriggerCount(0)
        SecondaryButton.SetInteractionText(TerminalMessage("SECONDARY | EXTRA CHECKS"))
        SecondaryButton.SetInteractionTime(0.5)
        SecondaryButton.SetMaxTriggerCount(0)
        DetainButton.SetInteractionText(TerminalMessage("JAIL | DETAIN PASSENGER"))
        DetainButton.SetInteractionTime(0.0)
        DetainButton.SetMaxTriggerCount(0)
        ResponseButton.SetInteractionText(TerminalMessage("RESPOND / SECURE"))
        ResponseButton.SetInteractionTime(0.75)
        ResponseButton.SetMaxTriggerCount(0)
        UpgradeButton.SetInteractionText(TerminalMessage("UPGRADE / NEXT SHIFT"))
        UpgradeButton.SetInteractionTime(0.5)
        UpgradeButton.SetMaxTriggerCount(0)
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        CustodyButton.SetInteractionTime(0.0)
        CustodyButton.SetMaxTriggerCount(0)
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
        PowerButton.SetInteractionTime(1.5)
        PowerButton.SetMaxTriggerCount(0)
        PowerBackupButton.SetInteractionText(TerminalMessage("REROUTE BACKUP BUS"))
        PowerBackupButton.SetInteractionTime(1.5)
        PowerBackupButton.SetMaxTriggerCount(0)
        PowerRestartButton.SetInteractionText(TerminalMessage("RESTART CHECKPOINT"))
        PowerRestartButton.SetInteractionTime(1.5)
        PowerRestartButton.SetMaxTriggerCount(0)
        SecondaryPassengerButton.SetInteractionText(TerminalMessage("SECONDARY | PASSENGER REGIONS"))
        SecondaryPassengerButton.SetInteractionTime(0.75)
        SecondaryPassengerButton.SetMaxTriggerCount(0)
        SecondaryBagButton.SetInteractionText(TerminalMessage("SECONDARY | BAG COMPARTMENTS"))
        SecondaryBagButton.SetInteractionTime(0.75)
        SecondaryBagButton.SetMaxTriggerCount(0)
        SecondaryRecordsButton.SetInteractionText(TerminalMessage("SECONDARY | RECORDS REVIEW"))
        SecondaryRecordsButton.SetInteractionTime(0.75)
        SecondaryRecordsButton.SetMaxTriggerCount(0)

    ConfigurePhysicalPresentation():void=
        PassengerQueue1.Show()
        PassengerQueue2.Show()
        PassengerQueue3.Show()
        PassengerActive.Hide()
        BagPropSmall.Hide()
        BagPropMedium.Hide()
        BagPropHardShell.Hide()
        spawn{ResetPassengerQueue(RunGeneration)}
        # Keep the approach sightline open: the device border renders at a
        # fixed runtime size even when the authored actor is scaled down.
        CheckpointBoard.SetShowBorder(false)
        CheckpointBoard.HideText()
        CaseBoard.SetShowBorder(true)
        BagBoard.SetShowBorder(true)
        DocumentBoard.SetShowBorder(true)
        PowerBoard.SetShowBorder(true)
        CustodyBoard.SetShowBorder(true)
        CellBoard.SetShowBorder(true)
        EmergencyBoard.SetShowBorder(true)
        ClearBoard.SetShowBorder(true)
        SecondaryBoard.SetShowBorder(true)
        DetainBoard.SetShowBorder(true)
        ResponseLoadoutBoard.SetShowBorder(true)
        CheckpointBoard.SetTextSize(24)
        CaseBoard.SetTextSize(18)
        BagBoard.SetTextSize(16)
        DocumentBoard.SetTextSize(16)
        PowerBoard.SetTextSize(20)
        CustodyBoard.SetTextSize(18)
        CellBoard.SetTextSize(22)
        EmergencyBoard.SetTextSize(20)
        ClearBoard.SetTextSize(26)
        SecondaryBoard.SetTextSize(26)
        DetainBoard.SetTextSize(26)
        ResponseLoadoutBoard.SetTextSize(20)
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | OPEN")
        SetBoard(CaseBoard, "CURRENT PASSENGER | WAITING FOR SHIFT")
        SetBoard(BagBoard, "BAG INSPECTION | NO ACTIVE BAG")
        SetBoard(DocumentBoard, "TRAVEL DOCUMENTS | NO ACTIVE CASE")
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(CustodyBoard, "DETENTION INTAKE | READY")
        SetBoard(CellBoard, "DETENTION CELL | VACANT")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        SetBoard(ResponseLoadoutBoard, "SECURITY RESPONSE KIT\nSIGNAL REMOTE A\nSTANDBY")
        SetDecisionControlsAvailable(false)
        JailOccupant.Hide()
        CustodyButton.Disable()
        PowerButton.Disable()
        PowerBackupButton.Disable()
        PowerRestartButton.Disable()
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        ResponseButton.Disable()
        ResponseGranter.Disable()
        ResponseRemover.Enable()
        ResponseRemote.Disable()
        ResponseAlarm.Enable()
        ResponseAlarm.Stop()
        ResponseLightA.Enable()
        ResponseLightA.TurnOff()
        ResponseLightB.Enable()
        ResponseLightB.TurnOff()

    OnPlayerAdded(Player:player):void=
        EnsurePersistentHUD(Player)
        RefreshPersistentHUD(Player)
        StatusHUD.Show(Player, TerminalMessage(CurrentStatus()), ?DisplayTime := 8.0)
        if (Phase = terminal_game_phase.Runner or Phase = terminal_game_phase.HostileResponse or Phase = terminal_game_phase.BossBreach or Phase = terminal_game_phase.BossVulnerable):
            ResponseGranter.GrantItem(Player)
        TerminalLog(DebugEnabled, "[PLAYER] Joined during phase {PhaseLabel()}")

    OnPlayerRemoved(Player:player):void=
        CloseBodyScanInterface(Player)
        CloseXRayInterface(Player)
        CloseDocumentInterface(Player)
        CloseUpgradeInterface(Player)
        if (Owner := ClaimOwner?, Owner = Player):
            InterruptedCaseId := CurrentCaseId
            InterruptedRun := RunGeneration
            var RecoveryBagGeneration:int = BagGeneration
            if (ScanInProgress?):
                set ScannerGeneration += 1
                set ActivePassengerMoveGeneration += 1
                set ScanInProgress = false
                set PassengerReadyForScan = false
            if (BagScanInProgress?):
                set BagGeneration += 1
                set RecoveryBagGeneration = BagGeneration
                set BagScanInProgress = false
            set DocumentGeneration += 1
            set ClaimOwner = false
            set ClaimStage = terminal_claim_stage.None
            set ClaimGeneration += 1
            if (Phase = terminal_game_phase.Inspecting):
                set Phase = terminal_game_phase.CaseReady
            SyncActiveCase()
            spawn{RecoverCaseAfterOwnerDisconnect(InterruptedCaseId, InterruptedRun, RecoveryBagGeneration, ActiveBagIndex)}
            ShowAll("Case owner disconnected. Case {CurrentCaseId} is being returned to a safe resumable station.", 5.0)
            TerminalLog(DebugEnabled, "[RECOVERY] Owner disconnected; generations invalidated|CaseId={CurrentCaseId}|ScannerGeneration={ScannerGeneration}|BagGeneration={BagGeneration}|DocumentGeneration={DocumentGeneration}")

    RecoverCaseAfterOwnerDisconnect(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, BagIndex:int)<suspends>:void=
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? or ResolutionCommitted?):
            return
        if (Phase = terminal_game_phase.SecondaryScreening):
            if (not SecondaryPassengerReady? or PassengerLocation <> terminal_passenger_location.SecondaryPassenger):
                MovePassengerToSecondary(ExpectedCaseId, ExpectedRun)
            if (Shift >= 2 and (not SecondaryBagReady? or BagLocation <> terminal_bag_location.SecondaryTable)):
                MoveActiveBagToSecondary(ExpectedCaseId, ExpectedRun, ExpectedBagGeneration, BagIndex)
            return
        if (not BodyChecked?):
            ReturnedToScanner := MoveActivePassengerChecked(
                ScannerEntryPosition(),
                ScannerCenterPosition(),
                0.8,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.ScannerEntry,
                "disconnect-scanner-reset"
            )
            if (CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? and ReturnedToScanner?):
                set PassengerReadyForScan = true
                set Phase = terminal_game_phase.CaseReady
                SetBoard(CheckpointBoard, "CASE {CurrentCaseId} | BODY SCAN READY | NEW OFFICER MAY CLAIM")
                SyncActiveCase()
            return
        if (Shift >= 2 and not BagChecked?):
            var BagReturned:logic = false
            if (BagIndex = 0):
                set BagReturned = MovePropChecked(BagPropSmall, BagEntryPosition(), BagXRayPosition(), 0.75, ExpectedCaseId, ExpectedRun, ExpectedBagGeneration, "disconnect-bag-reset-small")
            else if (BagIndex = 1):
                set BagReturned = MovePropChecked(BagPropMedium, BagEntryPosition(), BagXRayPosition(), 0.75, ExpectedCaseId, ExpectedRun, ExpectedBagGeneration, "disconnect-bag-reset-medium")
            else:
                set BagReturned = MovePropChecked(BagPropHardShell, BagEntryPosition(), BagXRayPosition(), 0.75, ExpectedCaseId, ExpectedRun, ExpectedBagGeneration, "disconnect-bag-reset-hard-shell")
            if (CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? and ExpectedBagGeneration = BagGeneration and BagReturned?):
                set BagLocation = terminal_bag_location.ConveyorEntry
                set Phase = terminal_game_phase.AwaitingDecision
                SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | X-RAY READY | NEW OFFICER MAY CLAIM")
                SyncActiveCase()
            return
        if (Shift >= 3 and not DocumentsChecked?):
            set Phase = terminal_game_phase.AwaitingDecision
            if (PassengerLocation <> terminal_passenger_location.Documents):
                MovePassengerToDocumentDesk(ExpectedCaseId, ExpectedRun)
            SetBoard(DocumentBoard, "TRAVEL ID {CurrentCaseId} | READY | NEW OFFICER MAY CLAIM")
            SyncActiveCase()
            return
        set Phase = terminal_game_phase.AwaitingDecision
        if (PassengerLocation <> terminal_passenger_location.Decision and not SecondaryChecked?):
            MovePassengerToDecision(ExpectedCaseId, ExpectedRun)
        RefreshDecisionControls()
        SyncActiveCase()

    PersistentHUDLoop()<suspends>:void=
        loop:
            if (Phase <> terminal_game_phase.Waiting and Phase <> terminal_game_phase.Results):
                set ShiftElapsedSeconds += 1
            for (Player : GetPlayspace().GetPlayers()):
                EnsurePersistentHUD(Player)
                RefreshPersistentHUD(Player)
            Sleep(1.0)

    EnsurePersistentHUD(Player:player):void=
        if (ExistingRoot := PersistentHUDRoot[Player]):
            return
        Readout := text_block:
            DefaultText := TerminalMessage(PersistentHUDTextValue())
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 15.0
            AutoWrap := true
            WrapWidth := 360.0
        Header := text_block:
            DefaultText := TerminalMessage("ASTRA CHECKPOINT OPERATIONS")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 17.0
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 6.0}}
                stack_box_slot{Widget := Readout}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(6, 18, 32)
                        DefaultOpacity := 0.82
                        DefaultDesiredSize := vector2{X := 390.0, Y := 235.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 16.0, Top := 12.0, Right := 16.0, Bottom := 12.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.0, Y := 0.0}}
                    Offsets := margin{Left := 24.0, Top := 150.0, Right := 390.0, Bottom := 235.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := Panel
        if (set PersistentHUDRoot[Player] = Root) {}
        if (set PersistentHUDText[Player] = Readout) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.None, ZOrder := 20})

    RefreshPersistentHUD(Player:player):void=
        if (Readout := PersistentHUDText[Player]):
            Readout.SetText(TerminalMessage(PersistentHUDTextValue()))

    PersistentHUDTextValue()<transacts>:string=
        if (Phase = terminal_game_phase.Results):
            return "RESULTS  |  GRADE {ResultGrade()}\nCASH ${TeamCash}  |  INTEGRITY {TeamIntegrity}  |  RISK {TeamRisk}\nCORRECT {CorrectDecisions}/{TotalCasesResolved}  |  FALSE DETENTIONS {FalseDetentions}  |  MISSED {MissedThreats}\nFINAL THREAT  {BossBranchLabel()}\nUPGRADES  SCAN {ScannerUpgradeLevel}  PAY {PayoutUpgradeLevel}  EMERGENCY {EmergencyUpgradeLevel}\nOBJECTIVE  {CurrentObjective()}"
        "SHIFT {Shift}/7  |  CASE {CaseDisplayNumber()}/{CasesPerShift}  |  CLOCK {ShiftElapsedSeconds}s\nCASH ${TeamCash}  |  INTEGRITY {TeamIntegrity}  |  RISK {TeamRisk}\nEVIDENCE  BODY {CompletionMark(BodyChecked)}  BAG {BagCompletionMark()}  DOC {DocumentCompletionMark()}\nPOWER {PowerStatusText()}  |  ALERT {AlertStatusText()}\nUPGRADES  SCAN {ScannerUpgradeLevel}  PAY {PayoutUpgradeLevel}  EMERGENCY {EmergencyUpgradeLevel}\nOBJECTIVE  {CurrentObjective()}"

    CaseDisplayNumber()<transacts>:int=
        if (Phase = terminal_game_phase.Waiting):
            return 0
        if (CasesInShift >= CasesPerShift):
            return CasesPerShift
        CasesInShift + 1

    CompletionMark(Complete:logic)<computes>:string=
        if (Complete?):
            return "DONE"
        "--"

    BagCompletionMark()<transacts>:string=
        if (Shift < 2):
            return "N/A"
        CompletionMark(BagChecked)

    DocumentCompletionMark()<transacts>:string=
        if (Shift < 3):
            return "N/A"
        CompletionMark(DocumentsChecked)

    PowerStatusText()<transacts>:string=
        if (PowerOnline?):
            return "ONLINE"
        "OFFLINE"

    AlertStatusText()<transacts>:string=
        if (Phase = terminal_game_phase.Emergency):
            if (Shift = 5):
                return "OUTAGE"
            return "LOCKDOWN"
        if (Phase = terminal_game_phase.Runner):
            return "RUNNER"
        if (Phase = terminal_game_phase.HostileResponse):
            return "RESPONSE"
        if (Phase = terminal_game_phase.BossJammer or Phase = terminal_game_phase.BossBreach or Phase = terminal_game_phase.BossVulnerable or Phase = terminal_game_phase.BossSecure):
            return "FINAL THREAT"
        "NORMAL"

    CurrentObjective()<transacts>:string=
        if (Phase = terminal_game_phase.Waiting):
            return "START SHIFT AT THE BRIEFING DESK"
        if (Phase = terminal_game_phase.Emergency):
            if (Shift = 5 and not PowerOnline?):
                return PowerRepairObjective()
            return "REACH THE SECURED RESPONSE CONTROL"
        if (Phase = terminal_game_phase.Runner):
            return "INTERCEPT THE RUNNER AT THE DEPARTURE ROUTE"
        if (Phase = terminal_game_phase.HostileResponse):
            return "TAKE SIGNAL REMOTE A; ENGAGE INSIDE THE RESPONSE ROOM"
        if (Phase = terminal_game_phase.SecondaryScreening):
            return "FOLLOW THE PASSENGER; PERFORM THE CONTROLLED SEARCH"
        if (Phase = terminal_game_phase.Custody):
            return "COMPLETE JAIL INTAKE / SECURE IN CELL AT DETENTION"
        if (Phase = terminal_game_phase.UpgradeBreak):
            return "USE UPGRADE DESK; CHOOSE ONE SYSTEM OR CONTINUE"
        if (Phase = terminal_game_phase.BossJammer):
            return "DISABLE THE JAMMER AT THE POWER-ROOM CONSOLE"
        if (Phase = terminal_game_phase.BossBreach):
            return "INTERRUPT THE BREACH AT THE RESPONSE STATION"
        if (Phase = terminal_game_phase.BossVulnerable):
            return "ENGAGE THE THREAT AT CLOSE RANGE IN THE RESPONSE ROOM"
        if (Phase = terminal_game_phase.BossSecure):
            return "MOVE THE THREAT TO DETENTION AND COMPLETE FINAL CUSTODY"
        if (Phase = terminal_game_phase.Results):
            return "USE RESPOND / SECURE TO START A CLEAN REPLAY"
        EvidencePrompt()

    OnStartButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.Waiting):
            ShowAgent(Agent, "A run is already active. Follow the current objective.", 4.0)
            return
        IsHuman := IsHumanAgent(Agent)
        if (not IsHuman?):
            return

        set RunGeneration += 1
        set Shift = 1
        set CasesInShift = 0
        set TotalCasesResolved = 0
        set ShiftElapsedSeconds = 0
        set TeamIntegrity = 100
        set TeamRisk = 0
        set TeamCash = 0
        set CorrectDecisions = 0
        set FalseDetentions = 0
        set MissedThreats = 0
        set BossBranch = terminal_boss_branch.None
        set RunUpgradePurchased = false
        set ScannerUpgradeLevel = 0
        set PayoutUpgradeLevel = 0
        set EmergencyUpgradeLevel = 0
        set UpgradeBreakResolved = false
        set PowerRepairStage = 0
        set PowerRepairCommitted = false
        CloseAllUpgradeInterfaces()
        set PowerOnline = true
        set CurrentCustodyMode = 0
        set CustodyCommitted = false
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        CloseAllDocumentInterfaces()
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set SecondaryCostPaid = false
        set SecondaryFeeAmount = 0
        set SecondaryActionStage = 0
        set SecondaryPassengerChecked = false
        set SecondaryBagChecked = false
        set SecondaryRecordsChecked = false
        set SecondaryPassengerRegions = 0
        set SecondaryBagHotspots = 0
        set PassengerAtIntake = false
        set PassengerGeneration = 0
        set PassengerLocation = terminal_passenger_location.QueueFront
        set PassengerTarget = terminal_passenger_location.QueueFront
        set BagLocation = terminal_bag_location.Hidden
        set BodyObservation = terminal_body_observation.None
        set BagObservation = terminal_bag_observation.None
        set DocumentObservation = terminal_document_observation.None
        set ManualSearchRequested = false
        set PassengerRouteRetries = 0
        set PassengerTeleportRecoveries = 0
        set PassengerHideRecoveries = 0
        set BagRouteRetries = 0
        set BagTeleportRecoveries = 0
        set BagHideRecoveries = 0
        set CaseCompletionCommitted = false
        set FinalCaseAccountingCommitted = false
        set QueueFrontIndex = 0
        set QueueGeneration += 1
        set ClaimGeneration += 1
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set CurrentDestination = terminal_case_destination.Queue
        set BagGeneration += 1
        HideAllBags()
        ScanButton.Enable()
        CustodyButton.Disable()
        PowerButton.Disable()
        PowerBackupButton.Disable()
        PowerRestartButton.Disable()
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        set Phase = terminal_game_phase.Briefing
        spawn{ResetPassengerQueue(RunGeneration)}
        ShowAll("ASTRA TERMINAL SAFETY UNIT | Inspect evidence, then CLEAR, SECONDARY, or DETAIN.", 7.0)
        TerminalLog(DebugEnabled, "[BOOT] RunGeneration={RunGeneration} started")
        PrepareNextCase()

    OnScanButton(Agent:agent):void=
        if (PassengerLocation = terminal_passenger_location.ScannerExit and not BodyChecked? and not ScanInProgress?):
            LegalRecovery := IsCaseInteractionLegal(Agent)
            if (not LegalRecovery?):
                return
            RecoveryClaim := TryClaim(Agent, terminal_claim_stage.Body)
            if (not RecoveryClaim?):
                return
            if (Player := player[Agent]):
                OpenBodyScanInterface(Player, CurrentCaseId, ScannerGeneration, CurrentTemplate)
            return
        ScannerEligible := CanUseBodyScanner(Agent)
        if (not ScannerEligible?):
            return
        if (BodyChecked?):
            ShowAgent(Agent, "BODY already checked | {BodyEvidence(CurrentTemplate)}", 4.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Body)
        if (not Claimed?):
            return
        set Phase = terminal_game_phase.Inspecting
        set ScanInProgress = true
        set ScannerGeneration += 1
        SetDecisionControlsAvailable(false)
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 0%")
        ShowAgent(Agent, "BODY SCANNER ACTIVE | Remain at the lane until the sweep completes.", 3.0)
        ScannerStartAudio.Play()
        spawn{RunScannerSequence(CurrentCaseId, RunGeneration, ScannerGeneration, CurrentTemplate)}
        TerminalLog(DebugEnabled, "[SCAN] Started|CaseId={CurrentCaseId}|Template={CurrentTemplate}|Generation={ScannerGeneration}")

    RunScannerSequence(ExpectedCaseId:int, ExpectedRun:int, ExpectedScannerGeneration:int, Template:int)<suspends>:void=
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | ENTERING")
        EnteredScanner := MoveActivePassengerChecked(
            ScannerCenterPosition(),
            ScannerEntryPosition(),
            0.8,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.ScannerCenter,
            "scanner-enter"
        )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not EnteredScanner?):
            set ScanInProgress = false
            set Phase = terminal_game_phase.CaseReady
            SetBoard(CheckpointBoard, "SCANNER ROUTE RESET | RETRY BODY SCAN")
            ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", "ROUTE RESET")
            return
        if (not PowerOnline?):
            set ScanInProgress = false
            SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
            ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", "POWER INTERRUPTED")
            return
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 25%")
        Sleep(0.35)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 75%")
        Sleep(ScannerSweepStageSeconds())
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not PowerOnline?):
            set ScanInProgress = false
            SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
            ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", "POWER INTERRUPTED")
            return
        ExitedScanner := MoveActivePassengerChecked(
            ScannerExitPosition(),
            ScannerCenterPosition(),
            0.8,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.ScannerExit,
            "scanner-exit"
        )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not ExitedScanner?):
            set ScanInProgress = false
            set Phase = terminal_game_phase.CaseReady
            SetBoard(CheckpointBoard, "SCANNER EXIT RESET | RETRY BODY SCAN")
            ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", "EXIT RESET")
            return
        set ScanInProgress = false
        set Phase = terminal_game_phase.Inspecting
        SyncActiveCase()
        ScannerResultAudio.Play()
        SetBoard(CheckpointBoard, "SCANNER DISPLAY READY | SELECT OBSERVED BODY REGION")
        if (Owner := ClaimOwner?):
            OpenBodyScanInterface(Owner, ExpectedCaseId, ExpectedScannerGeneration, Template)
            ShowAgent(Owner, "SCANNER DISPLAY READY | Inspect the silhouette and record your observation.", 5.0)
        TerminalLog(DebugEnabled, "[SCAN] Sweep complete; awaiting operator observation|CaseId={CurrentCaseId}|Template={Template}")

    OpenBodyScanInterface(Player:player, CaseId:int, ExpectedScannerGeneration:int, Template:int):void=
        if (CaseId <> CurrentCaseId or ExpectedScannerGeneration <> ScannerGeneration or PassengerLocation <> terminal_passenger_location.ScannerExit):
            return
        CloseBodyScanInterface(Player)

        Header := text_block:
            DefaultText := TerminalMessage("BODY SCAN | CASE {CaseId} | OPERATOR INTERPRETATION")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 25.0
        Instruction := text_block:
            DefaultText := TerminalMessage("Compare signal strength and select the region you believe needs follow-up. Amber may be harmless noise; red is a stronger return.")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 15.0
            AutoWrap := true
            WrapWidth := 650.0
        HeadShape := color_block:
            DefaultColor := BodyRegionColor(Template, 0)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 105.0, Y := 80.0}
        LeftArmShape := color_block:
            DefaultColor := BodyRegionColor(Template, 3)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 52.0, Y := 180.0}
        TorsoShape := color_block:
            DefaultColor := BodyRegionColor(Template, 1)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 170.0, Y := 180.0}
        RightArmShape := color_block:
            DefaultColor := BodyRegionColor(Template, 4)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 52.0, Y := 180.0}
        LowerTorsoShape := color_block:
            DefaultColor := BodyRegionColor(Template, 2)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 150.0, Y := 95.0}
        LeftLegShape := color_block:
            DefaultColor := BodyRegionColor(Template, 5)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 68.0, Y := 190.0}
        RightLegShape := color_block:
            DefaultColor := BodyRegionColor(Template, 6)
            DefaultOpacity := 0.96
            DefaultDesiredSize := vector2{X := 68.0, Y := 190.0}
        TorsoRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := LeftArmShape, Padding := margin{Right := 10.0}}
                stack_box_slot{Widget := TorsoShape, Padding := margin{Right := 10.0}}
                stack_box_slot{Widget := RightArmShape}
        LegsRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := LeftLegShape, Padding := margin{Right := 14.0}}
                stack_box_slot{Widget := RightLegShape}
        Silhouette := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := HeadShape, HorizontalAlignment := horizontal_alignment.Center, Padding := margin{Bottom := 10.0}}
                stack_box_slot{Widget := TorsoRow, HorizontalAlignment := horizontal_alignment.Center, Padding := margin{Bottom := 10.0}}
                stack_box_slot{Widget := LowerTorsoShape, HorizontalAlignment := horizontal_alignment.Center, Padding := margin{Bottom := 10.0}}
                stack_box_slot{Widget := LegsRow, HorizontalAlignment := horizontal_alignment.Center}

        HeadButton := button_regular{DefaultText := TerminalMessage("HEAD")}
        UpperButton := button_regular{DefaultText := TerminalMessage("UPPER TORSO")}
        LowerButton := button_regular{DefaultText := TerminalMessage("LOWER TORSO")}
        LeftArmButton := button_regular{DefaultText := TerminalMessage("LEFT ARM")}
        RightArmButton := button_regular{DefaultText := TerminalMessage("RIGHT ARM")}
        LeftLegButton := button_regular{DefaultText := TerminalMessage("LEFT LEG")}
        RightLegButton := button_regular{DefaultText := TerminalMessage("RIGHT LEG")}
        NoAnomalyButton := button_loud{DefaultText := TerminalMessage("NO ANOMALY OBSERVED")}
        UncertainButton := button_quiet{DefaultText := TerminalMessage("UNCERTAIN | RECOMMEND SECONDARY")}
        HeadButton.OnClick().Subscribe(OnBodyHead)
        UpperButton.OnClick().Subscribe(OnBodyUpperTorso)
        LowerButton.OnClick().Subscribe(OnBodyLowerTorso)
        LeftArmButton.OnClick().Subscribe(OnBodyLeftArm)
        RightArmButton.OnClick().Subscribe(OnBodyRightArm)
        LeftLegButton.OnClick().Subscribe(OnBodyLeftLeg)
        RightLegButton.OnClick().Subscribe(OnBodyRightLeg)
        NoAnomalyButton.OnClick().Subscribe(OnBodyNoAnomaly)
        UncertainButton.OnClick().Subscribe(OnBodyUncertain)
        ChoiceColumn := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := HeadButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := UpperButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := LowerButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := LeftArmButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := RightArmButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := LeftLegButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := RightLegButton, Padding := margin{Bottom := 12.0}}
                stack_box_slot{Widget := NoAnomalyButton, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := UncertainButton}
        InspectionRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := Silhouette, Padding := margin{Right := 42.0}}
                stack_box_slot{Widget := ChoiceColumn}
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := Instruction, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := InspectionRow}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(4, 17, 31)
                        DefaultOpacity := 0.98
                        DefaultDesiredSize := vector2{X := 760.0, Y := 720.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 30.0, Top := 28.0, Right := 30.0, Bottom := 28.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 760.0, Bottom := 720.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := Panel
        if (set BodyScanRootUI[Player] = Root) {}
        if (set BodyScanOpenGeneration[Player] = ExpectedScannerGeneration) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All, ZOrder := 125})

    BodyRegionColor(Template:int, Region:int):color=
        if (Template = 2 and (Region = 2 or Region = 6)):
            return NamedColors.Red
        if (Template = 8 and Region = 1):
            return MakeColorFromSRGBValues(255, 88, 46)
        if (Template = 9 and Region = 1):
            return NamedColors.Yellow
        if ((Template = 3 or Template = 6 or Template = 10) and Region = 3):
            return MakeColorFromSRGBValues(186, 142, 42)
        MakeColorFromSRGBValues(31, 147, 173)

    OnBodyHead(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.Head)
    OnBodyUpperTorso(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.UpperTorso)
    OnBodyLowerTorso(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.LowerTorso)
    OnBodyLeftArm(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.LeftArm)
    OnBodyRightArm(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.RightArm)
    OnBodyLeftLeg(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.LeftLeg)
    OnBodyRightLeg(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.RightLeg)
    OnBodyNoAnomaly(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.NoAnomaly)
    OnBodyUncertain(Message:widget_message):void=
        CommitBodyObservation(Message.Player, terminal_body_observation.Uncertain)

    CommitBodyObservation(Player:player, Observation:terminal_body_observation):void=
        if (OpenGeneration := BodyScanOpenGeneration[Player], OpenGeneration <> ScannerGeneration):
            CloseBodyScanInterface(Player)
            return
        if (Phase <> terminal_game_phase.Inspecting or BodyChecked? or PassengerLocation <> terminal_passenger_location.ScannerExit or not PowerOnline?):
            CloseBodyScanInterface(Player)
            return
        if (Owner := ClaimOwner?, Owner <> Player):
            CloseBodyScanInterface(Player)
            return
        set BodyObservation = Observation
        set BodyChecked = true
        # The scanner housing stays visible, but its completed interaction must
        # stop competing with the adjacent PASS and JAIL prompts.
        ScanButton.Disable()
        set Phase = terminal_game_phase.AwaitingDecision
        CloseBodyScanInterface(Player)
        SyncActiveCase()
        SetBoard(CheckpointBoard, "BODY OBSERVATION RECORDED | {BodyObservationLabel(Observation)}")
        ShowAll("BODY OBSERVATION RECORDED | Continue the physical handoff to the next station.", 4.0)
        TerminalLog(DebugEnabled, "[SCAN] Operator observation committed|CaseId={CurrentCaseId}|Observation={BodyObservationLabel(Observation)}")
        if (Shift >= 2):
            spawn{MovePassengerToBaggage(CurrentCaseId, RunGeneration)}
        else:
            spawn{MovePassengerToDecision(CurrentCaseId, RunGeneration)}

    BodyObservationLabel(Observation:terminal_body_observation):string=
        if (Observation = terminal_body_observation.NoAnomaly):
            return "NO ANOMALY"
        if (Observation = terminal_body_observation.Head):
            return "HEAD"
        if (Observation = terminal_body_observation.UpperTorso):
            return "UPPER TORSO"
        if (Observation = terminal_body_observation.LowerTorso):
            return "LOWER TORSO"
        if (Observation = terminal_body_observation.LeftArm):
            return "LEFT ARM"
        if (Observation = terminal_body_observation.RightArm):
            return "RIGHT ARM"
        if (Observation = terminal_body_observation.LeftLeg):
            return "LEFT LEG"
        if (Observation = terminal_body_observation.RightLeg):
            return "RIGHT LEG"
        "UNCERTAIN"

    CloseBodyScanInterface(Player:player):void=
        if (Root := BodyScanRootUI[Player], PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Root)
        if (set BodyScanOpenGeneration[Player] = -1) {}

    CloseAllBodyScanInterfaces():void=
        for (Player : GetPlayspace().GetPlayers()):
            CloseBodyScanInterface(Player)

    OnBagButton(Agent:agent):void=
        if (BagLocation = terminal_bag_location.XRayTunnel and not BagChecked?):
            LegalRecovery := IsCaseInteractionLegal(Agent)
            if (not LegalRecovery?):
                return
            RecoveryClaim := TryClaim(Agent, terminal_claim_stage.Baggage)
            if (not RecoveryClaim?):
                return
            if (Player := player[Agent]):
                OpenXRayInterface(Player, CurrentCaseId, BagGeneration, CurrentTemplate)
            return
        BaggageEligible := CanUseBaggageStation(Agent)
        if (not BaggageEligible?):
            return
        if (BagChecked?):
            ShowAgent(Agent, "BAG already checked | {BagEvidence(CurrentTemplate)}", 4.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Baggage)
        if (not Claimed?):
            return
        set Phase = terminal_game_phase.Inspecting
        set BagScanInProgress = true
        set CurrentDestination = terminal_case_destination.Baggage
        SetDecisionControlsAvailable(false)
        set BagGeneration += 1
        SyncActiveCase()
        SetBoard(BagBoard, "X-RAY ACTIVE | CASE {CurrentCaseId} | LINKED BAG MOVING")
        ShowAgent(Agent, "X-RAY ACTIVE | Linked bag moving through the inspection tunnel.", 4.0)
        BagScanAudio.Play()
        spawn{RunBagInspection(CurrentCaseId, RunGeneration, BagGeneration, CurrentTemplate, ActiveBagIndex)}
        TerminalLog(DebugEnabled, "[BAG] Started|CaseId={CurrentCaseId}|Template={CurrentTemplate}|Generation={BagGeneration}")

    RunBagInspection(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, Template:int, BagIndex:int)<suspends>:void=
        var TunnelReached:logic = false
        if (BagIndex = 0):
            set TunnelReached = MovePropChecked(
                BagPropSmall,
                BagXRayPosition(),
                BagEntryPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-tunnel-small"
            )
        else if (BagIndex = 1):
            set TunnelReached = MovePropChecked(
                BagPropMedium,
                BagXRayPosition(),
                BagEntryPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-tunnel-medium"
            )
        else:
            set TunnelReached = MovePropChecked(
                BagPropHardShell,
                BagXRayPosition(),
                BagEntryPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-tunnel-hard-shell"
            )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        if (not TunnelReached?):
            set BagScanInProgress = false
            set Phase = terminal_game_phase.AwaitingDecision
            SyncActiveCase()
            SetBoard(BagBoard, "X-RAY ROUTE FAULT | RETRY BAG INSPECTION")
            ReleaseStationClaim(terminal_claim_stage.Baggage, "BAG X-RAY", "ROUTE RESET")
            ShowAll("BAG ROUTE RESET | The linked bag was safely removed. Retry the X-ray station.", 6.0)
            return
        set BagLocation = terminal_bag_location.XRayTunnel
        SyncActiveCase()
        SetBoard(BagBoard, "X-RAY IMAGE READY | CASE {CurrentCaseId} | OPERATOR INTERPRETATION")
        if (Owner := ClaimOwner?):
            OpenXRayInterface(Owner, ExpectedCaseId, ExpectedBagGeneration, Template)
            ShowAgent(Owner, "X-RAY IMAGE READY | Select a suspicious region, clear the image, or request manual search.", 5.0)
        TerminalLog(DebugEnabled, "[BAG] Linked bag paused in tunnel; awaiting operator observation|CaseId={CurrentCaseId}")
        return

    FinishBagInspectionAfterObservation(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, BagIndex:int)<suspends>:void=
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration or not BagChecked?):
            return
        var ExitReached:logic = false
        if (BagIndex = 0):
            set ExitReached = MovePropChecked(
                BagPropSmall,
                BagExitPosition(),
                BagXRayPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-exit-small"
            )
        else if (BagIndex = 1):
            set ExitReached = MovePropChecked(
                BagPropMedium,
                BagExitPosition(),
                BagXRayPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-exit-medium"
            )
        else:
            set ExitReached = MovePropChecked(
                BagPropHardShell,
                BagExitPosition(),
                BagXRayPosition(),
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-exit-hard-shell"
            )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        if (not ExitReached?):
            set BagScanInProgress = false
            set Phase = terminal_game_phase.AwaitingDecision
            SyncActiveCase()
            SetBoard(BagBoard, "X-RAY EXIT FAULT | RETRY BAG INSPECTION")
            ReleaseStationClaim(terminal_claim_stage.Baggage, "BAG X-RAY", "EXIT RESET")
            ShowAll("BAG EXIT RESET | The linked bag was safely removed. Retry the X-ray station.", 6.0)
            return
        set BagChecked = true
        set BagScanInProgress = false
        set BagLocation = terminal_bag_location.ConveyorExit
        set Phase = terminal_game_phase.AwaitingDecision
        SyncActiveCase()
        RefreshDecisionControls()
        SetBoard(BagBoard, "X-RAY OBSERVATION | CASE {CurrentCaseId} | {BagObservationLabel(BagObservation)}")
        ShowAll("X-RAY OBSERVATION RECORDED | Linked bag exited the tunnel.", 5.0)
        TerminalLog(DebugEnabled, "[BAG] Observation complete|CaseId={CurrentCaseId}|Observation={BagObservationLabel(BagObservation)}")
        if (Shift >= 3):
            spawn{MovePassengerToDocumentDesk(ExpectedCaseId, ExpectedRun)}
        else:
            spawn{MovePassengerToDecision(ExpectedCaseId, ExpectedRun)}

    OpenXRayInterface(Player:player, CaseId:int, ExpectedBagGeneration:int, Template:int):void=
        if (CaseId <> CurrentCaseId or ExpectedBagGeneration <> BagGeneration or BagLocation <> terminal_bag_location.XRayTunnel):
            return
        CloseXRayInterface(Player)
        Header := text_block:
            DefaultText := TerminalMessage("BAG X-RAY | CASE {CaseId} | DUAL-ENERGY VIEW")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 25.0
        Instruction := text_block:
            DefaultText := TerminalMessage("Orange suggests organic material, blue suggests dense inorganic material, and green suggests overlap. Select the region you want to flag; not every dense object is prohibited.")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 15.0
            AutoWrap := true
            WrapWidth := 720.0
        UpperLeftShape := color_block:
            DefaultColor := XRayDensityColor(Template, 0)
            DefaultOpacity := 0.88
            DefaultDesiredSize := vector2{X := 210.0, Y := 130.0}
        UpperRightShape := color_block:
            DefaultColor := XRayDensityColor(Template, 1)
            DefaultOpacity := 0.88
            DefaultDesiredSize := vector2{X := 210.0, Y := 130.0}
        LowerLeftShape := color_block:
            DefaultColor := XRayDensityColor(Template, 2)
            DefaultOpacity := 0.88
            DefaultDesiredSize := vector2{X := 210.0, Y := 130.0}
        LowerRightShape := color_block:
            DefaultColor := XRayDensityColor(Template, 3)
            DefaultOpacity := 0.88
            DefaultDesiredSize := vector2{X := 210.0, Y := 130.0}
        CenterShape := color_block:
            DefaultColor := XRayDensityColor(Template, 4)
            DefaultOpacity := 0.92
            DefaultDesiredSize := vector2{X := 120.0, Y := 70.0}
        UpperRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := UpperLeftShape, Padding := margin{Right := 14.0}}
                stack_box_slot{Widget := UpperRightShape}
        LowerRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := LowerLeftShape, Padding := margin{Right := 14.0}}
                stack_box_slot{Widget := LowerRightShape}
        BagLayers := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := UpperRow, Padding := margin{Bottom := 12.0}}
                stack_box_slot{Widget := CenterShape, HorizontalAlignment := horizontal_alignment.Center, Padding := margin{Bottom := 12.0}}
                stack_box_slot{Widget := LowerRow}
        BagBoundary := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(10, 20, 28)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 500.0, Y := 390.0}
                overlay_slot:
                    Widget := BagLayers
                    Padding := margin{Left := 30.0, Top := 30.0, Right := 30.0, Bottom := 30.0}
        UpperLeftButton := button_regular{DefaultText := TerminalMessage("FLAG UPPER LEFT")}
        UpperRightButton := button_regular{DefaultText := TerminalMessage("FLAG UPPER RIGHT")}
        LowerLeftButton := button_regular{DefaultText := TerminalMessage("FLAG LOWER LEFT")}
        LowerRightButton := button_regular{DefaultText := TerminalMessage("FLAG LOWER RIGHT")}
        CenterButton := button_regular{DefaultText := TerminalMessage("FLAG CENTER DENSITY")}
        ClearButtonUI := button_loud{DefaultText := TerminalMessage("CLEAR IMAGE")}
        ManualButton := button_quiet{DefaultText := TerminalMessage("ROUTE TO MANUAL SEARCH")}
        UpperLeftButton.OnClick().Subscribe(OnXRayUpperLeft)
        UpperRightButton.OnClick().Subscribe(OnXRayUpperRight)
        LowerLeftButton.OnClick().Subscribe(OnXRayLowerLeft)
        LowerRightButton.OnClick().Subscribe(OnXRayLowerRight)
        CenterButton.OnClick().Subscribe(OnXRayCenter)
        ClearButtonUI.OnClick().Subscribe(OnXRayClear)
        ManualButton.OnClick().Subscribe(OnXRayManual)
        Choices := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := UpperLeftButton, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := UpperRightButton, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := LowerLeftButton, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := LowerRightButton, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := CenterButton, Padding := margin{Bottom := 14.0}}
                stack_box_slot{Widget := ClearButtonUI, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := ManualButton}
        InspectionRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := BagBoundary, Padding := margin{Right := 30.0}}
                stack_box_slot{Widget := Choices}
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := Instruction, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := InspectionRow}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(3, 13, 24)
                        DefaultOpacity := 0.98
                        DefaultDesiredSize := vector2{X := 980.0, Y := 610.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 30.0, Top := 26.0, Right := 30.0, Bottom := 26.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 980.0, Bottom := 610.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := Panel
        if (set XRayRootUI[Player] = Root) {}
        if (set XRayOpenGeneration[Player] = ExpectedBagGeneration) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All, ZOrder := 125})

    XRayDensityColor(Template:int, Region:int):color=
        if ((Template = 4 or Template = 8 or Template = 12) and Region = 4):
            return MakeColorFromSRGBValues(23, 92, 255)
        if (Template = 7 and (Region = 1 or Region = 4)):
            return MakeColorFromSRGBValues(28, 180, 92)
        if ((Template = 2 or Template = 5 or Template = 11) and Region = 2):
            return MakeColorFromSRGBValues(18, 105, 220)
        if (Region = 0 or Region = 3):
            return MakeColorFromSRGBValues(238, 126, 36)
        MakeColorFromSRGBValues(28, 165, 105)

    OnXRayUpperLeft(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.UpperLeft)
    OnXRayUpperRight(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.UpperRight)
    OnXRayLowerLeft(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.LowerLeft)
    OnXRayLowerRight(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.LowerRight)
    OnXRayCenter(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.CenterDense)
    OnXRayClear(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.ClearImage)
    OnXRayManual(Message:widget_message):void=
        CommitBagObservation(Message.Player, terminal_bag_observation.ManualSearch)

    CommitBagObservation(Player:player, Observation:terminal_bag_observation):void=
        if (OpenGeneration := XRayOpenGeneration[Player], OpenGeneration <> BagGeneration):
            CloseXRayInterface(Player)
            return
        if (Phase <> terminal_game_phase.Inspecting or BagChecked? or BagLocation <> terminal_bag_location.XRayTunnel or not PowerOnline?):
            CloseXRayInterface(Player)
            return
        if (Owner := ClaimOwner?, Owner <> Player):
            CloseXRayInterface(Player)
            return
        set BagObservation = Observation
        if (Observation = terminal_bag_observation.ManualSearch):
            set ManualSearchRequested = true
        set BagChecked = true
        CloseXRayInterface(Player)
        SyncActiveCase()
        spawn{FinishBagInspectionAfterObservation(CurrentCaseId, RunGeneration, BagGeneration, ActiveBagIndex)}

    BagObservationLabel(Observation:terminal_bag_observation):string=
        if (Observation = terminal_bag_observation.ClearImage):
            return "CLEARED BY OPERATOR"
        if (Observation = terminal_bag_observation.UpperLeft):
            return "UPPER LEFT FLAGGED"
        if (Observation = terminal_bag_observation.UpperRight):
            return "UPPER RIGHT FLAGGED"
        if (Observation = terminal_bag_observation.LowerLeft):
            return "LOWER LEFT FLAGGED"
        if (Observation = terminal_bag_observation.LowerRight):
            return "LOWER RIGHT FLAGGED"
        if (Observation = terminal_bag_observation.CenterDense):
            return "CENTER DENSITY FLAGGED"
        if (Observation = terminal_bag_observation.ManualSearch):
            return "MANUAL SEARCH REQUESTED"
        "PENDING"

    CloseXRayInterface(Player:player):void=
        if (Root := XRayRootUI[Player], PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Root)
        if (set XRayOpenGeneration[Player] = -1) {}

    CloseAllXRayInterfaces():void=
        for (Player : GetPlayspace().GetPlayers()):
            CloseXRayInterface(Player)

    OnDocumentButton(Agent:agent):void=
        DocumentEligible := CanUseDocumentStation(Agent)
        if (not DocumentEligible?):
            return
        if (Player := player[Agent]):
            if (OpenCase := DocumentOpenCase[Player], OpenCase = CurrentCaseId):
                ShowAgent(Agent, "Document interface is already open for Case {CurrentCaseId}.", 3.0)
                return
        if (DocumentsChecked?):
            ShowAgent(Agent, "DOCUMENT OBSERVATION already recorded | {DocumentObservationLabel(DocumentObservation)}", 4.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Documents)
        if (not Claimed?):
            return
        set Phase = terminal_game_phase.Inspecting
        SyncActiveCase()
        SetBoard(
            DocumentBoard,
            "TRAVEL ID {CurrentCaseId} | RAW RECORDS OPEN | OPERATOR COMPARISON REQUIRED"
        )
        if (Player := player[Agent]):
            OpenDocumentInterface(Player, CurrentCaseId, CurrentTemplate, DocumentGeneration)
        ShowAgent(Agent, "DOCUMENT READER | Compare portrait, expiry, route, seal, and access fields.", 5.0)
        TerminalLog(DebugEnabled, "[DOC] Raw record opened|CaseId={CurrentCaseId}|Template={CurrentTemplate}")

    OpenDocumentInterface(Player:player, CaseId:int, Template:int, ExpectedDocumentGeneration:int):void=
        if (CaseId <> CurrentCaseId or ExpectedDocumentGeneration <> DocumentGeneration):
            return
        CloseDocumentInterface(Player)

        Header := text_block:
            DefaultText := TerminalMessage("ASTRA TERMINAL TRAVEL RECORD  |  CASE {CaseId}")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 27.0
        Subheader := text_block:
            DefaultText := TerminalMessage("FICTIONAL SECURITY TRAINING DOCUMENT  |  FIELD COMPARISON REQUIRED")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 14.0
        PortraitLabel := text_block:
            DefaultText := TerminalMessage("ID PORTRAIT\n\n\n\n\nVARIANT {PassengerVariantCode(Template)}")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 16.0
            AutoWrap := true
            WrapWidth := 205.0
        PortraitPanel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := PortraitBackgroundColor(Template)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 220.0, Y := 280.0}
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := PortraitClothingColor(Template)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 150.0, Y := 105.0}
                    Padding := margin{Left := 35.0, Top := 142.0, Right := 35.0, Bottom := 33.0}
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := PortraitSkinColor(Template)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 92.0, Y := 94.0}
                    Padding := margin{Left := 64.0, Top := 55.0, Right := 64.0, Bottom := 131.0}
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := PortraitHairColor(Template)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 96.0, Y := 31.0}
                    Padding := margin{Left := 62.0, Top := 48.0, Right := 62.0, Bottom := 201.0}
                overlay_slot:
                    Widget := PortraitLabel
                    Padding := margin{Left := 18.0, Top := 22.0, Right := 18.0, Bottom := 18.0}
        IdentityFields := text_block:
            DefaultText := TerminalMessage("NAME\n{IdentityName(Template)}\n\nDOCUMENT NUMBER\n{DocumentNumber(Template)}\n\nEXPIRATION\n{ExpirationDate(Template)}\n\nDESTINATION\n{Destination(Template)}\n\nFLIGHT / GATE\n{FlightAndGate(Template)}\n\nACCESS LEVEL\n{AccessLevel(Template)}")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 18.0
            AutoWrap := true
            WrapWidth := 385.0
        IdentityRow := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := PortraitPanel, Padding := margin{Right := 24.0}}
                stack_box_slot{Widget := IdentityFields}
        Checks := text_block:
            DefaultText := TerminalMessage("SHIFT DATE  {CurrentShiftDate()}\nISSUING AUTHORITY  ASTRA CIVIL TRAVEL OFFICE\nSEAL / CHECKSUM  {IssuingSeal(Template)}\n\nFLIGHT MANIFEST\nNAME  {ManifestName(Template)}\nFLIGHT / ACTIVE GATE  {ManifestFlightAndGate(Template)}\nACCESS RULE  {ManifestAccess(Template)}\n\nCompare the ID portrait with the passenger standing at the desk, then record only the issue you personally observe.")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 16.0
            AutoWrap := true
            WrapWidth := 650.0
        NoIssueButton := button_loud{DefaultText := TerminalMessage("NO VISIBLE ISSUE")}
        ExpiredButton := button_regular{DefaultText := TerminalMessage("EXPIRED")}
        NameButton := button_regular{DefaultText := TerminalMessage("NAME MISMATCH")}
        PortraitButton := button_regular{DefaultText := TerminalMessage("PORTRAIT MISMATCH")}
        FlightButton := button_regular{DefaultText := TerminalMessage("WRONG FLIGHT")}
        GateButton := button_regular{DefaultText := TerminalMessage("WRONG GATE")}
        AccessButton := button_regular{DefaultText := TerminalMessage("RESTRICTED ACCESS")}
        SealButton := button_regular{DefaultText := TerminalMessage("SUSPICIOUS SEAL")}
        NeedsSecondaryButton := button_quiet{DefaultText := TerminalMessage("NEEDS SECONDARY")}
        NoIssueButton.OnClick().Subscribe(OnDocumentNoIssue)
        ExpiredButton.OnClick().Subscribe(OnDocumentExpired)
        NameButton.OnClick().Subscribe(OnDocumentNameMismatch)
        PortraitButton.OnClick().Subscribe(OnDocumentPortraitMismatch)
        FlightButton.OnClick().Subscribe(OnDocumentWrongFlight)
        GateButton.OnClick().Subscribe(OnDocumentWrongGate)
        AccessButton.OnClick().Subscribe(OnDocumentRestrictedAccess)
        SealButton.OnClick().Subscribe(OnDocumentSuspiciousSeal)
        NeedsSecondaryButton.OnClick().Subscribe(OnDocumentNeedsSecondary)
        ChoiceRowA := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := NoIssueButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := ExpiredButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := NameButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := PortraitButton}
        ChoiceRowB := stack_box:
            Orientation := orientation.Horizontal
            Slots := array:
                stack_box_slot{Widget := FlightButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := GateButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := AccessButton, Padding := margin{Right := 6.0}}
                stack_box_slot{Widget := SealButton}
        ReturnButton := button_loud{DefaultText := TerminalMessage("RETURN TO CHECKPOINT")}
        ReturnButton.OnClick().Subscribe(OnCloseDocument)
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 5.0}}
                stack_box_slot{Widget := Subheader, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := IdentityRow, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := Checks, Padding := margin{Bottom := 16.0}}
                stack_box_slot{Widget := ChoiceRowA, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := ChoiceRowB, Padding := margin{Bottom := 7.0}}
                stack_box_slot{Widget := NeedsSecondaryButton, Padding := margin{Bottom := 10.0}}
                stack_box_slot{Widget := ReturnButton}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(7, 16, 28)
                        DefaultOpacity := 0.97
                        DefaultDesiredSize := vector2{X := 860.0, Y := 900.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 30.0, Top := 26.0, Right := 30.0, Bottom := 26.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 860.0, Bottom := 900.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := Panel

        if (CaseId <> CurrentCaseId or ExpectedDocumentGeneration <> DocumentGeneration):
            return
        if (set DocumentRootUI[Player] = Root) {}
        if (set DocumentOpenCase[Player] = CaseId) {}
        if (set DocumentOpenGeneration[Player] = ExpectedDocumentGeneration) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All, ZOrder := 120})

    OnDocumentNoIssue(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.NoVisibleIssue)
    OnDocumentExpired(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.Expired)
    OnDocumentNameMismatch(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.NameMismatch)
    OnDocumentPortraitMismatch(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.PortraitMismatch)
    OnDocumentWrongFlight(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.WrongFlight)
    OnDocumentWrongGate(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.WrongGate)
    OnDocumentRestrictedAccess(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.RestrictedAccess)
    OnDocumentSuspiciousSeal(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.SuspiciousSeal)
    OnDocumentNeedsSecondary(Message:widget_message):void=
        CommitDocumentObservation(Message.Player, terminal_document_observation.NeedsSecondary)

    CommitDocumentObservation(Player:player, Observation:terminal_document_observation):void=
        if (OpenCase := DocumentOpenCase[Player], OpenCase <> CurrentCaseId):
            CloseDocumentInterface(Player)
            return
        if (OpenGeneration := DocumentOpenGeneration[Player], OpenGeneration <> DocumentGeneration):
            CloseDocumentInterface(Player)
            return
        if (Phase <> terminal_game_phase.Inspecting or DocumentsChecked? or PassengerLocation <> terminal_passenger_location.Documents or not PowerOnline?):
            CloseDocumentInterface(Player)
            return
        if (Owner := ClaimOwner?, Owner <> Player):
            CloseDocumentInterface(Player)
            return
        set DocumentObservation = Observation
        if (Observation = terminal_document_observation.NeedsSecondary):
            set ManualSearchRequested = true
        set DocumentsChecked = true
        set Phase = terminal_game_phase.AwaitingDecision
        CloseDocumentInterface(Player)
        SyncActiveCase()
        SetBoard(DocumentBoard, "DOCUMENT OBSERVATION | CASE {CurrentCaseId} | {DocumentObservationLabel(Observation)}")
        ShowAll("DOCUMENT OBSERVATION RECORDED | Passenger proceeding to the decision position.", 5.0)
        spawn{MovePassengerToDecision(CurrentCaseId, RunGeneration)}

    DocumentObservationLabel(Observation:terminal_document_observation):string=
        if (Observation = terminal_document_observation.NoVisibleIssue):
            return "NO VISIBLE ISSUE"
        if (Observation = terminal_document_observation.Expired):
            return "EXPIRED"
        if (Observation = terminal_document_observation.NameMismatch):
            return "NAME MISMATCH"
        if (Observation = terminal_document_observation.PortraitMismatch):
            return "PORTRAIT MISMATCH"
        if (Observation = terminal_document_observation.WrongFlight):
            return "WRONG FLIGHT"
        if (Observation = terminal_document_observation.WrongGate):
            return "WRONG GATE"
        if (Observation = terminal_document_observation.RestrictedAccess):
            return "RESTRICTED ACCESS"
        if (Observation = terminal_document_observation.SuspiciousSeal):
            return "SUSPICIOUS SEAL"
        if (Observation = terminal_document_observation.NeedsSecondary):
            return "NEEDS SECONDARY"
        "PENDING"

    PassengerVariantCode(Template:int)<computes>:string=
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return "B"
        if (Template = 3 or Template = 6 or Template = 9 or Template = 12):
            return "C"
        "A"

    PortraitBackgroundColor(Template:int):color=
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return MakeColorFromSRGBValues(48, 69, 102)
        if (Template = 3 or Template = 6 or Template = 9 or Template = 12):
            return MakeColorFromSRGBValues(36, 86, 83)
        MakeColorFromSRGBValues(38, 54, 76)

    PortraitSkinColor(Template:int):color=
        if (Template = 2 or Template = 4 or Template = 7 or Template = 10):
            return MakeColorFromSRGBValues(112, 72, 49)
        if (Template = 3 or Template = 6 or Template = 9 or Template = 12):
            return MakeColorFromSRGBValues(198, 143, 101)
        MakeColorFromSRGBValues(224, 181, 142)

    PortraitHairColor(Template:int):color=
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return MakeColorFromSRGBValues(188, 122, 42)
        if (Template = 3 or Template = 6 or Template = 9 or Template = 12):
            return MakeColorFromSRGBValues(18, 21, 29)
        MakeColorFromSRGBValues(82, 45, 31)

    PortraitClothingColor(Template:int):color=
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return MakeColorFromSRGBValues(155, 54, 61)
        if (Template = 3 or Template = 6 or Template = 9 or Template = 12):
            return MakeColorFromSRGBValues(45, 141, 118)
        MakeColorFromSRGBValues(48, 96, 173)

    CurrentShiftDate()<computes>:string=
        "2026-07-30"

    IssuingSeal(Template:int)<computes>:string=
        if (Template = 4):
            return "ASTRA / 41-AX / 39"
        if (Template = 12):
            return "ASTRA / VEIL-44 / VEIL-44"
        "ASTRA / 41-AX / 41"

    ManifestName(Template:int)<computes>:string=
        if (Template = 5):
            return "PAX MERIDIAN-S"
        IdentityName(Template)

    ManifestFlightAndGate(Template:int)<computes>:string=
        if (Template = 10):
            return "AT-310 / A5 | A3 CLOSED"
        FlightAndGate(Template)

    ManifestAccess(Template:int)<computes>:string=
        if (Template = 9):
            return "SECURE TIER 2"
        AccessLevel(Template)

    OnCloseDocument(Message:widget_message):void=
        Player := Message.Player
        CloseDocumentInterface(Player)
        if (Owner := ClaimOwner?, Owner = Player, ClaimStage = terminal_claim_stage.Documents, not ResolutionCommitted?):
            set ClaimStage = terminal_claim_stage.None
            if (Phase = terminal_game_phase.Inspecting):
                set Phase = terminal_game_phase.CaseReady
            RefreshClaimLease(Player)
            SyncActiveCase()
            ShowAgent(Player, "DOCUMENT REVIEW CLOSED | Your case ownership is retained; reopen to submit an observation.", 4.0)

    CloseDocumentInterface(Player:player):void=
        if (Root := DocumentRootUI[Player], PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Root)
        if (set DocumentOpenCase[Player] = -1) {}
        if (set DocumentOpenGeneration[Player] = -1) {}

    CloseAllDocumentInterfaces():void=
        for (Player : GetPlayspace().GetPlayers()):
            CloseDocumentInterface(Player)

    OnClearButton(Agent:agent):void=
        # The detector-side green PASS control is the existing authoritative
        # ClearButton. Reusing it preserves scoring, routing, and exactly-once
        # resolution instead of creating a second decision path.
        ResolveDecision(Agent, terminal_decision.Clear)

    OnSecondaryButton(Agent:agent):void=
        # The detector-side red NO PASS control preserves the project's staged
        # rules: it routes the same active passenger to Secondary, where the
        # later release/detain choice remains authoritative.
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        Ready := BaseEvidenceComplete()
        if (not Ready? or PassengerLocation <> terminal_passenger_location.Decision):
            ShowAgent(Agent, "Complete the required checks before Secondary.", 4.0)
            return
        if (SecondaryChecked?):
            ShowAgent(Agent, "SECONDARY already completed for Case {CurrentCaseId}.", 4.0)
            return
        if (not IsAgentNear(Agent, SecondaryButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE YELLOW SECONDARY CONTROL BESIDE THE DETECTOR.", 4.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Secondary)
        if (not Claimed?):
            return

        var ChargeMessage:string = "SECONDARY AUTHORIZED"
        if (not SecondaryCostPaid?):
            set TeamCash -= SecondaryScreeningCost
            set SecondaryCostPaid = true
            set SecondaryFeeAmount = SecondaryScreeningCost
            if (TeamCash < 0):
                set ChargeMessage = "SECONDARY AUTHORIZED | ${SecondaryScreeningCost} OPERATIONS CREDIT"
            else:
                set ChargeMessage = "SECONDARY AUTHORIZED | ${SecondaryScreeningCost} CHARGED"
        set Phase = terminal_game_phase.SecondaryScreening
        set CurrentDestination = terminal_case_destination.Secondary
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        CloseAllDocumentInterfaces()
        if (PassengerLocation <> terminal_passenger_location.SecondaryPassenger):
            set SecondaryPassengerReady = false
        if (BagLocation <> terminal_bag_location.SecondaryTable):
            set SecondaryBagReady = false
        set CurrentCustodyMode = 4
        SetDecisionControlsAvailable(false)
        CustodyButton.Disable()
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        SyncActiveCase()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | ROUTING TO SECONDARY")
        SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER + LINKED BAG IN TRANSIT")
        ShowAll("{ChargeMessage} | Follow the passenger and linked bag to the three physical stations.", 8.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Routed|CaseId={CurrentCaseId}|Template={CurrentTemplate}")
        if (PassengerLocation <> terminal_passenger_location.SecondaryPassenger):
            spawn{MovePassengerToSecondary(CurrentCaseId, RunGeneration)}
        if (Shift >= 2 and BagLocation <> terminal_bag_location.SecondaryTable):
            set BagGeneration += 1
            spawn{MoveActiveBagToSecondary(CurrentCaseId, RunGeneration, BagGeneration, ActiveBagIndex)}
        else:
            set SecondaryBagReady = true
            SecondaryBagButton.Enable()

    OnDetainButton(Agent:agent):void=
        if (Phase = terminal_game_phase.Runner):
            CaptureRunner(Agent)
            return
        if (Phase = terminal_game_phase.Custody and CurrentCustodyMode = 1):
            SecureCompliantSuspect(Agent)
            return
        ResolveDecision(Agent, terminal_decision.Detain)

    ResolveDecision(Agent:agent, Decision:terminal_decision):void=
        DecisionEligible := CanUseDecisionStation(Agent, Decision)
        if (not DecisionEligible?):
            return
        if (ResolutionCommitted?):
            TerminalLog(DebugEnabled, "[DECISION] Duplicate rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Decision)
        if (not Claimed?):
            return

        set ResolutionCommitted = true
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        CloseAllDocumentInterfaces()
        set Phase = terminal_game_phase.Resolving
        SyncActiveCase()
        ShowDecisionSubmitted(Decision)
        DecisionPressAudio.Play()
        Expected := CurrentExpectedDecision()
        if (Decision = Expected):
            PositiveAudio.Play()
        else:
            NegativeAudio.Play()
        TerminalLog(DebugEnabled, "[DECISION] CaseId={CurrentCaseId}|Submitted={DecisionLabel(Decision)}|Expected={DecisionLabel(Expected)}")

        if (CurrentTemplate = 12):
            CommitFinalCaseAccounting(Decision, Expected)
            if (Decision = terminal_decision.Detain):
                BeginBoss(true)
            else:
                BeginBoss(false)
            return

        if (Decision = Expected):
            set CorrectDecisions += 1
            if (Decision = terminal_decision.Detain):
                BeginDetention()
                return
            else if (Decision = terminal_decision.Secondary):
                Payout := CorrectPayout(125)
                set TeamCash += Payout
                ShowAll("CORRECT SECONDARY | Supervisor resolved the administrative hold | +{Payout} cash.", 6.0)
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY HOLD COMPLETE | DEPARTING")
            else:
                Payout := CorrectPayout(100)
                set TeamCash += Payout
                ShowAll("CORRECT CLEAR | Traveler proceeds to departures | +{Payout} cash.", 5.0)
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | CLEARED | DEPARTING")
        else:
            if (Decision = terminal_decision.Detain):
                set FalseDetentions += 1
                set TeamCash -= 100
                RaiseRisk(4)
                DamageIntegrity(5, "False detention")
                ShowAll("FALSE DETENTION | Supervisor released the traveler | -5 integrity, +4 risk.", 6.0)
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | FALSE DETENTION | RELEASED")
            else:
                set MissedThreats += 1
                set TeamCash -= 150
                RaiseRisk(18)
                DamageIntegrity(12, "Missed threat")
                ShowAll("MISSED THREAT | Integrity -12, Risk +18. The suspect may reinforce a breach.", 7.0)
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | THREAT MISSED | ESCAPING")

        if (Phase = terminal_game_phase.Results):
            return
        spawn{MovePassengerToDepartureAndFinish(CurrentCaseId, RunGeneration)}

    BeginDetention():void=
        set CustodyCommitted = false
        set PassengerAtIntake = false
        CustodyButton.Disable()
        JailOccupant.Hide()
        SetBoard(CellBoard, "DETENTION CELL | OPEN FOR INTAKE")
        if (CurrentTemplate = 8):
            set CurrentCustodyMode = 2
            set Phase = terminal_game_phase.Runner
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER | INTERCEPT AT DECISION LANE")
            SetBoard(CustodyBoard, "RUNNER ACTIVE | CLOSE-RANGE REMOTE CAPTURE")
            ResponseGranter.Enable()
            ResponseRemote.Enable()
            for (Player : GetPlayspace().GetPlayers()):
                ResponseGranter.GrantItem(Player)
            ShowAll("RUNNER | Signal Remote A issued. Chase the suspect and use PRIMARY FIRE only at close range.", 8.0)
            spawn{RunnerEscape(CurrentCaseId, RunGeneration)}
            return
        if (CurrentTemplate = 9):
            set CurrentCustodyMode = 3
            StartResponseEvent()
            return
        set CurrentCustodyMode = 1
        set Phase = terminal_game_phase.Custody
        CustodyButton.Disable()
        DetainButton.SetInteractionText(TerminalMessage("SECURE SUSPECT"))
        DetainButton.Enable()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | DETAINED | SECURE AT CLOSE RANGE")
        SetBoard(CustodyBoard, "CUSTODY PENDING | SECURE SUSPECT AT RED PAD")
        ShowAll("CORRECT DETAIN | Approach the suspect at the red pad and use SECURE SUSPECT before escort begins.", 7.0)
        spawn{MovePassengerToSecurePad(CurrentCaseId, RunGeneration)}

    SecureCompliantSuspect(Agent:agent):void=
        if (Phase <> terminal_game_phase.Custody or CurrentCustodyMode <> 1):
            return
        # The secure pad sits beyond the compact detector console. Keep this
        # close-range, but include the normal officer interaction position so
        # the player never has to climb over the console to start the escort.
        if (not IsAgentNearActivePassenger(Agent, 800.0)?):
            ShowAgent(Agent, "TOO FAR TO SECURE | Move beside the suspect at the red pad.", 4.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote secure rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Custody)
        if (not Claimed?):
            return
        set CurrentCustodyMode = 5
        DetainButton.Disable()
        DetainButton.SetInteractionText(TerminalMessage("JAIL | DETAIN PASSENGER"))
        SetBoard(CustodyBoard, "SUSPECT SECURED | ESCORTING TO INTAKE")
        OfficerTransferred := PositionOfficerAtCustody(Agent)
        if (OfficerTransferred?):
            ShowAll("SUSPECT SECURED | Officer transferred to detention intake. Await the escort, then use JAIL INTAKE.", 6.0)
        else:
            ShowAll("SUSPECT SECURED | Detention transfer obstructed. Follow the marked escort route to JAIL INTAKE.", 6.0)
        TerminalLog(DebugEnabled, "[CUSTODY] Close-range secure complete|CaseId={CurrentCaseId}")
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    CaptureRunner(Agent:agent):void=
        if (Phase <> terminal_game_phase.Runner):
            return
        if (not IsAgentNearActivePassenger(Agent, RunnerCaptureRadius)?):
            ShowAgent(Agent, "RUNNER TOO FAR | Chase until the suspect is inside capture range.", 5.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote runner capture rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Response)
        if (not Claimed?):
            return
        CleanupResponseEquipment()
        set CurrentCustodyMode = 5
        set Phase = terminal_game_phase.Custody
        CustodyButton.Disable()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER INTERCEPTED")
        SetBoard(CustodyBoard, "RUNNER SECURED | ESCORTING TO INTAKE")
        ShowAll("RUNNER INTERCEPTED AT CLOSE RANGE | Escort moving to detention intake.", 6.0)
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    OnCustodyButton(Agent:agent):void=
        if (Phase = terminal_game_phase.BossSecure):
            CompleteBossCustody(Agent)
            return
        if (Phase <> terminal_game_phase.Custody):
            ShowAgent(Agent, "No suspect is ready for detention intake.", 4.0)
            return
        if (not PassengerAtIntake?):
            ShowAgent(Agent, "SUSPECT IN TRANSIT | Wait for detention intake to report ready.", 4.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Premature intake rejected for CaseId={CurrentCaseId}")
            return
        if (not IsAgentNear(Agent, CustodyButton.GetTransform().Translation, CustodyProximityRadius)?):
            ShowAgent(Agent, "TOO FAR FROM INTAKE | Escort the secured suspect to the jail gate.", 5.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote intake rejected for CaseId={CurrentCaseId}")
            return
        if (CustodyCommitted?):
            TerminalLog(DebugEnabled, "[CUSTODY] Duplicate intake rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Custody)
        if (not Claimed?):
            return
        set CustodyCommitted = true
        set PassengerAtIntake = false
        set Phase = terminal_game_phase.Resolving
        set CurrentDestination = terminal_case_destination.Cell
        SyncActiveCase()
        CustodyButton.Disable()
        CustodyPayout := CorrectPayout(175)
        set TeamCash += CustodyPayout
        LowerRisk(2)
        SetBoard(CustodyBoard, "CASE {CurrentCaseId} | JAILED | INTAKE COMPLETE")
        SetBoard(CellBoard, "CELL GATE CLOSING | CASE {CurrentCaseId}")
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | ARREST COMPLETE | +{CustodyPayout}")
        ShowAll("JAIL INTAKE COMPLETE | Arrest finalized exactly once | +{CustodyPayout} cash.", 6.0)
        PositiveAudio.Play()
        spawn{MovePassengerIntoCellAndFinish(CurrentCaseId, RunGeneration)}

    OnSecondaryPassengerButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.SecondaryScreening or not SecondaryPassengerReady? or PassengerLocation <> terminal_passenger_location.SecondaryPassenger):
            ShowAgent(Agent, "SECONDARY PASSENGER STATION LOCKED | Wait for physical arrival.", 4.0)
            return
        if (not IsAgentNear(Agent, SecondaryPassengerButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE PASSENGER INSPECTION MARKER.", 4.0)
            return
        if (SecondaryPassengerChecked?):
            ShowAgent(Agent, "PASSENGER REGIONS already inspected.", 3.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Secondary)
        if (not Claimed?):
            return
        set SecondaryPassengerRegions += 1
        ScannerStartAudio.Play()
        if (SecondaryPassengerRegions < 2):
            SetBoard(SecondaryBoard, "PASSENGER CHECK 1/2 | UPPER REGION COMPLETE\nINSPECT LOWER REGION")
            ShowAgent(Agent, "HAND-WAND PASS 1/2 | Upper region sampled. Reposition for the lower-region pass.", 5.0)
            return
        set SecondaryPassengerChecked = true
        SecondaryPassengerButton.Disable()
        SetBoard(SecondaryBoard, "PASSENGER CHECK COMPLETE | TWO REGIONS SAMPLED\nBAG + RECORDS PENDING")
        ShowAll("SECONDARY PASSENGER CHECK COMPLETE | Two physical regions recorded.", 4.0)
        TryCompleteSecondary()

    OnSecondaryBagButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.SecondaryScreening or not SecondaryBagReady? or BagLocation <> terminal_bag_location.SecondaryTable):
            ShowAgent(Agent, "SECONDARY BAG STATION LOCKED | Wait for the linked bag at the search table.", 4.0)
            return
        if (not IsAgentNear(Agent, SecondaryBagButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE MANUAL-SEARCH TABLE.", 4.0)
            return
        if (SecondaryBagChecked?):
            ShowAgent(Agent, "LINKED BAG compartments already searched.", 3.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Secondary)
        if (not Claimed?):
            return
        set SecondaryBagHotspots += 1
        BagScanAudio.Play()
        if (SecondaryBagHotspots = 1):
            SetBoard(SecondaryBoard, "BAG SEARCH 1/3 | OUTER POCKET OPEN\nMAIN COMPARTMENT PENDING")
            ShowAgent(Agent, "BAG HOTSPOT 1/3 | Outer pocket inspected. Move along the table to continue.", 5.0)
            return
        if (SecondaryBagHotspots = 2):
            SetBoard(SecondaryBoard, "BAG SEARCH 2/3 | MAIN COMPARTMENT OPEN\nLINING CHECK PENDING")
            ShowAgent(Agent, "BAG HOTSPOT 2/3 | Main compartment inspected. Check the lining next.", 5.0)
            return
        set SecondaryBagChecked = true
        SecondaryBagButton.Disable()
        SetBoard(SecondaryBoard, "BAG SEARCH COMPLETE | THREE COMPARTMENTS\n{SecondaryBagVisualResult(CurrentTemplate)}")
        ShowAll("SECONDARY BAG SEARCH COMPLETE | Three physical compartments recorded.", 4.0)
        TryCompleteSecondary()

    OnSecondaryRecordsButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.SecondaryScreening or not SecondaryPassengerReady?):
            ShowAgent(Agent, "SECONDARY RECORDS TERMINAL LOCKED | Stage the passenger first.", 4.0)
            return
        if (not IsAgentNear(Agent, SecondaryRecordsButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE RECORDS TERMINAL.", 4.0)
            return
        if (SecondaryRecordsChecked?):
            ShowAgent(Agent, "RECORDS REVIEW already completed.", 3.0)
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Secondary)
        if (not Claimed?):
            return
        set SecondaryRecordsChecked = true
        SecondaryRecordsButton.Disable()
        SetBoard(SecondaryBoard, "RECORDS REVIEW COMPLETE\n{SecondaryPassengerClue(CurrentTemplate)}")
        ShowAgent(Agent, "RECORDS REVIEW COMPLETE | Compare this source with your earlier document observation.", 5.0)
        TryCompleteSecondary()

    SecondaryRecordsRequired()<transacts>:logic=
        if (CurrentTemplate = 3 or CurrentTemplate = 5 or CurrentTemplate = 9 or CurrentTemplate = 10 or CurrentTemplate = 12):
            return true
        if (DocumentObservation = terminal_document_observation.NeedsSecondary):
            return true
        false

    TryCompleteSecondary():void=
        if (SecondaryChecked? or not SecondaryPassengerChecked? or not SecondaryBagChecked?):
            return
        if (SecondaryRecordsRequired()? and not SecondaryRecordsChecked?):
            SetBoard(SecondaryBoard, "PASSENGER + BAG COMPLETE\nRECORDS TERMINAL REQUIRED")
            return
        set SecondaryChecked = true
        set SecondaryActionStage = 3
        set CurrentCustodyMode = 0
        set Phase = terminal_game_phase.AwaitingDecision
        set CurrentDestination = terminal_case_destination.Secondary
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        SetSecondaryFinalControls()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY OBSERVATIONS COMPLETE")
        SetBoard(SecondaryBoard, "SECONDARY COMPLETE\nPASS AT DETECTOR OR DETAIN AT CUSTODY DESK")
        SyncActiveCase()
        ReleaseStationClaim(terminal_claim_stage.Secondary, "SECONDARY", "PHYSICAL HANDOFF COMPLETE")
        ShowAll("SECONDARY COMPLETE | Passenger and linked bag remain staged for final Release or Detain.", 7.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Physical stations complete|CaseId={CurrentCaseId}|PassengerRegions={SecondaryPassengerRegions}|BagHotspots={SecondaryBagHotspots}")

    SecondaryBagVisualResult(Template:int)<computes>:string=
        if (Template = 7):
            return "DENSE CELL ARRAY VISIBLE"
        if (Template = 4 or Template = 8 or Template = 12):
            return "SHIELDED MODULE VISIBLE"
        "ROUTINE PERSONAL ITEMS VISIBLE"

    CompleteSecondaryCheck(Agent:agent):void=
        if (Phase <> terminal_game_phase.SecondaryScreening or CurrentCustodyMode <> 4):
            return
        if (not SecondaryPassengerReady?):
            ShowAgent(Agent, "SECONDARY PASSENGER IN TRANSIT | Wait for the room status to turn ready.", 4.0)
            return
        if (Shift >= 2, not SecondaryBagReady?):
            ShowAgent(Agent, "SECONDARY BAG IN TRANSIT | Wait for the linked bag at the inspection table.", 4.0)
            return
        if (not IsAgentNear(Agent, LegacyCustodyOrigin(), 750.0)?):
            ShowAgent(Agent, "SECONDARY CHECK OUT OF RANGE | Enter the controlled screening room.", 5.0)
            return
        if (SecondaryChecked?):
            TerminalLog(DebugEnabled, "[SECONDARY] Duplicate check rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Secondary)
        if (not Claimed?):
            return
        if (SecondaryActionStage = 0):
            set SecondaryActionStage = 1
            CustodyButton.SetInteractionText(TerminalMessage("SECONDARY STEP 2 | MANUAL BAG / RECORD CHECK"))
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | TRACE + ID CHECK | {SecondaryPassengerClue(CurrentTemplate)}")
            SetBoard(SecondaryBoard, "SECONDARY 1/2 COMPLETE\nPERFORM MANUAL BAG / RECORD CHECK")
            ShowAll("SECONDARY 1/2 | {SecondaryPassengerClue(CurrentTemplate)} | Use the station again for the linked-bag and record check.", 7.0)
            TerminalLog(DebugEnabled, "[SECONDARY] Passenger check complete|CaseId={CurrentCaseId}|Template={CurrentTemplate}")
            return
        set SecondaryChecked = true
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set CurrentCustodyMode = 0
        set SecondaryCostPaid = false
        set SecondaryFeeAmount = 0
        set SecondaryActionStage = 2
        set Phase = terminal_game_phase.AwaitingDecision
        set CurrentDestination = terminal_case_destination.Decision
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        SetSecondaryFinalControls()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY RESULT | {SecondaryResultText(CurrentTemplate)}")
        SetBoard(SecondaryBoard, "SECONDARY 2/2 COMPLETE\nPASS AT DETECTOR OR DETAIN")
        SyncActiveCase()
        ShowAll("SECONDARY 2/2 COMPLETE | {SecondaryResultText(CurrentTemplate)} | Use PASS at the detector console or DETAIN at the custody desk.", 8.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Completed|CaseId={CurrentCaseId}|Template={CurrentTemplate}")

    RunnerEscape(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Departure
        SyncActiveCase()
        var EscapeReached:logic = false
        if (Shift = 4):
            RouteA := MoveActivePassengerChecked(
                RunnerRouteAPosition(),
                SecurePadPosition(),
                4.0,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Transit,
                "runner-route-a"
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                return
            ExitA := MoveActivePassengerChecked(
                RunnerExitAPosition(),
                RunnerRouteAPosition(),
                6.0,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Departure,
                "runner-exit-a"
            )
            if (RouteA? and ExitA?):
                set EscapeReached = true
        else:
            RouteB := MoveActivePassengerChecked(
                RunnerRouteBPosition(),
                OffsetPosition(DecisionPassengerPosition(), 300.0, -350.0, 0.0),
                4.0,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Transit,
                "runner-route-b"
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                return
            ExitB := MoveActivePassengerChecked(
                RunnerExitBPosition(),
                RunnerRouteBPosition(),
                6.0,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Departure,
                "runner-exit-b"
            )
            if (RouteB? and ExitB?):
                set EscapeReached = true
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Runner):
            set Phase = terminal_game_phase.Resolving
            CleanupResponseEquipment()
            ActivePassengerDevice().Hide()
            if (not EscapeReached?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER ROUTE FAILED | SAFE CONTAINMENT")
                SetBoard(CustodyBoard, "DETENTION INTAKE | ROUTE FAILURE | NO ESCAPE PENALTY")
                ShowAll("RUNNER ROUTE FAILED | Safe containment completed. No escape penalty was applied.", 6.0)
                TerminalLog(DebugEnabled, "[MOVE] Runner route failure resolved without escape penalty|CaseId={CurrentCaseId}")
                FinishCase()
                return
            RaiseRisk(16)
            DamageIntegrity(10, "Runner escaped")
            if (Phase = terminal_game_phase.Results):
                return
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER ESCAPED")
            SetBoard(CustodyBoard, "DETENTION INTAKE | ESCAPE RECORDED")
            ShowAll("RUNNER ESCAPED | Integrity -10, Risk +16. Lane recovery started.", 7.0)
            FinishCase()

    MovePassengerToDepartureAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Departure
        set BagLocation = terminal_bag_location.ClearedExit
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            DeparturePosition(),
            DepartureRetryPosition(),
            3.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Departure,
            "departure"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            if (not MoveReached?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | DEPARTURE ROUTE RESET")
            ActivePassengerDevice().Hide()
            FinishCase()

    MovePassengerToIntake(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Detention
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            IntakePosition(),
            SecurePadPosition(),
            4.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.DetentionIntake,
            "detention-intake"
        )
        var VerifiedArrival:logic = false
        if (MoveReached?, IsActivePassengerNear(IntakePosition(), 325.0)?):
            set VerifiedArrival = true
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Custody):
            if (VerifiedArrival?):
                set PassengerAtIntake = true
                CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
                CustodyButton.Enable()
                SetBoard(CustodyBoard, "CASE {CurrentCaseId} AT INTAKE | SECURE NOW")
            else:
                set PassengerAtIntake = false
                CustodyButton.Disable()
                SetBoard(CustodyBoard, "CASE {CurrentCaseId} INTAKE ROUTE FAULT | ARRIVAL NOT VERIFIED")
                ShowAll("CUSTODY ROUTE FAULT | Intake remains locked because suspect arrival was not verified.", 7.0)
                TerminalLog(DebugEnabled, "[CUSTODY] Intake arrival verification failed|CaseId={CurrentCaseId}")
        else if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.BossSecure):
            if (VerifiedArrival?):
                set PassengerAtIntake = true
                CustodyButton.SetInteractionText(TerminalMessage("FINAL CUSTODY INTAKE"))
                CustodyButton.Enable()
                SetBoard(CustodyBoard, "FINAL THREAT AT INTAKE | SECURE NOW")
            else:
                set PassengerAtIntake = false
                CustodyButton.Disable()
                SetBoard(CustodyBoard, "FINAL THREAT ROUTE FAULT | ARRIVAL NOT VERIFIED")
                TerminalLog(DebugEnabled, "[BOSS] Final intake arrival verification failed|CaseId={CurrentCaseId}")

    MovePassengerToSecurePad(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Detention
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            SecurePadPosition(),
            DecisionPassengerPosition(),
            1.5,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.SecurePad,
            "secure-pad"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Custody and CurrentCustodyMode = 1):
            if (MoveReached?):
                SetBoard(CustodyBoard, "SUSPECT AT RED PAD | SECURE AT CLOSE RANGE")
            else:
                set CurrentCustodyMode = 5
                DetainButton.Disable()
                SetBoard(CustodyBoard, "SECURE-PAD ROUTE FAILED | ESCORTING TO INTAKE")
                spawn{MovePassengerToIntake(ExpectedCaseId, ExpectedRun)}

    MovePassengerToSecondary(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Secondary
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            SecondaryPassengerPosition(),
            IntakePosition(),
            4.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.SecondaryPassenger,
            "secondary"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.SecondaryScreening and CurrentCustodyMode = 4):
            if (MoveReached?):
                set SecondaryPassengerReady = true
                SecondaryPassengerButton.Enable()
                SecondaryRecordsButton.Enable()
                if (Shift < 2 or SecondaryBagReady?):
                    SetBoard(SecondaryBoard, "SECONDARY READY\nPASSENGER + BAG PRESENT")
                else:
                    SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER READY | BAG IN TRANSIT")
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER IN SECONDARY ROOM")
            else:
                AbortSecondaryRouting("Passenger could not reach the controlled room")
            SyncActiveCase()

    MoveActiveBagToSecondary(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, BagIndex:int)<suspends>:void=
        var BagReached:logic = false
        if (BagIndex = 0):
            set BagReached = MovePropChecked(
                BagPropSmall,
                SecondaryBagPosition(),
                BagExitPosition(),
                2.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "secondary-bag-small"
            )
        else if (BagIndex = 1):
            set BagReached = MovePropChecked(
                BagPropMedium,
                SecondaryBagPosition(),
                BagExitPosition(),
                2.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "secondary-bag-medium"
            )
        else:
            set BagReached = MovePropChecked(
                BagPropHardShell,
                SecondaryBagPosition(),
                BagExitPosition(),
                2.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "secondary-bag-hard-shell"
            )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration or Phase <> terminal_game_phase.SecondaryScreening):
            return
        if (BagReached?):
            set SecondaryBagReady = true
            set BagLocation = terminal_bag_location.SecondaryTable
            SecondaryBagButton.Enable()
            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | SECONDARY TABLE READY")
            if (SecondaryPassengerReady?):
                SetBoard(SecondaryBoard, "SECONDARY READY\nPASSENGER + BAG PRESENT")
            SyncActiveCase()
        else:
            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | SECONDARY ROUTE FAULT")
            AbortSecondaryRouting("Linked bag could not reach the inspection table")

    AbortSecondaryRouting(Reason:string):void=
        if (Phase <> terminal_game_phase.SecondaryScreening):
            return
        if (SecondaryCostPaid?):
            set TeamCash += SecondaryFeeAmount
        set SecondaryCostPaid = false
        set SecondaryFeeAmount = 0
        set SecondaryActionStage = 0
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set CurrentCustodyMode = 0
        set Phase = terminal_game_phase.AwaitingDecision
        set CurrentDestination = terminal_case_destination.Decision
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        RefreshDecisionControls()
        SetBoard(SecondaryBoard, "SECONDARY ROUTE OFFLINE\nCOST REFUNDED | RETURN TO DETECTOR")
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY ABORTED | COST REFUNDED")
        SyncActiveCase()
        ShowAll("SECONDARY ABORTED | {Reason}. ${SecondaryScreeningCost} refunded; return to CLEAR or DETAIN.", 8.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Route aborted and refunded|CaseId={CurrentCaseId}|Reason={Reason}")

    MovePassengerToResponse(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Response
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            ResponsePassengerPosition(),
            ResponsePassengerRetryPosition(),
            4.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Response,
            "response"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.HostileResponse):
            if (MoveReached?):
                SetBoard(EmergencyBoard, "THREAT IN RESPONSE ZONE | RESPOND TO INCAPACITATE")
            else:
                SetBoard(EmergencyBoard, "THREAT ROUTE FALLBACK | RESPONSE CONTROLS ACTIVE")
        else if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and (Phase = terminal_game_phase.BossJammer or Phase = terminal_game_phase.BossBreach or Phase = terminal_game_phase.BossVulnerable)):
            if (MoveReached?):
                SetBoard(EmergencyBoard, "FINAL THREAT IN RESPONSE ZONE | COMPLETE CURRENT STAGE")
            else:
                SetBoard(EmergencyBoard, "FINAL ROUTE FALLBACK | COMPLETE CURRENT STAGE")

    MovePassengerIntoCellAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Cell
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            CellPosition(),
            IntakePosition(),
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Cell,
            "cell"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            Sleep(0.5)
            ActivePassengerDevice().Hide()
            JailOccupant.Show()
            if (MoveReached?):
                SetBoard(CellBoard, "CELL SECURED | OCCUPIED | CASE {CurrentCaseId}")
            else:
                SetBoard(CellBoard, "CELL SECURED BY SAFE TRANSFER | CASE {CurrentCaseId}")
            FinishCase()

    FinishCase():void=
        if (CaseCompletionCommitted?):
            TerminalLog(DebugEnabled, "[CASE] Duplicate completion rejected|CaseId={CurrentCaseId}|Run={RunGeneration}")
            return
        set CaseCompletionCommitted = true
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        CloseAllDocumentInterfaces()
        set TotalCasesResolved += 1
        set CasesInShift += 1
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        SyncActiveCase()
        TerminalLog(DebugEnabled, "[CASE] Complete|CaseId={CurrentCaseId}|Shift={Shift}|CasesInShift={CasesInShift}|Cash={TeamCash}|Integrity={TeamIntegrity}|Risk={TeamRisk}")

        if (CasesInShift >= CasesPerShift):
            if (Shift >= 4 and Shift <= 6):
                BeginEmergency()
            else:
                BeginUpgradeBreak()
        else:
            spawn{AdvanceQueueAndPrepare(CurrentCaseId, RunGeneration, QueueGeneration)}

    PrepareNextCase():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Disable()
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set CurrentCaseId += 1
        set CurrentTemplate = SelectTemplate(Shift, CasesInShift)
        set ActivePassengerSlot = QueueFrontIndex
        set PassengerGeneration += 1
        set PassengerLocation = terminal_passenger_location.QueueFront
        set PassengerTarget = terminal_passenger_location.QueueFront
        set BodyChecked = false
        set BodyObservation = terminal_body_observation.None
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set ScannerGeneration += 1
        set BagGeneration += 1
        set BagChecked = false
        set BagObservation = terminal_bag_observation.None
        set BagLocation = terminal_bag_location.Queue
        set BagScanInProgress = false
        set DocumentsChecked = false
        set DocumentObservation = terminal_document_observation.None
        set ManualSearchRequested = false
        set SecondaryChecked = false
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set SecondaryCostPaid = false
        set SecondaryFeeAmount = 0
        set SecondaryActionStage = 0
        set SecondaryPassengerChecked = false
        set SecondaryBagChecked = false
        set SecondaryRecordsChecked = false
        set SecondaryPassengerRegions = 0
        set SecondaryBagHotspots = 0
        set PassengerAtIntake = false
        set ResolutionCommitted = false
        set CaseCompletionCommitted = false
        set CustodyCommitted = false
        set FinalCaseAccountingCommitted = false
        set CurrentCustodyMode = 0
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set Phase = terminal_game_phase.CaseReady
        set CurrentDestination = terminal_case_destination.Scanner
        SyncActiveCase()
        # Each case gets a fresh scanner interaction after the prior completed
        # prompt was disabled to give PASS/JAIL prompt priority.
        ScanButton.Enable()
        SetDecisionControlsAvailable(false)
        DetainButton.SetInteractionText(TerminalMessage("JAIL | DETAIN PASSENGER"))
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        CustodyButton.Disable()
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | CASE {CurrentCaseId} READY")
        SetBoard(CaseBoard, "SHIFT {Shift} | CASE {CurrentCaseId} | {TemplateName(CurrentTemplate)}")
        SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | CONVEYOR INBOUND")
        SetBoard(
            DocumentBoard,
            "TRAVEL ID {CurrentCaseId} | {IdentityName(CurrentTemplate)} | {Destination(CurrentTemplate)} | CHECK PENDING"
        )
        SetBoard(CustodyBoard, "DETENTION INTAKE | NO ACTIVE CUSTODY")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        spawn{StagePassenger(CurrentCaseId, RunGeneration)}
        spawn{StageLinkedBag(CurrentCaseId, RunGeneration, BagGeneration, CurrentTemplate)}
        ShowAll("SHIFT {Shift}: {ShiftLabel(Shift)} | CASE {CurrentCaseId}: {TemplateName(CurrentTemplate)} | {EvidencePrompt()}", 8.0)
        TerminalLog(DebugEnabled, "[CASE] Ready|CaseId={CurrentCaseId}|Template={CurrentTemplate}|Shift={Shift}")

    StageLinkedBag(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, Template:int)<suspends>:void=
        HideAllBags()
        set ActiveBagIndex = BagIndexForTemplate(Template)
        SyncActiveCase()
        if (ActiveBagIndex = 0):
            StartReached := MovePropChecked(
                BagPropSmall,
                BagStagePosition(),
                BagStageRetryPosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-stage-small"
            )
            if (not StartReached? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropSmall.Show()
            ArrivalReached := MovePropChecked(
                BagPropSmall,
                BagEntryPosition(),
                BagStagePosition(),
                1.5,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-inbound-small"
            )
            if (not ArrivalReached?):
                return
        else if (ActiveBagIndex = 1):
            StartReached := MovePropChecked(
                BagPropMedium,
                BagStagePosition(),
                BagStageRetryPosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-stage-medium"
            )
            if (not StartReached? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropMedium.Show()
            ArrivalReached := MovePropChecked(
                BagPropMedium,
                BagEntryPosition(),
                BagStagePosition(),
                1.5,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-inbound-medium"
            )
            if (not ArrivalReached?):
                return
        else:
            StartReached := MovePropChecked(
                BagPropHardShell,
                BagStagePosition(),
                BagStageRetryPosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-stage-hard-shell"
            )
            if (not StartReached? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropHardShell.Show()
            ArrivalReached := MovePropChecked(
                BagPropHardShell,
                BagEntryPosition(),
                BagStagePosition(),
                1.5,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-inbound-hard-shell"
            )
            if (not ArrivalReached?):
                return
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and ExpectedBagGeneration = BagGeneration):
            set BagLocation = terminal_bag_location.ConveyorEntry
            SyncActiveCase()
            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | AT X-RAY | SCAN PENDING")

    HideAllBags():void=
        BagPropSmall.Hide()
        BagPropMedium.Hide()
        BagPropHardShell.Hide()
        set BagLocation = terminal_bag_location.Hidden

    BagIndexForTemplate(Template:int)<computes>:int=
        if (Template = 1 or Template = 4 or Template = 7 or Template = 10):
            return 0
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return 1
        2

    ActivePassengerDevice()<transacts>:character_device=
        if (ActivePassengerSlot = 0):
            return PassengerQueue1
        if (ActivePassengerSlot = 1):
            return PassengerQueue2
        PassengerQueue3

    StagePassenger(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set PassengerReadyForScan = false
        set CurrentDestination = terminal_case_destination.Scanner
        SyncActiveCase()
        ActivePassenger := ActivePassengerDevice()
        ActivePassenger.Show()
        MoveResult0 := MoveActivePassengerChecked(
            QueuePassengerStagePosition(),
            OffsetPosition(QueuePassengerStagePosition(), 0.0, -300.0, 0.0),
            0.6,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "scanner-stage"
        )
        if (not MoveResult0? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.CaseReady):
            SetBoard(CheckpointBoard, "PASSENGER ROUTE RESET | CASE {CurrentCaseId}")
            return
        MoveResult1 := MoveActivePassengerChecked(
            QueueSwitchbackEastSouthPosition(),
            QueuePassengerStagePosition(),
            2.4,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-east-south"
        )
        if (not MoveResult1? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult2 := MoveActivePassengerChecked(
            QueueSwitchbackEastMiddlePosition(),
            QueueSwitchbackEastSouthPosition(),
            0.8,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-east-turn"
        )
        if (not MoveResult2? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult3 := MoveActivePassengerChecked(
            QueueSwitchbackWestMiddlePosition(),
            QueueSwitchbackEastMiddlePosition(),
            2.4,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-west-middle"
        )
        if (not MoveResult3? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult4 := MoveActivePassengerChecked(
            QueueSwitchbackWestNorthPosition(),
            QueueSwitchbackWestMiddlePosition(),
            0.8,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-west-turn"
        )
        if (not MoveResult4? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult5 := MoveActivePassengerChecked(
            QueueSwitchbackEastNorthPosition(),
            QueueSwitchbackWestNorthPosition(),
            2.4,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-east-north"
        )
        if (not MoveResult5? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult6 := MoveActivePassengerChecked(
            QueueSwitchbackExitPosition(),
            QueueSwitchbackEastNorthPosition(),
            0.8,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-switchback-exit-turn"
        )
        if (not MoveResult6? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult7 := MoveActivePassengerChecked(
            QueueScannerLeadInPosition(),
            QueueSwitchbackExitPosition(),
            0.7,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Transit,
            "queue-scanner-lead-in"
        )
        if (not MoveResult7? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult8 := MoveActivePassengerChecked(
            ScannerEntryPosition(),
            QueueScannerLeadInPosition(),
            0.7,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.ScannerEntry,
            "scanner-position"
        )
        if (MoveResult8? and ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration):
            set PassengerReadyForScan = true
            SyncActiveCase()
            SetBoard(CheckpointBoard, "ACTIVE PASSENGER | CASE {CurrentCaseId} | BODY SCAN")

    MovePassengerToDecision(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Decision
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            DecisionPassengerPosition(),
            DocumentPassengerPosition(),
            3.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Decision,
            "decision"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT DETECTOR CONSOLE")
                ReleaseCurrentInspectionClaim("DECISION ARRIVAL VERIFIED")
                RefreshDecisionControls()
            else:
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | DECISION ROUTE FALLBACK")

    MovePassengerToBaggage(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Baggage
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            BaggagePassengerPosition(),
            BaggagePassengerRetryPosition(),
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Baggage,
            "baggage"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT BAGGAGE CONTROL")
                SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | X-RAY READY")
                ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", "BAGGAGE HANDOFF ARRIVED")
            else:
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | BAGGAGE ROUTE FALLBACK")

    MovePassengerToDocumentDesk(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Documents
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            DocumentPassengerPosition(),
            BaggagePassengerPosition(),
            1.5,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Documents,
            "documents"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT IDENTITY DESK")
                SetBoard(DocumentBoard, "TRAVEL ID {CurrentCaseId} | READER READY")
                ReleaseStationClaim(terminal_claim_stage.Baggage, "BAG X-RAY", "DOCUMENT HANDOFF ARRIVED")
            else:
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | IDENTITY ROUTE FALLBACK")

    ResetPassengerQueue(ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Queue
        SyncActiveCase()
        PassengerQueue1.Hide()
        PassengerQueue2.Hide()
        PassengerQueue3.Hide()
        Move1 := MoveCharacterChecked(
            PassengerQueue1,
            QueueFrontMarker,
            OffsetPosition(QueueFrontMarker, 0.0, -300.0, 0.0),
            0.1,
            CurrentCaseId,
            ExpectedRun,
            "queue-reset-front"
        )
        Move2 := MoveCharacterChecked(
            PassengerQueue2,
            QueueMiddleMarker,
            OffsetPosition(QueueMiddleMarker, 0.0, -300.0, 0.0),
            0.1,
            CurrentCaseId,
            ExpectedRun,
            "queue-reset-middle"
        )
        Move3 := MoveCharacterChecked(
            PassengerQueue3,
            QueueRearMarker,
            QueueRecyclePosition(),
            0.1,
            CurrentCaseId,
            ExpectedRun,
            "queue-reset-rear"
        )
        if (ExpectedRun <> RunGeneration):
            return
        if (Move1?):
            PassengerQueue1.Show()
        if (Move2?):
            PassengerQueue2.Show()
        if (Move3?):
            PassengerQueue3.Show()
        if (Move1? and Move2? and Move3?):
            SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | 3 PASSENGERS WAITING")
        else:
            SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | QUEUE ROUTE RECOVERY")

    AdvanceQueueAndPrepare(ExpectedCaseId:int, ExpectedRun:int, ExpectedQueueGeneration:int)<suspends>:void=
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedQueueGeneration <> QueueGeneration):
            return
        set QueueGeneration += 1
        ThisQueueGeneration := QueueGeneration
        set CurrentDestination = terminal_case_destination.Queue
        SyncActiveCase()

        if (QueueFrontIndex = 0):
            FrontMove := MoveCharacterChecked(
                PassengerQueue1,
                QueueAdvancePosition(),
                QueueFrontMarker,
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-1"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue2,
                QueueFrontMarker,
                QueueMiddleMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-2"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue3,
                QueueMiddleMarker,
                QueueRearMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-3"
            )
            PassengerQueue1.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue1,
                QueueRearMarker,
                QueueRecyclePosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                "queue-recycle-1"
            )
            if (Recycle?):
                PassengerQueue1.Show()
            set QueueFrontIndex = 1
        else if (QueueFrontIndex = 1):
            FrontMove := MoveCharacterChecked(
                PassengerQueue2,
                QueueAdvancePosition(),
                QueueFrontMarker,
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-2"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue3,
                QueueFrontMarker,
                QueueMiddleMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-3"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue1,
                QueueMiddleMarker,
                QueueRearMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-1"
            )
            PassengerQueue2.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue2,
                QueueRearMarker,
                QueueRecyclePosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                "queue-recycle-2"
            )
            if (Recycle?):
                PassengerQueue2.Show()
            set QueueFrontIndex = 2
        else:
            FrontMove := MoveCharacterChecked(
                PassengerQueue3,
                QueueAdvancePosition(),
                QueueFrontMarker,
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-3"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue1,
                QueueFrontMarker,
                QueueMiddleMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-1"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue2,
                QueueMiddleMarker,
                QueueRearMarker,
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-2"
            )
            PassengerQueue3.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue3,
                QueueRearMarker,
                QueueRecyclePosition(),
                0.1,
                ExpectedCaseId,
                ExpectedRun,
                "queue-recycle-3"
            )
            if (Recycle?):
                PassengerQueue3.Show()
            set QueueFrontIndex = 0

        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ThisQueueGeneration <> QueueGeneration):
            return
        PrepareNextCase()

    BeginUpgradeBreak():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        CloseAllUpgradeInterfaces()
        ResponseButton.Disable()
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set Phase = terminal_game_phase.UpgradeBreak
        set CurrentDestination = terminal_case_destination.None
        SetDecisionControlsAvailable(false)
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set PowerOnline = true
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set SecondaryCostPaid = false
        set SecondaryFeeAmount = 0
        set SecondaryActionStage = 0
        set SecondaryPassengerChecked = false
        set SecondaryBagChecked = false
        set SecondaryRecordsChecked = false
        set SecondaryPassengerRegions = 0
        set SecondaryBagHotspots = 0
        set PassengerAtIntake = false
        set PassengerLocation = terminal_passenger_location.QueueFront
        set PassengerTarget = terminal_passenger_location.QueueFront
        set BodyObservation = terminal_body_observation.None
        set BagObservation = terminal_bag_observation.None
        set DocumentObservation = terminal_document_observation.None
        set ManualSearchRequested = false
        set UpgradeBreakResolved = false
        set PowerRepairStage = 0
        set PowerRepairCommitted = false
        ScanButton.Enable()
        CustodyButton.Disable()
        SecondaryPassengerButton.Disable()
        SecondaryBagButton.Disable()
        SecondaryRecordsButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        DetainButton.SetInteractionText(TerminalMessage("JAIL | DETAIN PASSENGER"))
        PowerButton.Disable()
        ActivePassengerDevice().Hide()
        set BagGeneration += 1
        HideAllBags()
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | SHIFT CHANGE")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        SyncActiveCase()
        if (Shift >= 7):
            ShowAll("Final Boarding audit complete. Use RESPOND if the final threat is active.", 6.0)
            return
        ShowAll("SHIFT {Shift} COMPLETE | Cash {TeamCash} | Choose FAST SCAN, PAYOUT, EMERGENCY RESERVE, or CONTINUE.", 8.0)
        TerminalLog(DebugEnabled, "[SHIFT] Completed Shift={Shift}")

    OnUpgradeButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.UpgradeBreak):
            ShowAgent(Agent, "Upgrade desk is available only between shifts.", 4.0)
            return
        if (UpgradeBreakResolved?):
            return
        if (not IsHumanAgent(Agent)?):
            return
        if (AutomatedReplayEnabled?):
            ResolveUpgradeBreak("AUTOMATED QA CONTINUE")
            return
        if (Player := player[Agent]):
            if (OpenShift := UpgradeOpenShift[Player], OpenShift = Shift):
                ShowAgent(Agent, "Upgrade interface is already open.", 3.0)
                return
            OpenUpgradeInterface(Player)

    OpenUpgradeInterface(Player:player):void=
        if (Phase <> terminal_game_phase.UpgradeBreak or UpgradeBreakResolved?):
            return
        CloseUpgradeInterface(Player)
        Header := text_block:
            DefaultText := TerminalMessage("ASTRA SYSTEMS UPGRADE | SHIFT {Shift} COMPLETE")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 26.0
        CashReadout := text_block:
            DefaultText := TerminalMessage("TEAM CASH  ${TeamCash}  |  CHOOSE ONE UPGRADE OR CONTINUE")
            DefaultTextColor := NamedColors.LightCyan
            DefaultTextSize := 18.0
        ScannerDescription := text_block:
            DefaultText := TerminalMessage("FAST SCANNER\nShortens every staged body sweep for this run. Current level {ScannerUpgradeLevel}/3.")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 17.0
            AutoWrap := true
            WrapWidth := 560.0
        ScannerButton := button_loud{DefaultText := TerminalMessage(ScannerUpgradeLabel())}
        ScannerButton.OnClick().Subscribe(OnUpgradeScanner)
        PayoutDescription := text_block:
            DefaultText := TerminalMessage("ACCURACY PAYOUT\nAdds $40 to every correct routine resolution. Current level {PayoutUpgradeLevel}/3.")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 17.0
            AutoWrap := true
            WrapWidth := 560.0
        PayoutButton := button_loud{DefaultText := TerminalMessage(PayoutUpgradeLabel())}
        PayoutButton.OnClick().Subscribe(OnUpgradePayout)
        EmergencyDescription := text_block:
            DefaultText := TerminalMessage("EMERGENCY RESERVE\nAdds 10 seconds to future emergency response timers. Current level {EmergencyUpgradeLevel}/3.")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 17.0
            AutoWrap := true
            WrapWidth := 560.0
        EmergencyButton := button_loud{DefaultText := TerminalMessage(EmergencyUpgradeLabel())}
        EmergencyButton.OnClick().Subscribe(OnUpgradeEmergency)
        ContinueButton := button_quiet{DefaultText := TerminalMessage("CONTINUE WITHOUT PURCHASE")}
        ContinueButton.OnClick().Subscribe(OnUpgradeContinue)
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := CashReadout, Padding := margin{Bottom := 22.0}}
                stack_box_slot{Widget := ScannerDescription, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := ScannerButton, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := PayoutDescription, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := PayoutButton, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := EmergencyDescription, Padding := margin{Bottom := 8.0}}
                stack_box_slot{Widget := EmergencyButton, Padding := margin{Bottom := 24.0}}
                stack_box_slot{Widget := ContinueButton}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(7, 16, 28)
                        DefaultOpacity := 0.97
                        DefaultDesiredSize := vector2{X := 660.0, Y := 710.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 34.0, Top := 28.0, Right := 34.0, Bottom := 28.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 660.0, Bottom := 710.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := Panel
        if (set UpgradeRootUI[Player] = Root) {}
        if (set UpgradeOpenShift[Player] = Shift) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All, ZOrder := 125})

    OnUpgradeScanner(Message:widget_message):void=
        PurchaseUpgrade(Message.Player, 1)

    OnUpgradePayout(Message:widget_message):void=
        PurchaseUpgrade(Message.Player, 2)

    OnUpgradeEmergency(Message:widget_message):void=
        PurchaseUpgrade(Message.Player, 3)

    OnUpgradeContinue(Message:widget_message):void=
        if (Phase <> terminal_game_phase.UpgradeBreak or UpgradeBreakResolved?):
            return
        ResolveUpgradeBreak("NO UPGRADE PURCHASED")

    PurchaseUpgrade(Player:player, Choice:int):void=
        if (Phase <> terminal_game_phase.UpgradeBreak or UpgradeBreakResolved?):
            return
        if (Choice = 1):
            ScannerCost := ScannerUpgradeCost()
            if (ScannerUpgradeLevel >= 3):
                ShowAgent(Player, "FAST SCANNER is already at maximum level.", 4.0)
                return
            if (TeamCash < ScannerCost):
                ShowAgent(Player, "FAST SCANNER requires ${ScannerCost}. Team cash: ${TeamCash}.", 4.0)
                return
            set TeamCash -= ScannerCost
            set ScannerUpgradeLevel += 1
            set RunUpgradePurchased = true
            ResolveUpgradeBreak("FAST SCANNER LEVEL {ScannerUpgradeLevel} INSTALLED")
            return
        if (Choice = 2):
            PayoutCost := PayoutUpgradeCost()
            if (PayoutUpgradeLevel >= 3):
                ShowAgent(Player, "ACCURACY PAYOUT is already at maximum level.", 4.0)
                return
            if (TeamCash < PayoutCost):
                ShowAgent(Player, "ACCURACY PAYOUT requires ${PayoutCost}. Team cash: ${TeamCash}.", 4.0)
                return
            set TeamCash -= PayoutCost
            set PayoutUpgradeLevel += 1
            set RunUpgradePurchased = true
            ResolveUpgradeBreak("ACCURACY PAYOUT LEVEL {PayoutUpgradeLevel} INSTALLED")
            return
        EmergencyCost := EmergencyUpgradeCost()
        if (EmergencyUpgradeLevel >= 3):
            ShowAgent(Player, "EMERGENCY RESERVE is already at maximum level.", 4.0)
            return
        if (TeamCash < EmergencyCost):
            ShowAgent(Player, "EMERGENCY RESERVE requires ${EmergencyCost}. Team cash: ${TeamCash}.", 4.0)
            return
        set TeamCash -= EmergencyCost
        set EmergencyUpgradeLevel += 1
        set RunUpgradePurchased = true
        ResolveUpgradeBreak("EMERGENCY RESERVE LEVEL {EmergencyUpgradeLevel} INSTALLED")

    ResolveUpgradeBreak(Outcome:string):void=
        if (Phase <> terminal_game_phase.UpgradeBreak or UpgradeBreakResolved?):
            return
        set UpgradeBreakResolved = true
        CloseAllUpgradeInterfaces()
        ShowAll("{Outcome} | Next shift opening.", 5.0)
        set Shift += 1
        set CasesInShift = 0
        set ShiftElapsedSeconds = 0
        spawn{AdvanceQueueAndPrepare(CurrentCaseId, RunGeneration, QueueGeneration)}

    CloseUpgradeInterface(Player:player):void=
        if (Root := UpgradeRootUI[Player], PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Root)
        if (set UpgradeOpenShift[Player] = -1) {}

    CloseAllUpgradeInterfaces():void=
        for (Player : GetPlayspace().GetPlayers()):
            CloseUpgradeInterface(Player)

    BeginEmergency():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Enable()
        set Phase = terminal_game_phase.Emergency
        set CurrentDestination = terminal_case_destination.Response
        SetDecisionControlsAvailable(false)
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set PassengerAtIntake = false
        ActivePassengerDevice().Hide()
        set BagGeneration += 1
        HideAllBags()
        CustodyButton.Disable()
        SyncActiveCase()
        set EmergencyGeneration += 1
        CurrentEmergencyGeneration := EmergencyGeneration
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | RED ALERT")
        SetBoard(EmergencyBoard, "RED ALERT | {EmergencyLabel(Shift)}")
        NegativeAudio.Play()
        if (Shift = 5):
            set PowerOnline = false
            set PowerRepairStage = 0
            set PowerRepairCommitted = false
            set ScannerGeneration += 1
            ScanButton.Disable()
            BagButton.Disable()
            DocumentButton.Disable()
            ResponseButton.Disable()
            PowerButton.Enable()
            PowerBackupButton.Disable()
            PowerRestartButton.Disable()
            PowerButton.SetInteractionText(TerminalMessage("STEP 1 | RESET MAIN BREAKER"))
            ResponseAlarm.Enable()
            ResponseAlarm.Play()
            ResponseLightA.Enable()
            ResponseLightA.TurnOn()
            ResponseLightB.Enable()
            ResponseLightB.TurnOn()
            SetBoard(PowerBoard, "POWER OFFLINE | REPAIR 0/3 | RESET MAIN BREAKER")
            SetBoard(BagBoard, "X-RAY OFFLINE | NO CONVEYOR POWER")
            SetBoard(DocumentBoard, "DOCUMENT READER OFFLINE | BACKUP POWER ONLY")
            SetBoard(ResponseLoadoutBoard, "BACKUP LIGHTING ACTIVE\nPOWER ROOM REQUIRED\nREPAIR 0/3")
            ShowAll("POWER OUTAGE | Equipment stopped, backup alarm active. Follow STAFF / POWER and reset the main breaker.", 8.0)
        else:
            SetBoard(PowerBoard, "POWER ONLINE | SECURITY LOCKDOWN")
            ShowAll("LOCKDOWN | {EmergencyLabel(Shift)} | Use RESPOND / SECURE before the timer expires.", 8.0)
        TerminalLog(DebugEnabled, "[EMERGENCY] Started|Shift={Shift}|Generation={CurrentEmergencyGeneration}")
        spawn{EmergencyTimeout(CurrentEmergencyGeneration, EmergencyWaitSeconds())}

    EmergencyTimeout(ExpectedGeneration:int, WaitSeconds:float)<suspends>:void=
        Sleep(WaitSeconds)
        if (Phase = terminal_game_phase.Emergency and ExpectedGeneration = EmergencyGeneration):
            RaiseRisk(12)
            DamageIntegrity(10, "Emergency timeout")
            if (Phase = terminal_game_phase.Results):
                return
            RestoreNormalPower()
            SetBoard(EmergencyBoard, "EMERGENCY FAILED | CONTAINMENT FALLBACK")
            ShowAll("EMERGENCY TIMEOUT | Containment fallback restored operations | -10 integrity, +12 risk.", 7.0)
            BeginUpgradeBreak()

    OnPowerButton(Agent:agent):void=
        if (Phase = terminal_game_phase.BossJammer):
            if (not IsAgentNear(Agent, PowerButton.GetTransform().Translation, 750.0)?):
                ShowAgent(Agent, "JAMMER CONSOLE OUT OF RANGE | Enter the power room.", 5.0)
                return
            set Phase = terminal_game_phase.BossBreach
            PowerButton.Disable()
            PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
            ResponseButton.Enable()
            SetBoard(PowerBoard, "JAMMER OFFLINE | POWER ROUTING SECURED")
            SetBoard(EmergencyBoard, "FINAL THREAT | JAMMER OFFLINE | BREACH ACTIVE")
            ShowAll("JAMMER DISABLED | Move to the response station and interrupt the restricted-door breach.", 7.0)
            TerminalLog(DebugEnabled, "[BOSS] Jammer disabled|CaseId={CurrentCaseId}")
            return
        if (Phase <> terminal_game_phase.Emergency or Shift <> 5 or PowerOnline?):
            ShowAgent(Agent, "Power console is online. No repair is required.", 4.0)
            return
        if (not IsHumanAgent(Agent)?):
            return
        if (not IsAgentNear(Agent, PowerButton.GetTransform().Translation, 750.0)?):
            ShowAgent(Agent, "POWER CONSOLE OUT OF RANGE | Enter the utility room.", 5.0)
            return
        if (PowerRepairCommitted?):
            return
        if (PowerRepairStage = 0):
            set PowerRepairStage = 1
            PowerButton.Disable()
            PowerBackupButton.Enable()
            SetBoard(PowerBoard, "POWER OFFLINE | REPAIR 1/3 | BREAKER RESET")
            SetBoard(ResponseLoadoutBoard, "BACKUP LIGHTING ACTIVE\nBREAKER RESET\nMOVE TO EAST CABINET | REPAIR 1/3")
            ShowAll("POWER REPAIR 1/3 | Main breaker reset. Move to the east cabinet and reroute the backup bus.", 6.0)
            BagScanAudio.Play()
            TerminalLog(DebugEnabled, "[EMERGENCY] Power repair stage 1|Shift={Shift}")
            return
        ShowAgent(Agent, "MAIN BREAKER already reset. Use the independently mounted BACKUP BUS cabinet.", 4.0)

    OnPowerBackupButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.Emergency or Shift <> 5 or PowerOnline? or PowerRepairStage <> 1):
            ShowAgent(Agent, "BACKUP BUS LOCKED | Reset the main breaker first.", 4.0)
            return
        if (not IsAgentNear(Agent, PowerBackupButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE BACKUP BUS CABINET.", 4.0)
            return
        set PowerRepairStage = 2
        PowerBackupButton.Disable()
        PowerRestartButton.Enable()
        SetBoard(PowerBoard, "POWER OFFLINE | REPAIR 2/3 | BACKUP BUS ROUTED")
        SetBoard(ResponseLoadoutBoard, "BACKUP LIGHTING ACTIVE\nBUS REROUTED\nMOVE TO CHECKPOINT RESTART | REPAIR 2/3")
        ShowAll("POWER REPAIR 2/3 | Backup bus routed. Use the third physical cabinet to restart checkpoint systems.", 6.0)
        ScannerStartAudio.Play()
        TerminalLog(DebugEnabled, "[EMERGENCY] Power repair stage 2|Shift={Shift}")

    OnPowerRestartButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.Emergency or Shift <> 5 or PowerOnline? or PowerRepairStage <> 2 or PowerRepairCommitted?):
            ShowAgent(Agent, "CHECKPOINT RESTART LOCKED | Complete the first two breakers in order.", 4.0)
            return
        if (not IsAgentNear(Agent, PowerRestartButton.GetTransform().Translation, 650.0)?):
            ShowAgent(Agent, "MOVE TO THE CHECKPOINT RESTART CABINET.", 4.0)
            return
        set PowerRepairCommitted = true
        set PowerRepairStage = 3
        set EmergencyGeneration += 1
        set TeamCash += 200
        LowerRisk(8)
        RestoreNormalPower()
        SetBoard(EmergencyBoard, "POWER RESTORED | TERMINAL NORMAL")
        ShowAll("POWER REPAIR 3/3 | Scanner, baggage, displays, and checkpoint systems online | +200 cash.", 7.0)
        PositiveAudio.Play()
        TerminalLog(DebugEnabled, "[EMERGENCY] Power restored after three independent breakers|Shift={Shift}")
        BeginUpgradeBreak()

    RestoreNormalPower():void=
        set PowerOnline = true
        ScanButton.Enable()
        BagButton.Enable()
        DocumentButton.Enable()
        PowerButton.Disable()
        PowerBackupButton.Disable()
        PowerRestartButton.Disable()
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
        ResponseAlarm.Stop()
        ResponseLightA.TurnOff()
        ResponseLightB.TurnOff()
        SetBoard(PowerBoard, "POWER ONLINE")

    StartResponseEvent():void=
        set Phase = terminal_game_phase.HostileResponse
        set CurrentDestination = terminal_case_destination.Response
        set ResponseGeneration += 1
        CurrentResponseGeneration := ResponseGeneration
        ResponseButton.Enable()
        ResponseGranter.Enable()
        ResponseRemote.Enable()
        ResponseAlarm.Enable()
        ResponseAlarm.Play()
        ResponseLightA.Enable()
        ResponseLightA.TurnOn()
        ResponseLightB.Enable()
        ResponseLightB.TurnOn()
        SyncActiveCase()
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | RESPONSE ALERT")
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | RESISTANT SUSPECT | CONTAINED")
        SetBoard(EmergencyBoard, "RED ALERT | RESPONSE KIT AUTHORIZED")
        SetBoard(ResponseLoadoutBoard, "SECURITY RESPONSE KIT\nSIGNAL REMOTE A\nPRIMARY FIRE TO INCAPACITATE")
        for (Player : GetPlayspace().GetPlayers()):
            ResponseGranter.GrantItem(Player)
        ShowAll("RESPONSE ALERT | Take Signal Remote A at the secured station. Enter the contained response room and use PRIMARY FIRE.", 10.0)
        TerminalLog(DebugEnabled, "[RESPONSE] Started|CaseId={CurrentCaseId}|Generation={CurrentResponseGeneration}")
        spawn{ThreatPatrolLoop(CurrentCaseId, RunGeneration, CurrentResponseGeneration)}
        spawn{ResponseTimeout(CurrentCaseId, RunGeneration, CurrentResponseGeneration, ResponseTimeoutSeconds)}

    ThreatPatrolLoop(ExpectedCaseId:int, ExpectedRun:int, ExpectedResponseGeneration:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Response
        SyncActiveCase()
        Arrival := MoveActivePassengerChecked(
            ResponsePassengerPosition(),
            ResponsePassengerRetryPosition(),
            3.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Response,
            "response-arrival"
        )
        if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
            return
        if (not Arrival?):
            SetBoard(EmergencyBoard, "THREAT ROUTE FALLBACK | CONTAINMENT TIMER ACTIVE")
            return
        SetBoard(EmergencyBoard, "ACTIVE THREAT | CONTAINED IN RESPONSE ROOM")
        loop:
            PatrolA := MoveActivePassengerChecked(
                ResponsePatrolAPosition(),
                ResponsePassengerPosition(),
                2.2,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Response,
                "response-patrol-a"
            )
            if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
                return
            if (not PatrolA?):
                return
            PatrolB := MoveActivePassengerChecked(
                ResponsePatrolBPosition(),
                ResponsePatrolAPosition(),
                2.2,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Response,
                "response-patrol-b"
            )
            if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
                return
            if (not PatrolB?):
                return
            PatrolC := MoveActivePassengerChecked(
                ResponsePatrolCPosition(),
                ResponsePatrolBPosition(),
                2.2,
                ExpectedCaseId,
                ExpectedRun,
                terminal_passenger_location.Response,
                "response-patrol-c"
            )
            if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
                return
            if (not PatrolC?):
                return

    ResponseTimeout(ExpectedCaseId:int, ExpectedRun:int, ExpectedResponseGeneration:int, WaitSeconds:float)<suspends>:void=
        Sleep(WaitSeconds)
        if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
            return
        set Phase = terminal_game_phase.Resolving
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Disable()
        ActivePassengerDevice().Hide()
        set CurrentCustodyMode = 0
        RaiseRisk(10)
        DamageIntegrity(8, "Response event timeout")
        if (Phase = terminal_game_phase.Results):
            return
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | CONTAINMENT FALLBACK")
        SetBoard(CellBoard, "DETENTION CELL | VACANT | TRANSFERRED")
        ShowAll("RESPONSE TIMEOUT | Automated containment transferred the suspect | -8 integrity, +10 risk.", 8.0)
        NegativeAudio.Play()
        TerminalLog(DebugEnabled, "[RESPONSE] Timeout|CaseId={CurrentCaseId}")
        FinishCase()

    OnResponseRemote(Agent:agent):void=
        if (Phase = terminal_game_phase.Runner):
            CaptureRunner(Agent)
            return
        if (Phase = terminal_game_phase.BossVulnerable):
            if (not IsAgentNearActivePassenger(Agent, ResponseProximityRadius)?):
                ShowAgent(Agent, "FINAL THREAT OUT OF RANGE | Enter the response room before firing.", 5.0)
                return
            set Phase = terminal_game_phase.BossSecure
            CleanupResponseEquipment()
            ResponseButton.Disable()
            set CurrentCustodyMode = 6
            CustodyButton.Disable()
            SetBoard(EmergencyBoard, "FINAL THREAT | INCAPACITATED | MOVE TO CUSTODY")
            SetBoard(ResponseLoadoutBoard, "FINAL RESPONSE\nTHREAT INCAPACITATED\nEQUIPMENT RECALLED")
            ShowAll("THE BREACHER INCAPACITATED | Follow the suspect to detention intake and complete final custody.", 8.0)
            TerminalLog(DebugEnabled, "[BOSS] Threat incapacitated|CaseId={CurrentCaseId}")
            spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}
            return
        if (Phase <> terminal_game_phase.HostileResponse):
            return
        if (PassengerLocation <> terminal_passenger_location.Response or not IsAgentNearActivePassenger(Agent, ResponseProximityRadius)?):
            ShowAgent(Agent, "REMOTE OUT OF RANGE | Aim and fire near the visible moving suspect.", 5.0)
            TerminalLog(DebugEnabled, "[RESPONSE] Target-specific remote signal rejected for CaseId={CurrentCaseId}")
            return
        SecureResponseThreat(Agent)

    SecureResponseThreat(Agent:agent):void=
        if (Phase <> terminal_game_phase.HostileResponse):
            return
        Claimed := TryClaim(Agent, terminal_claim_stage.Response)
        if (not Claimed?):
            return
        set Phase = terminal_game_phase.Custody
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Disable()
        set CurrentCustodyMode = 5
        CustodyButton.Disable()
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | RESPONSE SECURED")
        SetBoard(EmergencyBoard, "SUSPECT INCAPACITATED | ALL CLEAR")
        SetBoard(CustodyBoard, "SUSPECT SECURED | COMPLETE JAIL INTAKE")
        SetBoard(ResponseLoadoutBoard, "SECURITY RESPONSE KIT\nEVENT COMPLETE\nEQUIPMENT RECALLED")
        ShowAll("SUSPECT INCAPACITATED | Signal remote recalled. Complete JAIL INTAKE / SECURE IN CELL.", 7.0)
        PositiveAudio.Play()
        TerminalLog(DebugEnabled, "[RESPONSE] Success|CaseId={CurrentCaseId}")
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    CleanupResponseEquipment():void=
        for (Player : GetPlayspace().GetPlayers()):
            ResponseRemover.Remove(Player)
        ResponseGranter.Disable()
        ResponseRemote.Disable()
        ResponseAlarm.Stop()
        ResponseLightA.TurnOff()
        ResponseLightB.TurnOff()
        SetBoard(ResponseLoadoutBoard, "SECURITY RESPONSE KIT\nSIGNAL REMOTE A\nSTANDBY")

    IsResponseEventCurrent(ExpectedCaseId:int, ExpectedRun:int, ExpectedResponseGeneration:int)<transacts>:logic=
        if (Phase = terminal_game_phase.HostileResponse and ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and ExpectedResponseGeneration = ResponseGeneration):
            return true
        false

    OnResponseButton(Agent:agent):void=
        if (Phase = terminal_game_phase.BossJammer):
            ShowAgent(Agent, "FINAL THREAT | Disable the jammer at the power-room console first.", 5.0)
            return
        if (Phase = terminal_game_phase.BossBreach):
            if (not IsAgentNear(Agent, ResponseButton.GetTransform().Translation, ResponseProximityRadius)?):
                ShowAgent(Agent, "BREACH CONTROL OUT OF RANGE | Reach the secured response station.", 5.0)
                return
            set Phase = terminal_game_phase.BossVulnerable
            ResponseGranter.Enable()
            ResponseRemote.Enable()
            ResponseGranter.GrantItem(Agent)
            SetBoard(EmergencyBoard, "FINAL THREAT | BREACH INTERRUPTED | TARGET VULNERABLE")
            SetBoard(ResponseLoadoutBoard, "FINAL RESPONSE\nSIGNAL REMOTE A ISSUED\nENGAGE INSIDE RESPONSE ROOM")
            ShowAll("BREACH INTERRUPTED | Signal Remote A issued. Enter the response room and use PRIMARY FIRE at close range.", 8.0)
            TerminalLog(DebugEnabled, "[BOSS] Breach interrupted|CaseId={CurrentCaseId}")
            return
        if (Phase = terminal_game_phase.BossVulnerable):
            ResponseGranter.GrantItem(Agent)
            ShowAgent(Agent, "SIGNAL REMOTE A REISSUED | Engage the threat inside the response room.", 5.0)
            return
        if (Phase = terminal_game_phase.BossSecure):
            ShowAgent(Agent, "FINAL THREAT SECURED | Complete custody at detention intake.", 5.0)
            return
        if (Phase = terminal_game_phase.HostileResponse):
            if (not IsAgentNear(Agent, ResponseButton.GetTransform().Translation, ResponseProximityRadius)?):
                ShowAgent(Agent, "TOO FAR FROM RESPONSE ZONE | Reach the secured supply station.", 5.0)
                TerminalLog(DebugEnabled, "[RESPONSE] Remote resistant response rejected for CaseId={CurrentCaseId}")
                return
            ResponseGranter.GrantItem(Agent)
            ShowAgent(Agent, "SIGNAL REMOTE A ISSUED | Enter the contained room and use PRIMARY FIRE.", 6.0)
            TerminalLog(DebugEnabled, "[RESPONSE] Loadout issued|CaseId={CurrentCaseId}")
            return
        if (Phase = terminal_game_phase.Emergency):
            if (Shift = 5 and not PowerOnline?):
                ShowAgent(Agent, "This alarm requires the POWER console in the utility room.", 5.0)
                return
            set EmergencyGeneration += 1
            set TeamCash += 200
            LowerRisk(8)
            RestoreNormalPower()
            SetBoard(EmergencyBoard, "EMERGENCY SECURED | TERMINAL NORMAL")
            ShowAll("EMERGENCY SECURED | Systems restored | +200 cash, Risk reduced.", 6.0)
            PositiveAudio.Play()
            TerminalLog(DebugEnabled, "[EMERGENCY] Success|Shift={Shift}")
            BeginUpgradeBreak()
            return
        if (Phase = terminal_game_phase.Results):
            ResetToWaiting()
            return
        ShowAgent(Agent, "No emergency response is active.", 4.0)

    BeginBoss(Detected:logic):void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        CurrentBossGeneration := ResponseGeneration
        ResponseButton.Disable()
        MovePowerControl(PowerStage1Position(), "boss-jammer")
        PowerButton.SetInteractionText(TerminalMessage("DISABLE BREACH JAMMER"))
        PowerButton.Enable()
        CustodyButton.Disable()
        set CustodyCommitted = false
        set PassengerAtIntake = false
        set CurrentCustodyMode = 6
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set CurrentDestination = terminal_case_destination.Response
        ResponseAlarm.Enable()
        ResponseAlarm.Play()
        ResponseLightA.Enable()
        ResponseLightA.TurnOn()
        ResponseLightB.Enable()
        ResponseLightB.TurnOn()
        SyncActiveCase()
        if (Detected?):
            set BossBranch = terminal_boss_branch.Detected
            set TeamCash += 300
            set Phase = terminal_game_phase.BossJammer
            SetBoard(CaseBoard, "FINAL CASE | BREACHER DETECTED")
            SetBoard(EmergencyBoard, "FINAL THREAT | DISABLE JAMMER")
            ShowAll("EARLY INTERCEPTION | Enter the power room and disable the breach jammer at its console.", 8.0)
            spawn{BossTimeout(CurrentBossGeneration, 75.0)}
        else:
            set BossBranch = terminal_boss_branch.Missed
            RaiseRisk(15)
            DamageIntegrity(10, "Boss cleared at checkpoint")
            if (Phase = terminal_game_phase.Results):
                return
            set Phase = terminal_game_phase.BossJammer
            SetBoard(CaseBoard, "FINAL CASE | BREACHER MISSED")
            SetBoard(EmergencyBoard, "FINAL THREAT | EXTRA ROUTES OPEN")
            ShowAll("BREACHER MISSED | Extra routes opened. Reach the power room and disable the jammer now.", 8.0)
            spawn{BossTimeout(CurrentBossGeneration, 55.0)}
        SyncActiveCase()
        spawn{MovePassengerToResponse(CurrentCaseId, RunGeneration)}
        TerminalLog(DebugEnabled, "[BOSS] Branch={BossBranchLabel()}|Integrity={TeamIntegrity}|Risk={TeamRisk}")

    BossTimeout(ExpectedResponseGeneration:int, WaitSeconds:float)<suspends>:void=
        Sleep(WaitSeconds)
        if (ExpectedResponseGeneration <> ResponseGeneration):
            return
        if (Phase = terminal_game_phase.BossJammer or Phase = terminal_game_phase.BossBreach or Phase = terminal_game_phase.BossVulnerable or Phase = terminal_game_phase.BossSecure):
            FinishDefeat("Final threat breached the terminal")

    CompleteBossCustody(Agent:agent):void=
        if (Phase <> terminal_game_phase.BossSecure or CurrentCustodyMode <> 6):
            return
        if (not PassengerAtIntake?):
            ShowAgent(Agent, "FINAL THREAT IN TRANSIT | Intake remains locked until suspect arrival is verified.", 5.0)
            return
        if (not IsAgentNear(Agent, CustodyButton.GetTransform().Translation, CustodyProximityRadius)?):
            ShowAgent(Agent, "FINAL CUSTODY OUT OF RANGE | Meet the suspect at detention intake.", 5.0)
            return
        if (CustodyCommitted?):
            TerminalLog(DebugEnabled, "[BOSS] Duplicate final custody rejected")
            return
        set CustodyCommitted = true
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        SetBoard(CustodyBoard, "FINAL CUSTODY ACCEPTED | CELL GATE CLOSING")
        spawn{MoveBossIntoCell(CurrentCaseId, RunGeneration)}

    MoveBossIntoCell(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Cell
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            CellPosition(),
            IntakePosition(),
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            terminal_passenger_location.Cell,
            "boss-cell"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.BossSecure):
            ActivePassengerDevice().Hide()
            JailOccupant.Show()
            if (MoveResult?):
                SetBoard(CellBoard, "CELL SECURED | FINAL THREAT IN CUSTODY")
            else:
                SetBoard(CellBoard, "FINAL THREAT SECURED BY SAFE TRANSFER")
            FinishVictory()

    FinishVictory():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Enable()
        PowerButton.Disable()
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        set Phase = terminal_game_phase.Results
        set CurrentDestination = terminal_case_destination.None
        set TeamCash += 500
        ActivePassengerDevice().Hide()
        set BagGeneration += 1
        HideAllBags()
        JailOccupant.Hide()
        SyncActiveCase()
        SetBoard(CheckpointBoard, "TERMINAL SECURED | RESULTS")
        SetBoard(EmergencyBoard, "ALL CLEAR | RESPOND TO REPLAY")
        Grade := ResultGrade()
        ShowAll("TERMINAL SECURED | Grade {Grade} | Accuracy {CorrectDecisions}/{TotalCasesResolved} | Integrity {TeamIntegrity} | Branch {BossBranchLabel()} | RESPOND to replay.", 0.0)
        PositiveAudio.Play()
        TerminalLog(DebugEnabled, "[RESULTS] Victory|Grade={Grade}|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}|Boss={BossBranchLabel()}")

    FinishDefeat(Reason:string):void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Enable()
        PowerButton.Disable()
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        set Phase = terminal_game_phase.Results
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set CurrentDestination = terminal_case_destination.None
        set EmergencyGeneration += 1
        ActivePassengerDevice().Hide()
        set BagGeneration += 1
        HideAllBags()
        JailOccupant.Hide()
        RestoreNormalPower()
        SyncActiveCase()
        SetBoard(CheckpointBoard, "TERMINAL OVERRUN | RESULTS")
        SetBoard(EmergencyBoard, "RUN ENDED | RESPOND TO RETRY")
        ShowAll("TERMINAL OVERRUN | {Reason} | Correct {CorrectDecisions}/{TotalCasesResolved} | RESPOND to retry.", 0.0)
        NegativeAudio.Play()
        TerminalLog(DebugEnabled, "[RESULTS] Defeat|Reason={Reason}|Shift={Shift}|CaseId={CurrentCaseId}")

    ResetToWaiting():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        CloseAllUpgradeInterfaces()
        ResponseButton.Disable()
        CloseAllBodyScanInterfaces()
        CloseAllXRayInterfaces()
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set RunGeneration += 1
        set EmergencyGeneration += 1
        set Phase = terminal_game_phase.Waiting
        SetDecisionControlsAvailable(false)
        set BossBranch = terminal_boss_branch.None
        set Shift = 0
        set CasesInShift = 0
        set ShiftElapsedSeconds = 0
        set ClaimOwner = false
        set ClaimStage = terminal_claim_stage.None
        set ClaimGeneration += 1
        set ResolutionCommitted = false
        set CaseCompletionCommitted = false
        set CustodyCommitted = false
        set FinalCaseAccountingCommitted = false
        set ScannerUpgradeLevel = 0
        set PayoutUpgradeLevel = 0
        set EmergencyUpgradeLevel = 0
        set UpgradeBreakResolved = false
        set PowerRepairStage = 0
        set PowerRepairCommitted = false
        set RunUpgradePurchased = false
        set CurrentCustodyMode = 0
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set SecondaryBagReady = false
        set SecondaryCostPaid = false
        set SecondaryActionStage = 0
        set PassengerAtIntake = false
        set QueueFrontIndex = 0
        set QueueGeneration += 1
        set ScannerGeneration += 1
        set BagGeneration += 1
        set CurrentDestination = terminal_case_destination.Queue
        SyncActiveCase()
        ActivePassengerDevice().Hide()
        HideAllBags()
        JailOccupant.Hide()
        spawn{ResetPassengerQueue(RunGeneration)}
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("JAIL INTAKE | SECURE IN CELL"))
        DetainButton.SetInteractionText(TerminalMessage("JAIL | DETAIN PASSENGER"))
        RestoreNormalPower()
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | OPEN")
        SetBoard(CaseBoard, "CURRENT PASSENGER | WAITING FOR SHIFT")
        SetBoard(BagBoard, "BAG INSPECTION | NO ACTIVE BAG")
        SetBoard(DocumentBoard, "TRAVEL DOCUMENTS | NO ACTIVE CASE")
        SetBoard(CustodyBoard, "DETENTION INTAKE | READY")
        SetBoard(CellBoard, "DETENTION CELL | VACANT")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        ShowAll("TERMINAL LOCKDOWN | Run reset cleanly. Press START SHIFT.", 8.0)
        TerminalLog(DebugEnabled, "[RECOVERY] Reset complete|Generation={RunGeneration}")

    RequiredEvidenceMask()<transacts>:int=
        if (Shift >= 3):
            return 7
        if (Shift >= 2):
            return 3
        1

    CompletedEvidenceMask()<transacts>:int=
        var Completed:int = 0
        if (BodyChecked?):
            set Completed += 1
        if (BagChecked?):
            set Completed += 2
        if (DocumentsChecked?):
            set Completed += 4
        Completed

    SyncActiveCase():void=
        set ActiveCase = terminal_active_case:
            CaseId := CurrentCaseId
            RunGeneration := RunGeneration
            Shift := Shift
            Template := CurrentTemplate
            ClaimOwner := ClaimOwner
            PassengerSlot := ActivePassengerSlot
            BagSlot := ActiveBagIndex
            PassengerGeneration := PassengerGeneration
            MovementGeneration := ActivePassengerMoveGeneration
            RequiredEvidence := RequiredEvidenceMask()
            CompletedEvidence := CompletedEvidenceMask()
            Destination := CurrentDestination
            PassengerLocation := PassengerLocation
            PassengerTarget := PassengerTarget
            BagLocation := BagLocation
            ClaimStage := ClaimStage
            BodyObservation := BodyObservation
            BagObservation := BagObservation
            DocumentObservation := DocumentObservation
            ManualSearchRequested := ManualSearchRequested
            Phase := Phase
            PassengerAtIntake := PassengerAtIntake
            ResolutionCommitted := ResolutionCommitted
            CustodyCommitted := CustodyCommitted
            FinalCaseAccountingCommitted := FinalCaseAccountingCommitted

    CaseIdentityMatches(ExpectedCaseId:int, ExpectedRun:int)<transacts>:logic=
        if (ExpectedCaseId = ActiveCase.CaseId and ExpectedRun = ActiveCase.RunGeneration):
            return true
        false

    # Route positions are derived from already-wired, transform-bearing world
    # devices instead of embedding absolute map coordinates in production
    # movement. Queue markers are captured before any Character device moves;
    # the remaining stations follow their physical control or status device.
    CaptureRouteMarkers():void=
        set QueueFrontMarker = PassengerQueue1.GetTransform().Translation
        set QueueMiddleMarker = PassengerQueue2.GetTransform().Translation
        set QueueRearMarker = PassengerQueue3.GetTransform().Translation
        PowerTransform := PowerButton.GetTransform()
        set PowerHomePosition = PowerTransform.Translation
        set PowerHomeRotation = PowerTransform.Rotation

    OffsetPosition(Base:vector3, XOffset:float, YOffset:float, ZOffset:float)<computes>:vector3=
        vector3{X := Base.X + XOffset, Y := Base.Y + YOffset, Z := Base.Z + ZOffset}

    QueueAdvancePosition()<transacts>:vector3=
        OffsetPosition(QueueFrontMarker, 400.0, 0.0, 0.0)

    QueueRecyclePosition()<transacts>:vector3=
        OffsetPosition(QueueRearMarker, 0.0, -1200.0, 0.0)

    QueuePassengerStagePosition()<transacts>:vector3=
        QueueRecyclePosition()

    QueueSwitchbackEastSouthPosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 2150.0, 0.0, 0.0)

    QueueSwitchbackEastMiddlePosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 2150.0, 600.0, 0.0)

    QueueSwitchbackWestMiddlePosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 0.0, 600.0, 0.0)

    QueueSwitchbackWestNorthPosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 0.0, 1200.0, 0.0)

    QueueSwitchbackEastNorthPosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 2150.0, 1200.0, 0.0)

    QueueSwitchbackExitPosition()<transacts>:vector3=
        OffsetPosition(QueuePassengerStagePosition(), 2150.0, 1800.0, 0.0)

    QueueScannerLeadInPosition()<transacts>:vector3=
        OffsetPosition(ScannerEntryPosition(), -250.0, -300.0, 0.0)

    ScannerEntryPosition()<transacts>:vector3=
        OffsetPosition(CheckpointBoard.GetTransform().Translation, -300.0, 0.0, -1050.0)

    ScannerCenterPosition()<transacts>:vector3=
        OffsetPosition(CheckpointBoard.GetTransform().Translation, 120.0, 0.0, -1050.0)

    ScannerExitPosition()<transacts>:vector3=
        OffsetPosition(CheckpointBoard.GetTransform().Translation, 500.0, 0.0, -1050.0)

    BagStagePosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, -700.0, -25.0, -165.0)

    BagStageRetryPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, -700.0, -300.0, -165.0)

    BagEntryPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, -150.0, -25.0, -165.0)

    BagXRayPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, 325.0, -25.0, -165.0)

    BagExitPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, 850.0, -25.0, -165.0)

    BaggagePassengerPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, 500.0, 650.0, -270.0)

    BaggagePassengerRetryPosition()<transacts>:vector3=
        OffsetPosition(BagButton.GetTransform().Translation, -150.0, 200.0, -270.0)

    DocumentPassengerPosition()<transacts>:vector3=
        OffsetPosition(DocumentButton.GetTransform().Translation, 0.0, -650.0, -310.0)

    DecisionPassengerPosition()<transacts>:vector3=
        # Keep the decision passenger immediately beyond the detector instead
        # of coupling movement to the old remote decision desk. The player can
        # inspect the passenger and both physical choices from one position.
        OffsetPosition(CheckpointBoard.GetTransform().Translation, 700.0, 0.0, -1050.0)

    SecurePadPosition()<transacts>:vector3=
        # The wired JAIL button is mounted below the detector console cap. Keep
        # the close-range secure position on the separate red floor pad beside
        # the console instead of underneath its blocking cabinet.
        OffsetPosition(DetainButton.GetTransform().Translation, 305.0, 300.0, -185.0)

    DeparturePosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), 2000.0, -350.0, -110.0)

    DepartureRetryPosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), 200.0, -550.0, -110.0)

    LegacyCustodyOrigin()<transacts>:vector3=
        # All pre-existing detention, secondary, cell, and departure route
        # anchors remain based on the original custody pedestal position.
        OffsetPosition(CustodyButton.GetTransform().Translation, 150.0, 200.0, -450.0)

    IntakePosition()<transacts>:vector3=
        OffsetPosition(CustodyButton.GetTransform().Translation, -180.0, 0.0, 0.0)

    CellPosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), 550.0, 0.0, -110.0)

    SecondaryPassengerPosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), 400.0, 650.0, -110.0)

    SecondaryBagPosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), -280.0, 330.0, -5.0)

    ResponsePassengerPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, -450.0, 1100.0, -350.0)

    ResponsePassengerRetryPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, -650.0, 1800.0, -350.0)

    ResponseCenterPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, -125.0, 800.0, -350.0)

    ResponsePatrolAPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, 100.0, 1100.0, -350.0)

    ResponsePatrolBPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, 100.0, 450.0, -350.0)

    ResponsePatrolCPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, -450.0, 550.0, -350.0)

    RunnerRouteAPosition()<transacts>:vector3=
        DepartureRetryPosition()

    RunnerExitAPosition()<transacts>:vector3=
        OffsetPosition(LegacyCustodyOrigin(), 2000.0, 150.0, -110.0)

    RunnerRouteBPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, -500.0, 2150.0, -350.0)

    RunnerExitBPosition()<transacts>:vector3=
        OffsetPosition(ResponseButton.GetTransform().Translation, 1350.0, 1200.0, -350.0)

    PowerStage1Position()<transacts>:vector3=
        PowerHomePosition

    PowerStage2Position()<transacts>:vector3=
        OffsetPosition(PowerHomePosition, 430.0, -270.0, 0.0)

    PowerStage3Position()<transacts>:vector3=
        OffsetPosition(PowerHomePosition, -430.0, -270.0, 0.0)

    MovePowerControl(Target:vector3, Label:string):void=
        if (PowerButton.TeleportTo[Target, PowerHomeRotation]):
            TerminalLog(DebugEnabled, "[POWER] Control moved|Stage={Label}")
        else:
            TerminalLog(DebugEnabled, "[POWER] Control move failed|Stage={Label}")

    MoveActivePassengerChecked(
        Target:vector3,
        RetryWaypoint:vector3,
        OverTime:float,
        ExpectedCaseId:int,
        ExpectedRun:int,
        ArrivalLocation:terminal_passenger_location,
        Label:string
    )<suspends>:logic=
        set ActivePassengerMoveGeneration += 1
        ExpectedMoveGeneration := ActivePassengerMoveGeneration
        ExpectedPassengerGeneration := PassengerGeneration
        set PassengerTarget = ArrivalLocation
        set PassengerLocation = terminal_passenger_location.Transit
        SyncActiveCase()
        ActivePassenger := ActivePassengerDevice()
        TerminalLog(DebugEnabled, "[MOVE] Start|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|PassengerGeneration={ExpectedPassengerGeneration}|MoveGeneration={ExpectedMoveGeneration}")
        PrimaryResult := ActivePassenger.MoveTo(Target, IdentityRotation(), OverTime)
        if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration or ExpectedPassengerGeneration <> PassengerGeneration or PassengerTarget <> ArrivalLocation):
            TerminalLog(DebugEnabled, "[MOVE] Superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
            return false
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (PrimaryResult = move_to_result.DestinationReached and IsCharacterNear(ActivePassenger, Target, 180.0)?):
            CommitPassengerArrival(ArrivalLocation, ExpectedCaseId, ExpectedRun, ExpectedPassengerGeneration, ExpectedMoveGeneration)
            TerminalLog(DebugEnabled, "[MOVE] Arrival committed|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true

        set PassengerRouteRetries += 1
        TerminalLog(DebugEnabled, "[MOVE] Primary blocked|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        RetryClear := ActivePassenger.MoveTo(RetryWaypoint, IdentityRotation(), 0.75)
        if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration or ExpectedPassengerGeneration <> PassengerGeneration or PassengerTarget <> ArrivalLocation):
            TerminalLog(DebugEnabled, "[MOVE] Retry superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
            return false
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Retry stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (RetryClear = move_to_result.DestinationReached):
            RetryTarget := ActivePassenger.MoveTo(Target, IdentityRotation(), 1.0)
            if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration or ExpectedPassengerGeneration <> PassengerGeneration or PassengerTarget <> ArrivalLocation):
                TerminalLog(DebugEnabled, "[MOVE] Retry target superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
                return false
            if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
                TerminalLog(DebugEnabled, "[MOVE] Retry target stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return false
            if (RetryTarget = move_to_result.DestinationReached and IsCharacterNear(ActivePassenger, Target, 180.0)?):
                CommitPassengerArrival(ArrivalLocation, ExpectedCaseId, ExpectedRun, ExpectedPassengerGeneration, ExpectedMoveGeneration)
                TerminalLog(DebugEnabled, "[MOVE] Retry reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return true

        if (ActivePassenger.TeleportTo[Target, IdentityRotation()]):
            if (IsCharacterNear(ActivePassenger, Target, 180.0)?):
                set PassengerTeleportRecoveries += 1
                CommitPassengerArrival(ArrivalLocation, ExpectedCaseId, ExpectedRun, ExpectedPassengerGeneration, ExpectedMoveGeneration)
                ShowAll("VISIBLE ROUTE RECOVERY | {Label} | Passenger placed at the guarded destination.", 5.0)
                TerminalLog(true, "[MOVE RECOVERY] Teleport|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|Count={PassengerTeleportRecoveries}")
                return true
        set PassengerHideRecoveries += 1
        ActivePassenger.Hide()
        TerminalLog(DebugEnabled, "[MOVE] Final fallback failed; actor hidden|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        false

    CommitPassengerArrival(
        ArrivalLocation:terminal_passenger_location,
        ExpectedCaseId:int,
        ExpectedRun:int,
        ExpectedPassengerGeneration:int,
        ExpectedMoveGeneration:int
    ):void=
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? or ExpectedPassengerGeneration <> PassengerGeneration or ExpectedMoveGeneration <> ActivePassengerMoveGeneration or PassengerTarget <> ArrivalLocation):
            return
        set PassengerLocation = ArrivalLocation
        SyncActiveCase()

    IsCharacterNear(Character:character_device, Target:vector3, Radius:float)<transacts>:logic=
        CharacterLocation := Character.GetTransform().Translation
        DeltaX := CharacterLocation.X - Target.X
        DeltaY := CharacterLocation.Y - Target.Y
        DeltaZ := CharacterLocation.Z - Target.Z
        MeasuredDistanceSquared := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ
        if (MeasuredDistanceSquared <= Radius * Radius):
            return true
        false

    MoveCharacterChecked(
        Character:character_device,
        Target:vector3,
        RetryWaypoint:vector3,
        OverTime:float,
        ExpectedCaseId:int,
        ExpectedRun:int,
        Label:string
    )<suspends>:logic=
        TerminalLog(DebugEnabled, "[MOVE] Start|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        PrimaryResult := Character.MoveTo(Target, IdentityRotation(), OverTime)
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (PrimaryResult = move_to_result.DestinationReached):
            TerminalLog(DebugEnabled, "[MOVE] Reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true

        TerminalLog(DebugEnabled, "[MOVE] Primary blocked|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        RetryClear := Character.MoveTo(RetryWaypoint, IdentityRotation(), 0.75)
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Retry stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (RetryClear = move_to_result.DestinationReached):
            RetryTarget := Character.MoveTo(Target, IdentityRotation(), 1.0)
            if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
                TerminalLog(DebugEnabled, "[MOVE] Retry target stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return false
            if (RetryTarget = move_to_result.DestinationReached):
                TerminalLog(DebugEnabled, "[MOVE] Retry reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return true

        if (Character.TeleportTo[Target, IdentityRotation()]):
            TerminalLog(DebugEnabled, "[MOVE] Teleport fallback|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true
        Character.Hide()
        TerminalLog(DebugEnabled, "[MOVE] Final fallback failed; actor hidden|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        false

    MovePropChecked(
        Prop:creative_prop,
        Target:vector3,
        RetryWaypoint:vector3,
        OverTime:float,
        ExpectedCaseId:int,
        ExpectedRun:int,
        ExpectedBagGeneration:int,
        Label:string
    )<suspends>:logic=
        TerminalLog(DebugEnabled, "[BAG MOVE] Start|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|Generation={ExpectedBagGeneration}")
        PrimaryResult := Prop.MoveTo(Target, IdentityRotation(), OverTime)
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? or ExpectedBagGeneration <> BagGeneration):
            TerminalLog(DebugEnabled, "[BAG MOVE] Stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (PrimaryResult = move_to_result.DestinationReached):
            TerminalLog(DebugEnabled, "[BAG MOVE] Reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true

        set BagRouteRetries += 1
        RetryClear := Prop.MoveTo(RetryWaypoint, IdentityRotation(), 0.5)
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? or ExpectedBagGeneration <> BagGeneration):
            return false
        if (RetryClear = move_to_result.DestinationReached):
            RetryTarget := Prop.MoveTo(Target, IdentityRotation(), 0.75)
            if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)? or ExpectedBagGeneration <> BagGeneration):
                return false
            if (RetryTarget = move_to_result.DestinationReached):
                TerminalLog(DebugEnabled, "[BAG MOVE] Retry reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return true

        if (Prop.TeleportTo[Target, IdentityRotation()]):
            set BagTeleportRecoveries += 1
            ShowAll("VISIBLE BAG ROUTE RECOVERY | {Label} | Linked bag placed at the guarded destination.", 5.0)
            TerminalLog(true, "[BAG MOVE RECOVERY] Teleport|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|Count={BagTeleportRecoveries}")
            return true
        set BagHideRecoveries += 1
        Prop.Hide()
        TerminalLog(DebugEnabled, "[BAG MOVE] Final fallback failed; prop hidden|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        false

    CommitFinalCaseAccounting(Submitted:terminal_decision, Expected:terminal_decision):void=
        if (FinalCaseAccountingCommitted? or CaseCompletionCommitted?):
            TerminalLog(DebugEnabled, "[BOSS] Duplicate final-case accounting rejected|CaseId={CurrentCaseId}")
            return
        set FinalCaseAccountingCommitted = true
        set CaseCompletionCommitted = true
        set TotalCasesResolved += 1
        set CasesInShift += 1
        if (Submitted = Expected):
            set CorrectDecisions += 1
        else:
            set MissedThreats += 1
        SyncActiveCase()
        TerminalLog(DebugEnabled, "[BOSS] Final case accounted|CaseId={CurrentCaseId}|Resolved={TotalCasesResolved}|Correct={CorrectDecisions}|Missed={MissedThreats}")

    RefreshClaimLease(Player:player):void=
        set ClaimGeneration += 1
        ThisClaimGeneration := ClaimGeneration
        SyncActiveCase()
        spawn{ClaimInactivityTimeout(Player, CurrentCaseId, RunGeneration, ThisClaimGeneration)}

    ClaimInactivityTimeout(Player:player, ExpectedCaseId:int, ExpectedRun:int, ExpectedClaimGeneration:int)<suspends>:void=
        Sleep(ClaimInactivitySeconds)
        if (ExpectedClaimGeneration <> ClaimGeneration or not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            return
        if (Owner := ClaimOwner?, Owner = Player):
            CloseBodyScanInterface(Player)
            CloseXRayInterface(Player)
            CloseDocumentInterface(Player)
            set ClaimOwner = false
            set ClaimStage = terminal_claim_stage.None
            set ClaimGeneration += 1
            SyncActiveCase()
            ShowAll("Case {CurrentCaseId} ownership lease expired; completed observations are preserved for reassignment.", 5.0)
            TerminalLog(DebugEnabled, "[RECOVERY] Inactive case ownership released|CaseId={CurrentCaseId}")

    TryClaim(Agent:agent, Stage:terminal_claim_stage):logic=
        if (Player := player[Agent]):
            if (Owner := ClaimOwner?):
                if (Owner = Player):
                    set ClaimStage = Stage
                    RefreshClaimLease(Player)
                    return true
                ShowAgent(Agent, "Another officer owns Case {CurrentCaseId}. Wait for handoff or claim release.", 4.0)
                return false
            set ClaimOwner = option{Player}
            set ClaimStage = Stage
            RefreshClaimLease(Player)
            TerminalLog(DebugEnabled, "[CASE] Stage claimed|CaseId={CurrentCaseId}|Stage={ClaimStageLabel(Stage)}")
            return true
        false

    ReleaseStationClaim(Stage:terminal_claim_stage, Station:string, Outcome:string):void=
        if (Owner := ClaimOwner?, ClaimStage = Stage):
            set ClaimStage = terminal_claim_stage.None
            RefreshClaimLease(Owner)
            SyncActiveCase()
            ShowAgent(Owner, "{Station} | {Outcome} | You retain Case {CurrentCaseId} through final disposition.", 3.0)
            TerminalLog(DebugEnabled, "[CASE] Station complete; ownership retained|CaseId={CurrentCaseId}|Station={Station}|Outcome={Outcome}")

    ReleaseCurrentInspectionClaim(Outcome:string):void=
        if (ClaimStage = terminal_claim_stage.Body):
            ReleaseStationClaim(terminal_claim_stage.Body, "BODY SCANNER", Outcome)
        else if (ClaimStage = terminal_claim_stage.Baggage):
            ReleaseStationClaim(terminal_claim_stage.Baggage, "BAG X-RAY", Outcome)
        else if (ClaimStage = terminal_claim_stage.Documents):
            ReleaseStationClaim(terminal_claim_stage.Documents, "DOCUMENT DESK", Outcome)

    IsCaseInteractionLegal(Agent:agent):logic=
        if (CurrentCaseId <= 0 or CurrentTemplate <= 0):
            ShowAgent(Agent, "No active traveler is assigned to the checkpoint.", 4.0)
            return false
        if (ActiveCase.CaseId <> CurrentCaseId or ActiveCase.RunGeneration <> RunGeneration):
            ShowAgent(Agent, "Case state is resetting. Wait for the next passenger-ready signal.", 4.0)
            TerminalLog(DebugEnabled, "[CASE] Interaction rejected for unsynchronized active-case identity")
            return false
        if (Phase = terminal_game_phase.CaseReady or Phase = terminal_game_phase.AwaitingDecision or Phase = terminal_game_phase.Inspecting):
            return true
        ShowAgent(Agent, "Inspection unavailable during {PhaseLabel()}.", 4.0)
        false

    CanUseBodyScanner(Agent:agent):logic=
        if (not PowerOnline?):
            ShowAgent(Agent, "BODY SCANNER OFFLINE | Restore power in the staff utility room.", 5.0)
            return false
        if (ScanInProgress?):
            ShowAgent(Agent, "BODY SCAN IN PROGRESS | Hold the lane.", 3.0)
            return false
        if (BodyChecked?):
            ShowAgent(Agent, "BODY observation already recorded.", 3.0)
            return false
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return false
        if (not PassengerReadyForScan? or PassengerLocation <> terminal_passenger_location.ScannerEntry):
            ShowAgent(Agent, "WAIT FOR PASSENGER | Scanner unlocks only after verified scanner-entry arrival.", 4.0)
            return false
        if (not IsAgentNear(Agent, ScanButton.GetTransform().Translation, 700.0)?):
            ShowAgent(Agent, "MOVE TO THE SCANNER CONTROL PANEL.", 4.0)
            return false
        true

    CanUseBaggageStation(Agent:agent):logic=
        if (not PowerOnline?):
            ShowAgent(Agent, "BAGGAGE X-RAY OFFLINE | Restore terminal power.", 5.0)
            return false
        if (Shift < 2 or not BodyChecked?):
            ShowAgent(Agent, "BODY SCAN REQUIRED before baggage inspection.", 4.0)
            return false
        if (BagScanInProgress? or BagChecked?):
            ShowAgent(Agent, "BAG X-RAY already active or complete.", 3.0)
            return false
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return false
        if (PassengerLocation <> terminal_passenger_location.Baggage or BagLocation <> terminal_bag_location.ConveyorEntry):
            ShowAgent(Agent, "WAIT FOR BOTH ARRIVALS | Passenger and linked bag must be physically staged.", 5.0)
            return false
        if (not IsAgentNear(Agent, BagButton.GetTransform().Translation, 700.0)?):
            ShowAgent(Agent, "MOVE TO THE X-RAY OPERATOR CONSOLE.", 4.0)
            return false
        true

    CanUseDocumentStation(Agent:agent):logic=
        if (not PowerOnline?):
            ShowAgent(Agent, "DOCUMENT READER OFFLINE | Restore terminal power.", 5.0)
            return false
        if (Shift < 3 or not BodyChecked? or (Shift >= 2 and not BagChecked?)):
            ShowAgent(Agent, "PRIOR EVIDENCE REQUIRED | Complete body and linked-bag inspection.", 4.0)
            return false
        if (ScanInProgress? or BagScanInProgress?):
            ShowAgent(Agent, "INSPECTION STATION BUSY.", 3.0)
            return false
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return false
        if (PassengerLocation <> terminal_passenger_location.Documents):
            ShowAgent(Agent, "WAIT FOR PASSENGER | Document desk unlocks after verified arrival.", 4.0)
            return false
        if (not IsAgentNear(Agent, DocumentButton.GetTransform().Translation, 700.0)?):
            ShowAgent(Agent, "MOVE TO THE DOCUMENT TERMINAL.", 4.0)
            return false
        true

    BaseEvidenceComplete()<transacts>:logic=
        if (not BodyChecked?):
            return false
        if (Shift >= 2, not BagChecked?):
            return false
        if (Shift >= 3, not DocumentsChecked?):
            return false
        true

    ReadyForDecision()<transacts>:logic=
        if (not BaseEvidenceComplete()? or ScanInProgress? or BagScanInProgress? or ResolutionCommitted? or not PowerOnline?):
            return false
        if (ManualSearchRequested? and not SecondaryChecked?):
            return false
        if (SecondaryChecked?):
            if (PassengerLocation <> terminal_passenger_location.SecondaryPassenger):
                return false
            if (Shift >= 2, BagLocation <> terminal_bag_location.SecondaryTable):
                return false
            return true
        if (PassengerLocation <> terminal_passenger_location.Decision):
            return false
        if (Shift >= 2, BagLocation <> terminal_bag_location.ConveyorExit):
            return false
        true

    CanUseDecisionStation(Agent:agent, Decision:terminal_decision):logic=
        if (Phase <> terminal_game_phase.CaseReady and Phase <> terminal_game_phase.AwaitingDecision):
            ShowAgent(Agent, "Decision unavailable during {PhaseLabel()}.", 4.0)
            return false
        if (not ReadyForDecision()?):
            if (ManualSearchRequested? and not SecondaryChecked?):
                ShowAgent(Agent, "MANUAL SEARCH REQUIRED | Use the yellow Secondary control.", 5.0)
            else:
                ShowAgent(Agent, "DECISION LOCKED | Evidence and physical arrival are incomplete.", 5.0)
            return false
        var ControlLocation:vector3 = ClearButton.GetTransform().Translation
        if (Decision = terminal_decision.Secondary):
            set ControlLocation = SecondaryButton.GetTransform().Translation
        else if (Decision = terminal_decision.Detain):
            set ControlLocation = DetainButton.GetTransform().Translation
        if (not IsAgentNear(Agent, ControlLocation, 700.0)?):
            ShowAgent(Agent, "MOVE TO THE MATCHING PHYSICAL DECISION CONTROL.", 4.0)
            return false
        true

    CurrentExpectedDecision():terminal_decision=
        Required := RequiredDecision(CurrentTemplate)
        if (SecondaryChecked? and Required = terminal_decision.Secondary):
            if (CurrentTemplate = 7):
                return terminal_decision.Detain
            return terminal_decision.Clear
        Required

    RefreshDecisionControls():void=
        if (Phase = terminal_game_phase.CaseReady or Phase = terminal_game_phase.AwaitingDecision):
            if (ManualSearchRequested? and not SecondaryChecked? and BaseEvidenceComplete()? and PassengerLocation = terminal_passenger_location.Decision):
                ClearButton.Disable()
                SecondaryButton.Enable()
                DetainButton.Disable()
                SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nLOCKED - MANUAL SEARCH")
                SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nREQUIRED")
                SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nLOCKED - MANUAL SEARCH")
                return
            Ready := ReadyForDecision()
            SetDecisionControlsAvailable(Ready)
            return
        SetDecisionControlsAvailable(false)

    SetDecisionControlsAvailable(Available:logic):void=
        if (Available?):
            ClearButton.Enable()
            SecondaryButton.Enable()
            DetainButton.Enable()
            SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nAUTHORIZED")
            SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nAUTHORIZED")
            SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nAUTHORIZED")
            return
        ClearButton.Disable()
        SecondaryButton.Disable()
        DetainButton.Disable()
        SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nLOCKED - COMPLETE CHECKS")
        SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nLOCKED - COMPLETE CHECKS")
        SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nLOCKED - COMPLETE CHECKS")

    SetSecondaryFinalControls():void=
        ClearButton.Enable()
        SecondaryButton.Disable()
        DetainButton.Enable()
        SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nAUTHORIZED")
        SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nCHECK COMPLETE")
        SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nAUTHORIZED")

    ShowDecisionSubmitted(Decision:terminal_decision):void=
        ClearButton.Disable()
        SecondaryButton.Disable()
        DetainButton.Disable()
        if (Decision = terminal_decision.Clear):
            SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nSUBMITTED")
            SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nSTANDBY")
            SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nSTANDBY")
            return
        if (Decision = terminal_decision.Secondary):
            SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nSTANDBY")
            SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nSUBMITTED")
            SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nSTANDBY")
            return
        SetBoard(ClearBoard, "PASS | LET PASSENGER GO\nSTANDBY")
        SetBoard(SecondaryBoard, "SECONDARY | EXTRA CHECKS\nSTANDBY")
        SetBoard(DetainBoard, "JAIL | DETAIN PASSENGER\nSUBMITTED")

    IsAgentNear(Agent:agent, Target:vector3, Radius:float)<transacts>:logic=
        if (AutomatedReplayEnabled?):
            return true
        if (Character := Agent.GetFortCharacter[]):
            Location := Character.GetTransform().Translation
            DeltaX := Location.X - Target.X
            DeltaY := Location.Y - Target.Y
            DeltaZ := Location.Z - Target.Z
            RangeDistanceSquared := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ
            if (RangeDistanceSquared <= Radius * Radius):
                return true
        false

    IsAgentNearActivePassenger(Agent:agent, Radius:float)<transacts>:logic=
        ActiveLocation := ActivePassengerDevice().GetTransform().Translation
        IsAgentNear(Agent, ActiveLocation, Radius)

    IsActivePassengerNear(Target:vector3, Radius:float)<transacts>:logic=
        ActiveLocation := ActivePassengerDevice().GetTransform().Translation
        DeltaX := ActiveLocation.X - Target.X
        DeltaY := ActiveLocation.Y - Target.Y
        DeltaZ := ActiveLocation.Z - Target.Z
        RangeDistanceSquared := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ
        if (RangeDistanceSquared <= Radius * Radius):
            return true
        false

    IsHumanAgent(Agent:agent)<transacts>:logic=
        if (player[Agent]):
            return true
        false

    DamageIntegrity(Amount:int, Reason:string):void=
        set TeamIntegrity -= Amount
        if (TeamIntegrity < 0):
            set TeamIntegrity = 0
        if (TeamIntegrity <= 0):
            FinishDefeat(Reason)

    ScannerSweepStageSeconds()<transacts>:float=
        if (ScannerUpgradeLevel >= 3):
            return ScannerSweepSeconds * 0.5
        if (ScannerUpgradeLevel = 2):
            return ScannerSweepSeconds * 0.65
        if (ScannerUpgradeLevel = 1):
            return ScannerSweepSeconds * 0.8
        ScannerSweepSeconds

    CorrectPayout(Base:int)<transacts>:int=
        Base + PayoutUpgradeLevel * 40

    EmergencyWaitSeconds()<transacts>:float=
        if (EmergencyUpgradeLevel >= 3):
            return EmergencyTimeoutSeconds + 30.0
        if (EmergencyUpgradeLevel = 2):
            return EmergencyTimeoutSeconds + 20.0
        if (EmergencyUpgradeLevel = 1):
            return EmergencyTimeoutSeconds + 10.0
        EmergencyTimeoutSeconds

    PowerRepairObjective()<transacts>:string=
        if (PowerRepairStage = 0):
            return "POWER ROOM STEP 1/3 | RESET MAIN BREAKER"
        if (PowerRepairStage = 1):
            return "POWER ROOM STEP 2/3 | REROUTE BACKUP BUS"
        if (PowerRepairStage = 2):
            return "POWER ROOM STEP 3/3 | RESTART CHECKPOINT"
        "POWER RESTORATION COMMITTING"

    ScannerUpgradeCost()<transacts>:int=
        200 + ScannerUpgradeLevel * 100

    PayoutUpgradeCost()<transacts>:int=
        250 + PayoutUpgradeLevel * 100

    EmergencyUpgradeCost()<transacts>:int=
        200 + EmergencyUpgradeLevel * 75

    ScannerUpgradeLabel()<transacts>:string=
        if (ScannerUpgradeLevel >= 3):
            return "FAST SCANNER | MAXIMUM LEVEL"
        Cost := ScannerUpgradeCost()
        "BUY FAST SCANNER | ${Cost}"

    PayoutUpgradeLabel()<transacts>:string=
        if (PayoutUpgradeLevel >= 3):
            return "ACCURACY PAYOUT | MAXIMUM LEVEL"
        Cost := PayoutUpgradeCost()
        "BUY ACCURACY PAYOUT | ${Cost}"

    EmergencyUpgradeLabel()<transacts>:string=
        if (EmergencyUpgradeLevel >= 3):
            return "EMERGENCY RESERVE | MAXIMUM LEVEL"
        Cost := EmergencyUpgradeCost()
        "BUY EMERGENCY RESERVE | ${Cost}"

    RaiseRisk(Amount:int):void=
        set TeamRisk += Amount
        if (TeamRisk > 100):
            set TeamRisk = 100

    LowerRisk(Amount:int):void=
        set TeamRisk -= Amount
        if (TeamRisk < 0):
            set TeamRisk = 0

    ShowAgent(Agent:agent, Text:string, DisplayTime:float):void=
        StatusHUD.Show(Agent, TerminalMessage(Text), ?DisplayTime := DisplayTime)

    ShowAll(Text:string, DisplayTime:float):void=
        for (Player : GetPlayspace().GetPlayers()):
            StatusHUD.Show(Player, TerminalMessage(Text), ?DisplayTime := DisplayTime)

    SetBoard(Board:billboard_device, Text:string):void=
        Board.SetText(TerminalMessage(Text))
        Board.UpdateDisplay()
        Board.ShowText()

    CurrentStatus()<transacts>:string=
        if (Phase = terminal_game_phase.Waiting):
            return "TERMINAL LOCKDOWN | Press START SHIFT."
        if (Phase = terminal_game_phase.Results):
            return "RESULTS | Integrity {TeamIntegrity} | Correct {CorrectDecisions}/{TotalCasesResolved}"
        if (Phase = terminal_game_phase.Emergency):
            if (Shift = 5 and not PowerOnline?):
                return "POWER OUTAGE | Follow STAFF / POWER signs and restore the utility-room console."
            return "LOCKDOWN | {EmergencyLabel(Shift)} | Reach the secured response control."
        if (Phase = terminal_game_phase.Runner):
            return "RUNNER | Intercept Case {CurrentCaseId} before departure."
        if (Phase = terminal_game_phase.HostileResponse):
            return "RESISTANT SUSPECT | Take Signal Remote A; use PRIMARY FIRE inside response room."
        if (Phase = terminal_game_phase.SecondaryScreening):
            return "SECONDARY | Follow Case {CurrentCaseId} to the controlled room and perform the additional check."
        if (Phase = terminal_game_phase.Custody):
            return "CUSTODY | Deliver Case {CurrentCaseId} to detention intake."
        if (Phase = terminal_game_phase.BossJammer):
            return "FINAL THREAT | Disable the jammer at the power-room console."
        if (Phase = terminal_game_phase.BossBreach):
            return "FINAL THREAT | Interrupt the breach at the secured response station."
        if (Phase = terminal_game_phase.BossVulnerable):
            return "FINAL THREAT | Engage inside the response room at close range."
        if (Phase = terminal_game_phase.BossSecure):
            return "FINAL THREAT | Complete final custody at detention intake."
        "SHIFT {Shift} {ShiftLabel(Shift)} | CASE {CurrentCaseId} {TemplateName(CurrentTemplate)} | {EvidencePrompt()}"

    EvidencePrompt()<transacts>:string=
        if (not BodyChecked?):
            return "Next: BODY SCAN"
        if (Shift >= 2, not BagChecked?):
            return "Next: CHECK BAG"
        if (Shift >= 3, not DocumentsChecked?):
            return "Next: CHECK DOCUMENTS"
        "Evidence ready: CLEAR, SECONDARY, or DETAIN"

    FullEvidence(Template:int):string=
        "Body {BodyEvidence(Template)} | Bag {BagEvidence(Template)} | Docs {DocumentEvidence(Template)}"

    SecondaryPassengerClue(Template:int)<computes>:string=
        if (Template = 3):
            return "IDENTITY TRACE MATCHED | AUTHORITY RECORD NEEDS DATE REVIEW"
        if (Template = 7):
            return "TRACE CLEAN | POWER-CELL LABEL REMAINS PARTIALLY SHIELDED"
        if (Template = 10):
            return "IDENTITY MATCHED | ROUTE RECORD HAS A RECENT MANIFEST UPDATE"
        "IDENTITY + TRACE BASELINE | NO NEW BODY-SCAN ANOMALY"

    SecondaryResultText(Template:int)<computes>:string=
        if (Template = 7):
            return "SHIELDED CELL ARRAY | LABEL CODE CX-9 | CARGO POLICY APPLIES"
        if (Template = 3):
            return "AUTHORITY RECORD | DATE LAPSED | SUPERVISOR OVERRIDE AVAILABLE"
        if (Template = 10):
            return "MANIFEST UPDATE | GATE A3 CLOSED | A5 REBOOK CONFIRMED"
        "NO ADDITIONAL ANOMALY OBSERVED | USE COLLECTED EVIDENCE"

    IdentityName(Template:int)<computes>:string=
        if (Template = 1):
            return "MARA VALE"
        if (Template = 2):
            return "ORIN KEST"
        if (Template = 3):
            return "TESS ARBOR"
        if (Template = 4):
            return "JUNO REEF"
        if (Template = 5):
            return "PAX MERIDIAN"
        if (Template = 6):
            return "ELI NORTH"
        if (Template = 7):
            return "RIN SOLACE"
        if (Template = 8):
            return "KAI VECTOR"
        if (Template = 9):
            return "NOVA ASH"
        if (Template = 10):
            return "MILO QUAY"
        if (Template = 11):
            return "SERA LUMEN"
        if (Template = 12):
            return "ALIAS VEIL"
        "UNKNOWN"

    Destination(Template:int)<computes>:string=
        if (Template = 3 or Template = 10):
            return "GATE A3"
        if (Template = 4 or Template = 8 or Template = 12):
            return "NOVA HARBOR"
        if (Template = 7):
            return "CARGO TRANSFER"
        if (Template = 9):
            return "SECURE CONCOURSE"
        "SKYLINE GATE"

    DocumentNumber(Template:int)<computes>:string=
        if (Template = 1):
            return "AS-1048-NE"
        if (Template = 2):
            return "AS-2281-CR"
        if (Template = 3):
            return "AS-3107-TA"
        if (Template = 4):
            return "AS-4420-JR"
        if (Template = 5):
            return "AS-5144-PM"
        if (Template = 6):
            return "AS-6082-EN"
        if (Template = 7):
            return "AS-7349-RS"
        if (Template = 8):
            return "AS-8091-KV"
        if (Template = 9):
            return "AS-9175-NA"
        if (Template = 10):
            return "AS-0318-MQ"
        if (Template = 11):
            return "AS-1142-SL"
        "AS-1200-AV"

    ExpirationDate(Template:int)<computes>:string=
        if (Template = 3):
            return "2025-11-30"
        "2028-09-14"

    FlightAndGate(Template:int)<computes>:string=
        if (Template = 3 or Template = 10):
            return "AT-310 / A3"
        if (Template = 7):
            return "CX-707 / CARGO 2"
        if (Template = 9):
            return "AT-901 / S4"
        "AT-118 / B6"

    AccessLevel(Template:int)<computes>:string=
        if (Template = 7):
            return "CARGO TRANSFER"
        if (Template = 9 or Template = 12):
            return "SECURE TIER 4"
        "PUBLIC DEPARTURES"

    PortraitCheck(Template:int)<computes>:string=
        if (Template = 5):
            return "2 FEATURES DIFFER"
        "FEATURES CONSISTENT"

    ExpiryCheck(Template:int)<computes>:string=
        if (Template = 3):
            return "[!] EXPIRY: DATE PRECEDES CURRENT SHIFT"
        "[OK] EXPIRY: CURRENT"

    SealCheck(Template:int)<computes>:string=
        if (Template = 4):
            return "[!] SEAL: CHECKSUM DOES NOT MATCH"
        if (Template = 12):
            return "[!] SEAL: INTELLIGENCE CODE DUPLICATED"
        "[OK] SEAL: CHECKSUM MATCH"

    GateCheck(Template:int)<computes>:string=
        if (Template = 10):
            return "[!] ROUTE: GATE A3 CLOSED"
        "[OK] ROUTE: ACTIVE"

    AccessCheck(Template:int)<computes>:string=
        if (Template = 9):
            return "[!] ACCESS: TIER ALTERATION DETECTED"
        if (Template = 5):
            return "[!] PORTRAIT: IDENTITY COMPARISON REQUIRED"
        "[OK] ACCESS: ROUTE CONSISTENT"

    DocumentStatusColor(Template:int):color=
        if (Template = 3 or Template = 4 or Template = 5 or Template = 9 or Template = 10 or Template = 12):
            return NamedColors.Yellow
        NamedColors.LightGreen

    SelectTemplate(CurrentShift:int, CompletedInShift:int):int=
        if (CurrentShift = 1):
            if (CompletedInShift = 0):
                return 1
            if (CompletedInShift = 1):
                return 2
            return 6
        if (CurrentShift = 2):
            if (CompletedInShift = 0):
                return 1
            if (CompletedInShift = 1):
                return 7
            return 4
        if (CurrentShift = 3):
            if (CompletedInShift = 0):
                return 1
            if (CompletedInShift = 1):
                return 3
            return 5
        if (CurrentShift = 4):
            if (CompletedInShift = 0):
                return 6
            if (CompletedInShift = 1):
                return 4
            return 8
        if (CurrentShift = 5):
            if (CompletedInShift = 0):
                return 10
            if (CompletedInShift = 1):
                return 1
            return 9
        if (CurrentShift = 6):
            if (CompletedInShift = 0):
                return 8
            if (CompletedInShift = 1):
                return 9
            return 4
        if (CompletedInShift = 0):
            return 11
        if (CompletedInShift = 1):
            return 8
        12

    RequiredDecision(Template:int):terminal_decision=
        if (Template = 3 or Template = 7 or Template = 10):
            return terminal_decision.Secondary
        if (Template = 2 or Template = 4 or Template = 5 or Template = 8 or Template = 9 or Template = 12):
            return terminal_decision.Detain
        terminal_decision.Clear

    ScannerResultText(Template:int):string=
        if (Template = 2 or Template = 8):
            return "DETECTED / RIGID PROFILE"
        if (Template = 9):
            return "REVIEW / DENSE CARD PROFILE"
        "NO ANOMALY / BASELINE"

    BagResultText(Template:int):string=
        if (Template = 7):
            return "OVERLAP / MANUAL CHECK"
        if (Template = 4 or Template = 8 or Template = 12):
            return "DENSE OBJECT / REVIEW"
        "EXPECTED PERSONAL ITEMS"

    TemplateName(Template:int)<computes>:string=
        IdentityName(Template)

    BodyEvidence(Template:int):string=
        if (Template = 2):
            return "DENSE PROFILE | RIGHT HIP | 31 CM"
        if (Template = 8):
            return "RIGID PROFILE | OUTER LAYER | 24 CM"
        if (Template = 9):
            return "LAMINATED PROFILE | CHEST POCKET | HIGH DENSITY"
        "NO ANOMALY OBSERVED"

    BagEvidence(Template:int):string=
        if (Template = 4):
            return "SHIELDED ELECTRONICS | MULTIPLE ANTENNA-LIKE LINES"
        if (Template = 7):
            return "DENSE CELL ARRAY | LABEL PARTIALLY OBSCURED"
        if (Template = 8):
            return "SEALED MODULE | NONSTANDARD CONNECTOR PROFILE"
        if (Template = 12):
            return "COMPACT ELECTRONICS | SHIELDED CORE"
        "CLOTHING | PERSONAL ELECTRONICS | ROUTINE DENSITY"

    DocumentEvidence(Template:int):string=
        if (Template = 3):
            return "DATE FIELD | 2025-11-30"
        if (Template = 4):
            return "SEAL CODE | CHECKSUM 41-AX / 39"
        if (Template = 5):
            return "PORTRAIT COMPARE | TWO FEATURES DIFFER"
        if (Template = 9):
            return "ACCESS FIELD | TIER 4 / MANIFEST TIER 2"
        if (Template = 10):
            return "ROUTE FIELD | GATE A3 / STATUS CLOSED"
        if (Template = 12):
            return "SEAL FIELD | CODE ALSO PRESENT ON WATCH RECORD"
        "FIELDS CONSISTENT | SEAL CHECKSUM MATCH"

    ShiftLabel(CurrentShift:int)<computes>:string=
        if (CurrentShift = 1):
            return "BASIC SCREENING"
        if (CurrentShift = 2):
            return "BAGGAGE CONTROL"
        if (CurrentShift = 3):
            return "IDENTITY DESK"
        if (CurrentShift = 4):
            return "RUSH HOUR"
        if (CurrentShift = 5):
            return "SYSTEM FAULT"
        if (CurrentShift = 6):
            return "LOCKDOWN"
        if (CurrentShift = 7):
            return "FINAL BOARDING"
        "BRIEFING"

    EmergencyLabel(CurrentShift:int)<computes>:string=
        if (CurrentShift = 4):
            return "RUNNER INTERCEPT"
        if (CurrentShift = 5):
            return "POWER OUTAGE"
        "COORDINATED BREACH"

    ClaimStageLabel(Stage:terminal_claim_stage):string=
        if (Stage = terminal_claim_stage.Body):
            return "BODY"
        if (Stage = terminal_claim_stage.Baggage):
            return "BAGGAGE"
        if (Stage = terminal_claim_stage.Documents):
            return "DOCUMENTS"
        if (Stage = terminal_claim_stage.Secondary):
            return "SECONDARY"
        if (Stage = terminal_claim_stage.Decision):
            return "DECISION"
        if (Stage = terminal_claim_stage.Custody):
            return "CUSTODY"
        if (Stage = terminal_claim_stage.Response):
            return "RESPONSE"
        "NONE"

    DecisionLabel(Decision:terminal_decision):string=
        if (Decision = terminal_decision.Clear):
            return "CLEAR"
        if (Decision = terminal_decision.Secondary):
            return "SECONDARY"
        "DETAIN"

    PhaseLabel()<transacts>:string=
        if (Phase = terminal_game_phase.Waiting):
            return "WAITING"
        if (Phase = terminal_game_phase.Briefing):
            return "BRIEFING"
        if (Phase = terminal_game_phase.CaseReady):
            return "CASE READY"
        if (Phase = terminal_game_phase.Inspecting):
            return "INSPECTING"
        if (Phase = terminal_game_phase.AwaitingDecision):
            return "AWAITING DECISION"
        if (Phase = terminal_game_phase.SecondaryScreening):
            return "SECONDARY SCREENING"
        if (Phase = terminal_game_phase.Resolving):
            return "RESOLVING"
        if (Phase = terminal_game_phase.Runner):
            return "RUNNER"
        if (Phase = terminal_game_phase.HostileResponse):
            return "HOSTILE RESPONSE"
        if (Phase = terminal_game_phase.Custody):
            return "CUSTODY"
        if (Phase = terminal_game_phase.Emergency):
            return "LOCKDOWN"
        if (Phase = terminal_game_phase.UpgradeBreak):
            return "UPGRADE BREAK"
        if (Phase = terminal_game_phase.Results):
            return "RESULTS"
        "FINAL THREAT"

    BossBranchLabel()<transacts>:string=
        if (BossBranch = terminal_boss_branch.Detected):
            return "EARLY INTERCEPTION"
        if (BossBranch = terminal_boss_branch.Missed):
            return "MISSED AT CHECKPOINT"
        "NONE"

    ResultGrade()<transacts>:string=
        if (TeamIntegrity >= 90 and FalseDetentions = 0 and MissedThreats = 0):
            return "S"
        if (TeamIntegrity >= 75 and FalseDetentions <= 1):
            return "A"
        if (TeamIntegrity >= 55):
            return "B"
        if (TeamIntegrity >= 30):
            return "C"
        "TRAINING NEEDED"
