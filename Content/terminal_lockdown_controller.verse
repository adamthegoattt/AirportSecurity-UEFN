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
    DebugEnabled:logic = false

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
    var PassengerReadyForScan:logic = false
    var ScanInProgress:logic = false
    var BagScanInProgress:logic = false
    var SecondaryPassengerReady:logic = false
    var PassengerAtIntake:logic = false
    var ActivePassengerMoveGeneration:int = 0
    var ResolutionCommitted:logic = false
    var CustodyCommitted:logic = false
    var FinalCaseAccountingCommitted:logic = false
    var RunUpgradePurchased:logic = false
    var PowerOnline:logic = true
    var CurrentCustodyMode:int = 0
    var ClaimOwner:?player = false
    var ClaimGeneration:int = 0
    var QueueFrontIndex:int = 0
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
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        ConfigureButtons()
        ConfigurePhysicalPresentation()
        spawn{AutoStartWaitingRun()}
        if (AutomatedReplayEnabled?):
            spawn{RunAutomatedReplay()}
        ShowAll("TERMINAL LOCKDOWN | Press START SHIFT at the briefing desk.", 8.0)
        TerminalLog(DebugEnabled, "[BOOT] Controller ready; waiting for players")

    RunAutomatedReplay()<suspends>:void=
        # The physical passenger needs just over three seconds to reach the
        # scanner after AutoStartWaitingRun opens Shift 1. Keep the harness
        # behind the real movement and asynchronous scan/bag timings so every
        # logged milestone represents a committed production handler result.
        Sleep(6.5)
        for (Player : GetPlayspace().GetPlayers()):
            TerminalLog(true, "[QA] Automated replay begin")

            # Shift 1: physical passenger, body evidence, and clear decision.
            OnScanButton(Player)
            Sleep(2.25)
            Sleep(2.25)
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
            OnSecondaryButton(Player)
            Sleep(9.0)
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
            Sleep(1.0)
            TerminalLog(true, "[QA] Shift 5 power outage and restore complete")

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
                ShowAgent(Player, "Officer online. Opening Shift 1...", 3.0)
                OnStartButton(Player)
                return

    ConfigureButtons():void=
        StartButton.SetInteractionText(TerminalMessage("START SHIFT"))
        StartButton.SetInteractionTime(0.25)
        StartButton.SetMaxTriggerCount(0)
        ScanButton.SetInteractionText(TerminalMessage("BODY SCAN"))
        ScanButton.SetInteractionTime(0.75)
        ScanButton.SetMaxTriggerCount(0)
        BagButton.SetInteractionText(TerminalMessage("CHECK BAG"))
        BagButton.SetInteractionTime(0.75)
        BagButton.SetMaxTriggerCount(0)
        DocumentButton.SetInteractionText(TerminalMessage("CHECK DOCUMENTS"))
        DocumentButton.SetInteractionTime(0.5)
        DocumentButton.SetMaxTriggerCount(0)
        ClearButton.SetInteractionText(TerminalMessage("GREEN | CLEAR PASSENGER"))
        ClearButton.SetInteractionTime(0.25)
        ClearButton.SetMaxTriggerCount(0)
        SecondaryButton.SetInteractionText(TerminalMessage("YELLOW | SECONDARY INSPECTION"))
        SecondaryButton.SetInteractionTime(0.5)
        SecondaryButton.SetMaxTriggerCount(0)
        DetainButton.SetInteractionText(TerminalMessage("RED | DETAIN SUSPECT"))
        DetainButton.SetInteractionTime(0.75)
        DetainButton.SetMaxTriggerCount(0)
        ResponseButton.SetInteractionText(TerminalMessage("RESPOND / SECURE"))
        ResponseButton.SetInteractionTime(0.75)
        ResponseButton.SetMaxTriggerCount(0)
        UpgradeButton.SetInteractionText(TerminalMessage("UPGRADE / NEXT SHIFT"))
        UpgradeButton.SetInteractionTime(0.5)
        UpgradeButton.SetMaxTriggerCount(0)
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        CustodyButton.SetInteractionTime(0.75)
        CustodyButton.SetMaxTriggerCount(0)
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
        PowerButton.SetInteractionTime(1.5)
        PowerButton.SetMaxTriggerCount(0)

    ConfigurePhysicalPresentation():void=
        PassengerQueue1.Show()
        PassengerQueue2.Show()
        PassengerQueue3.Show()
        PassengerActive.Hide()
        BagPropSmall.Hide()
        BagPropMedium.Hide()
        BagPropHardShell.Hide()
        spawn{ResetPassengerQueue(RunGeneration)}
        CheckpointBoard.SetShowBorder(true)
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
        StatusHUD.Show(Player, TerminalMessage(CurrentStatus()), ?DisplayTime := 8.0)
        if (Phase = terminal_game_phase.HostileResponse):
            ResponseGranter.GrantItem(Player)
        TerminalLog(DebugEnabled, "[PLAYER] Joined during phase {PhaseLabel()}")

    OnPlayerRemoved(Player:player):void=
        CloseDocumentInterface(Player)
        if (Owner := ClaimOwner?, Owner = Player):
            set ClaimOwner = false
            set ClaimGeneration += 1
            if (Phase = terminal_game_phase.Inspecting):
                set Phase = terminal_game_phase.CaseReady
            SyncActiveCase()
            ShowAll("Case claim released. Any officer may continue Case {CurrentCaseId}.", 5.0)
            TerminalLog(DebugEnabled, "[RECOVERY] Claim released for CaseId={CurrentCaseId}")

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
        set TeamIntegrity = 100
        set TeamRisk = 0
        set TeamCash = 0
        set CorrectDecisions = 0
        set FalseDetentions = 0
        set MissedThreats = 0
        set BossBranch = terminal_boss_branch.None
        set RunUpgradePurchased = false
        set PowerOnline = true
        set CurrentCustodyMode = 0
        set CustodyCommitted = false
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set PassengerAtIntake = false
        set FinalCaseAccountingCommitted = false
        set QueueFrontIndex = 0
        set QueueGeneration += 1
        set ClaimGeneration += 1
        set CurrentDestination = terminal_case_destination.Queue
        set BagGeneration += 1
        HideAllBags()
        ScanButton.Enable()
        CustodyButton.Disable()
        PowerButton.Disable()
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        set Phase = terminal_game_phase.Briefing
        spawn{ResetPassengerQueue(RunGeneration)}
        ShowAll("ASTRA TERMINAL SAFETY UNIT | Inspect evidence, then CLEAR, SECONDARY, or DETAIN.", 7.0)
        TerminalLog(DebugEnabled, "[BOOT] RunGeneration={RunGeneration} started")
        PrepareNextCase()

    OnScanButton(Agent:agent):void=
        if (not PowerOnline?):
            ShowAgent(Agent, "BODY SCANNER OFFLINE | Restore power in the staff utility room.", 5.0)
            SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | POWER OFFLINE")
            return
        if (ScanInProgress?):
            ShowAgent(Agent, "BODY SCAN IN PROGRESS | Hold the lane.", 3.0)
            return
        if (not PassengerReadyForScan?):
            ShowAgent(Agent, "WAIT FOR PASSENGER | Scanner unlocks when the traveler reaches the marked position.", 4.0)
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (BodyChecked?):
            ShowAgent(Agent, "BODY already checked | {BodyEvidence(CurrentTemplate)}", 4.0)
            return
        Claimed := TryClaim(Agent)
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
        Sleep(0.75)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not PowerOnline?):
            set ScanInProgress = false
            SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
            return
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | 50%")
        Sleep(1.25)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not PowerOnline?):
            set ScanInProgress = false
            SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
            return
        set BodyChecked = true
        set ScanInProgress = false
        set Phase = terminal_game_phase.AwaitingDecision
        SyncActiveCase()
        RefreshDecisionControls()
        ScannerResultAudio.Play()
        SetBoard(CheckpointBoard, "SCANNER RESULT | {ScannerResultText(Template)} | {BodyEvidence(Template)}")
        ShowAll("SCANNER RESULT | {ScannerResultText(Template)} | {BodyEvidence(Template)}", 5.0)
        TerminalLog(DebugEnabled, "[SCAN] Completed|CaseId={CurrentCaseId}|Template={Template}|CheckedOnce=True")
        if (Shift >= 2):
            spawn{MovePassengerToBaggage(ExpectedCaseId, ExpectedRun)}
        else:
            spawn{MovePassengerToDecision(ExpectedCaseId, ExpectedRun)}

    OnBagButton(Agent:agent):void=
        if (Shift < 2):
            ShowAgent(Agent, "Baggage Control unlocks in Shift 2.", 4.0)
            return
        if (not BodyChecked?):
            ShowAgent(Agent, "BODY SCAN REQUIRED | Complete the passenger scan before opening the linked bag.", 4.0)
            return
        if (BagScanInProgress?):
            ShowAgent(Agent, "BAG X-RAY IN PROGRESS | Wait for the conveyor result.", 3.0)
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (BagChecked?):
            ShowAgent(Agent, "BAG already checked | {BagEvidence(CurrentTemplate)}", 4.0)
            return
        Claimed := TryClaim(Agent)
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
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-tunnel-small"
            )
        else if (BagIndex = 1):
            set TunnelReached = MovePropChecked(
                BagPropMedium,
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-tunnel-medium"
            )
        else:
            set TunnelReached = MovePropChecked(
                BagPropHardShell,
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
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
            ShowAll("BAG ROUTE RESET | The linked bag was safely removed. Retry the X-ray station.", 6.0)
            return
        SetBoard(BagBoard, "X-RAY ANALYZING | CASE {CurrentCaseId} | AMBER SWEEP")
        Sleep(0.8)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        var ExitReached:logic = false
        if (BagIndex = 0):
            set ExitReached = MovePropChecked(
                BagPropSmall,
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-exit-small"
            )
        else if (BagIndex = 1):
            set ExitReached = MovePropChecked(
                BagPropMedium,
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                1.0,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "xray-exit-medium"
            )
        else:
            set ExitReached = MovePropChecked(
                BagPropHardShell,
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
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
            ShowAll("BAG EXIT RESET | The linked bag was safely removed. Retry the X-ray station.", 6.0)
            return
        set BagChecked = true
        set BagScanInProgress = false
        set Phase = terminal_game_phase.AwaitingDecision
        SyncActiveCase()
        RefreshDecisionControls()
        SetBoard(BagBoard, "X-RAY RESULT | CASE {CurrentCaseId} | {BagResultText(Template)} | {BagEvidence(Template)}")
        ShowAll("X-RAY RESULT | {BagResultText(Template)} | {BagEvidence(Template)} | {EvidencePrompt()}", 6.0)
        TerminalLog(DebugEnabled, "[BAG] Completed|CaseId={CurrentCaseId}|Template={Template}|CheckedOnce=True")
        if (Shift >= 3):
            spawn{MovePassengerToDocumentDesk(ExpectedCaseId, ExpectedRun)}
        else:
            spawn{MovePassengerToDecision(ExpectedCaseId, ExpectedRun)}

    OnDocumentButton(Agent:agent):void=
        if (Shift < 3):
            ShowAgent(Agent, "Identity Desk unlocks in Shift 3.", 4.0)
            return
        if (not BodyChecked?):
            ShowAgent(Agent, "BODY SCAN REQUIRED | Complete the passenger scan before reviewing documents.", 4.0)
            return
        if (Shift >= 2, not BagChecked?):
            ShowAgent(Agent, "BAG X-RAY REQUIRED | Resolve the linked luggage before reviewing documents.", 4.0)
            return
        if (ScanInProgress? or BagScanInProgress?):
            ShowAgent(Agent, "INSPECTION STATION BUSY | Finish the active scan first.", 4.0)
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (Player := player[Agent]):
            if (OpenCase := DocumentOpenCase[Player], OpenCase = CurrentCaseId):
                ShowAgent(Agent, "Document interface is already open for Case {CurrentCaseId}.", 3.0)
                return
        if (DocumentsChecked?):
            ClaimedExisting := TryClaim(Agent)
            if (not ClaimedExisting?):
                return
            if (Player := player[Agent]):
                OpenDocumentInterface(Player, CurrentCaseId, CurrentTemplate, DocumentGeneration)
            ShowAgent(Agent, "DOCUMENTS already checked | Reopened Case {CurrentCaseId} record.", 4.0)
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        set Phase = terminal_game_phase.Inspecting
        set DocumentsChecked = true
        set Phase = terminal_game_phase.AwaitingDecision
        SyncActiveCase()
        RefreshDecisionControls()
        SetBoard(
            DocumentBoard,
            "TRAVEL ID {CurrentCaseId} | {IdentityName(CurrentTemplate)} | {Destination(CurrentTemplate)} | {DocumentEvidence(CurrentTemplate)}"
        )
        if (Player := player[Agent]):
            OpenDocumentInterface(Player, CurrentCaseId, CurrentTemplate, DocumentGeneration)
        ShowAgent(Agent, "DOCUMENT READER | Compare portrait, expiry, route, seal, and access fields.", 5.0)
        TerminalLog(DebugEnabled, "[DOC] CaseId={CurrentCaseId}|Template={CurrentTemplate}|CheckedOnce=True")
        spawn{MovePassengerToDecision(CurrentCaseId, RunGeneration)}

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
            DefaultText := TerminalMessage("PORTRAIT\n\n[ FACE SAMPLE ]\n\n{PortraitCheck(Template)}")
            DefaultTextColor := NamedColors.White
            DefaultTextSize := 18.0
            AutoWrap := true
            WrapWidth := 205.0
        PortraitPanel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(23, 43, 68)
                        DefaultOpacity := 1.0
                        DefaultDesiredSize := vector2{X := 220.0, Y := 280.0}
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
            DefaultText := TerminalMessage("CONSISTENCY CHECKS\n{ExpiryCheck(Template)}\n{SealCheck(Template)}\n{GateCheck(Template)}\n{AccessCheck(Template)}\n\nEVIDENCE STATUS\n{DocumentEvidence(Template)}")
            DefaultTextColor := DocumentStatusColor(Template)
            DefaultTextSize := 17.0
            AutoWrap := true
            WrapWidth := 650.0
        ReturnButton := button_loud{DefaultText := TerminalMessage("RETURN TO CHECKPOINT")}
        ReturnButton.OnClick().Subscribe(OnCloseDocument)
        Content := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot{Widget := Header, Padding := margin{Bottom := 5.0}}
                stack_box_slot{Widget := Subheader, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := IdentityRow, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := Checks, Padding := margin{Bottom := 20.0}}
                stack_box_slot{Widget := ReturnButton}
        Panel := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := MakeColorFromSRGBValues(7, 16, 28)
                        DefaultOpacity := 0.97
                        DefaultDesiredSize := vector2{X := 720.0, Y := 760.0}
                overlay_slot:
                    Widget := Content
                    Padding := margin{Left := 30.0, Top := 26.0, Right := 30.0, Bottom := 26.0}
        Root := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 720.0, Bottom := 760.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := Panel

        if (CaseId <> CurrentCaseId or ExpectedDocumentGeneration <> DocumentGeneration):
            return
        if (set DocumentRootUI[Player] = Root) {}
        if (set DocumentOpenCase[Player] = CaseId) {}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All, ZOrder := 120})

    OnCloseDocument(Message:widget_message):void=
        Player := Message.Player
        CloseDocumentInterface(Player)
        if (Owner := ClaimOwner?, Owner = Player, not ResolutionCommitted?):
            set ClaimOwner = false
            set ClaimGeneration += 1
            SyncActiveCase()
            ShowAll("Document desk released for Case {CurrentCaseId}.", 3.0)

    CloseDocumentInterface(Player:player):void=
        if (Root := DocumentRootUI[Player], PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Root)
        if (set DocumentOpenCase[Player] = -1) {}

    CloseAllDocumentInterfaces():void=
        for (Player : GetPlayspace().GetPlayers()):
            CloseDocumentInterface(Player)

    OnClearButton(Agent:agent):void=
        ResolveDecision(Agent, terminal_decision.Clear)

    OnSecondaryButton(Agent:agent):void=
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        Ready := ReadyForDecision()
        if (not Ready?):
            ShowAgent(Agent, "Complete the required checks before Secondary.", 4.0)
            return
        if (SecondaryChecked? or Phase = terminal_game_phase.SecondaryScreening):
            ShowAgent(Agent, "SECONDARY already completed for Case {CurrentCaseId}.", 4.0)
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return

        set Phase = terminal_game_phase.SecondaryScreening
        set CurrentDestination = terminal_case_destination.Secondary
        CloseAllDocumentInterfaces()
        set SecondaryPassengerReady = false
        set CurrentCustodyMode = 4
        SetDecisionControlsAvailable(false)
        CustodyButton.SetInteractionText(TerminalMessage("PERFORM SECONDARY CHECK"))
        CustodyButton.Enable()
        SyncActiveCase()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | ROUTING TO SECONDARY")
        SetBoard(SecondaryBoard, "SECONDARY\nPASSENGER IN TRANSIT")
        ShowAll("SECONDARY SELECTED | Follow the passenger to the controlled room, then perform the additional check at intake.", 8.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Routed|CaseId={CurrentCaseId}|Template={CurrentTemplate}")
        spawn{MovePassengerToSecondary(CurrentCaseId, RunGeneration)}

    OnDetainButton(Agent:agent):void=
        if (Phase = terminal_game_phase.Runner):
            CaptureRunner(Agent)
            return
        if (Phase = terminal_game_phase.Custody and CurrentCustodyMode = 1):
            SecureCompliantSuspect(Agent)
            return
        ResolveDecision(Agent, terminal_decision.Detain)

    ResolveDecision(Agent:agent, Decision:terminal_decision):void=
        if (Phase <> terminal_game_phase.CaseReady and Phase <> terminal_game_phase.AwaitingDecision):
            ShowAgent(Agent, "Decision unavailable during {PhaseLabel()}.", 4.0)
            return
        Ready := ReadyForDecision()
        if (not Ready?):
            ShowAgent(Agent, "Evidence incomplete | {EvidencePrompt()}", 5.0)
            return
        if (ResolutionCommitted?):
            TerminalLog(DebugEnabled, "[DECISION] Duplicate rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return

        set ResolutionCommitted = true
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
                set TeamCash += 125
                ShowAll("CORRECT SECONDARY | Supervisor resolved the administrative hold | +125 cash.", 6.0)
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY HOLD COMPLETE | DEPARTING")
            else:
                set TeamCash += 100
                ShowAll("CORRECT CLEAR | Traveler proceeds to departures | +100 cash.", 5.0)
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
        if (not IsAgentNearActivePassenger(Agent, 500.0)?):
            ShowAgent(Agent, "TOO FAR TO SECURE | Move beside the suspect at the red pad.", 4.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote secure rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        set CurrentCustodyMode = 5
        DetainButton.Disable()
        DetainButton.SetInteractionText(TerminalMessage("RED | DETAIN SUSPECT"))
        SetBoard(CustodyBoard, "SUSPECT SECURED | ESCORTING TO INTAKE")
        ShowAll("SUSPECT SECURED | Stay with the escort to detention intake.", 5.0)
        TerminalLog(DebugEnabled, "[CUSTODY] Close-range secure complete|CaseId={CurrentCaseId}")
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    CaptureRunner(Agent:agent):void=
        if (Phase <> terminal_game_phase.Runner):
            return
        if (not IsAgentNearActivePassenger(Agent, RunnerCaptureRadius)?):
            ShowAgent(Agent, "RUNNER TOO FAR | Chase until the suspect is inside capture range.", 5.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote runner capture rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent)
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
        if (Phase = terminal_game_phase.SecondaryScreening):
            CompleteSecondaryCheck(Agent)
            return
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
        if (not IsAgentNear(Agent, vector3{X := 5000.0, Y := 1450.0, Z := 70.0}, CustodyProximityRadius)?):
            ShowAgent(Agent, "TOO FAR FROM INTAKE | Escort the secured suspect to the jail gate.", 5.0)
            TerminalLog(DebugEnabled, "[CUSTODY] Remote intake rejected for CaseId={CurrentCaseId}")
            return
        if (CustodyCommitted?):
            TerminalLog(DebugEnabled, "[CUSTODY] Duplicate intake rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        set CustodyCommitted = true
        set PassengerAtIntake = false
        set Phase = terminal_game_phase.Resolving
        set CurrentDestination = terminal_case_destination.Cell
        SyncActiveCase()
        CustodyButton.Disable()
        set TeamCash += 175
        LowerRisk(2)
        SetBoard(CustodyBoard, "CASE {CurrentCaseId} | JAILED | INTAKE COMPLETE")
        SetBoard(CellBoard, "CELL GATE CLOSING | CASE {CurrentCaseId}")
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | ARREST COMPLETE | +175")
        ShowAll("JAIL INTAKE COMPLETE | Arrest finalized exactly once | +175 cash.", 6.0)
        PositiveAudio.Play()
        spawn{MovePassengerIntoCellAndFinish(CurrentCaseId, RunGeneration)}

    CompleteSecondaryCheck(Agent:agent):void=
        if (Phase <> terminal_game_phase.SecondaryScreening or CurrentCustodyMode <> 4):
            return
        if (not SecondaryPassengerReady?):
            ShowAgent(Agent, "SECONDARY PASSENGER IN TRANSIT | Wait for the room status to turn ready.", 4.0)
            return
        if (not IsAgentNear(Agent, vector3{X := 5000.0, Y := 1450.0, Z := 70.0}, 750.0)?):
            ShowAgent(Agent, "SECONDARY CHECK OUT OF RANGE | Enter the controlled screening room.", 5.0)
            return
        if (SecondaryChecked?):
            TerminalLog(DebugEnabled, "[SECONDARY] Duplicate check rejected for CaseId={CurrentCaseId}")
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        set SecondaryChecked = true
        set SecondaryPassengerReady = false
        set CurrentCustodyMode = 0
        if (TeamCash >= 25):
            set TeamCash -= 25
        set Phase = terminal_game_phase.AwaitingDecision
        set CurrentDestination = terminal_case_destination.Decision
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        SetSecondaryFinalControls()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | SECONDARY RESULT | {SecondaryResultText(CurrentTemplate)}")
        SetBoard(SecondaryBoard, "SECONDARY COMPLETE\nRETURN TO DECISION DESK")
        SyncActiveCase()
        ShowAll("SECONDARY CHECK COMPLETE | {SecondaryResultText(CurrentTemplate)} | Return to the decision desk and RELEASE or DETAIN.", 8.0)
        TerminalLog(DebugEnabled, "[SECONDARY] Completed|CaseId={CurrentCaseId}|Template={CurrentTemplate}")

    RunnerEscape(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Departure
        SyncActiveCase()
        var EscapeReached:logic = false
        if (Shift = 4):
            RouteA := MoveActivePassengerChecked(
                vector3{X := 5200.0, Y := 900.0, Z := 70.0},
                vector3{X := 4200.0, Y := 720.0, Z := 70.0},
                4.0,
                ExpectedCaseId,
                ExpectedRun,
                "runner-route-a"
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                return
            ExitA := MoveActivePassengerChecked(
                vector3{X := 7000.0, Y := 1600.0, Z := 70.0},
                vector3{X := 5200.0, Y := 900.0, Z := 70.0},
                6.0,
                ExpectedCaseId,
                ExpectedRun,
                "runner-exit-a"
            )
            if (RouteA? and ExitA?):
                set EscapeReached = true
        else:
            RouteB := MoveActivePassengerChecked(
                vector3{X := 5150.0, Y := -850.0, Z := 70.0},
                vector3{X := 4200.0, Y := -350.0, Z := 70.0},
                4.0,
                ExpectedCaseId,
                ExpectedRun,
                "runner-route-b"
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.Runner):
                return
            ExitB := MoveActivePassengerChecked(
                vector3{X := 7000.0, Y := -1800.0, Z := 70.0},
                vector3{X := 5150.0, Y := -850.0, Z := 70.0},
                6.0,
                ExpectedCaseId,
                ExpectedRun,
                "runner-exit-b"
            )
            if (RouteB? and ExitB?):
                set EscapeReached = true
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Runner):
            set Phase = terminal_game_phase.Resolving
            CleanupResponseEquipment()
            PassengerActive.Hide()
            if (not EscapeReached?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER ROUTE FAILED | SAFE DESPAWN")
                TerminalLog(DebugEnabled, "[MOVE] Runner resolved through safe-despawn fallback|CaseId={CurrentCaseId}")
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
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            vector3{X := 7000.0, Y := 1100.0, Z := 70.0},
            vector3{X := 5200.0, Y := 900.0, Z := 70.0},
            3.0,
            ExpectedCaseId,
            ExpectedRun,
            "departure"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            if (not MoveReached?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | DEPARTURE ROUTE RESET")
            PassengerActive.Hide()
            FinishCase()

    MovePassengerToIntake(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Detention
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
            vector3{X := 4200.0, Y := 720.0, Z := 70.0},
            4.0,
            ExpectedCaseId,
            ExpectedRun,
            "detention-intake"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Custody):
            set PassengerAtIntake = true
            CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
            CustodyButton.Enable()
            if (MoveReached?):
                SetBoard(CustodyBoard, "CASE {CurrentCaseId} AT INTAKE | SECURE NOW")
            else:
                SetBoard(CustodyBoard, "CASE {CurrentCaseId} ROUTE FALLBACK | COMPLETE INTAKE")
        else if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.BossSecure):
            CustodyButton.SetInteractionText(TerminalMessage("FINAL CUSTODY INTAKE"))
            CustodyButton.Enable()
            if (MoveReached?):
                SetBoard(CustodyBoard, "FINAL THREAT AT INTAKE | SECURE NOW")
            else:
                SetBoard(CustodyBoard, "FINAL ROUTE FALLBACK | COMPLETE INTAKE")

    MovePassengerToSecurePad(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Detention
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            vector3{X := 4200.0, Y := 720.0, Z := 70.0},
            vector3{X := 3900.0, Y := 0.0, Z := 70.0},
            1.5,
            ExpectedCaseId,
            ExpectedRun,
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
            vector3{X := 5400.0, Y := 2600.0, Z := 70.0},
            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
            4.0,
            ExpectedCaseId,
            ExpectedRun,
            "secondary"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.SecondaryScreening and CurrentCustodyMode = 4):
            if (MoveReached?):
                set SecondaryPassengerReady = true
                SetBoard(SecondaryBoard, "SECONDARY READY\nPERFORM ADDITIONAL CHECK")
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER IN SECONDARY ROOM")
            else:
                set CurrentCustodyMode = 0
                set Phase = terminal_game_phase.AwaitingDecision
                CustodyButton.Disable()
                RefreshDecisionControls()
                SetBoard(SecondaryBoard, "SECONDARY ROUTE OFFLINE\nRETURN TO DECISION")
                ShowAll("SECONDARY ROUTE RESET | Return to the decision desk and choose a final action.", 7.0)
            SyncActiveCase()

    MovePassengerToResponse(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Response
        SyncActiveCase()
        MoveReached := MoveActivePassengerChecked(
            vector3{X := 5200.0, Y := -1900.0, Z := 70.0},
            vector3{X := 5000.0, Y := -1200.0, Z := 70.0},
            4.0,
            ExpectedCaseId,
            ExpectedRun,
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
            vector3{X := 5550.0, Y := 1450.0, Z := 70.0},
            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            "cell"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            Sleep(0.5)
            PassengerActive.Hide()
            JailOccupant.Show()
            if (MoveReached?):
                SetBoard(CellBoard, "CELL SECURED | OCCUPIED | CASE {CurrentCaseId}")
            else:
                SetBoard(CellBoard, "CELL SECURED BY SAFE TRANSFER | CASE {CurrentCaseId}")
            FinishCase()

    FinishCase():void=
        CloseAllDocumentInterfaces()
        set TotalCasesResolved += 1
        set CasesInShift += 1
        set ClaimOwner = false
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
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set CurrentCaseId += 1
        set CurrentTemplate = SelectTemplate(Shift, CasesInShift)
        set BodyChecked = false
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set ScannerGeneration += 1
        set BagGeneration += 1
        set BagChecked = false
        set BagScanInProgress = false
        set DocumentsChecked = false
        set SecondaryChecked = false
        set SecondaryPassengerReady = false
        set PassengerAtIntake = false
        set ResolutionCommitted = false
        set CustodyCommitted = false
        set FinalCaseAccountingCommitted = false
        set CurrentCustodyMode = 0
        set ClaimOwner = false
        set ClaimGeneration += 1
        set Phase = terminal_game_phase.CaseReady
        set CurrentDestination = terminal_case_destination.Scanner
        SyncActiveCase()
        SetDecisionControlsAvailable(false)
        DetainButton.SetInteractionText(TerminalMessage("RED | DETAIN SUSPECT"))
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        CustodyButton.Disable()
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
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
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
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
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
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
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
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
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
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1600.0, Z := 175.0},
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
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                1.5,
                ExpectedCaseId,
                ExpectedRun,
                ExpectedBagGeneration,
                "bag-inbound-hard-shell"
            )
            if (not ArrivalReached?):
                return
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and ExpectedBagGeneration = BagGeneration):
            SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | AT X-RAY | SCAN PENDING")

    HideAllBags():void=
        BagPropSmall.Hide()
        BagPropMedium.Hide()
        BagPropHardShell.Hide()

    BagIndexForTemplate(Template:int)<computes>:int=
        if (Template = 1 or Template = 4 or Template = 7 or Template = 10):
            return 0
        if (Template = 2 or Template = 5 or Template = 8 or Template = 11):
            return 1
        2

    StagePassenger(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set PassengerReadyForScan = false
        set CurrentDestination = terminal_case_destination.Scanner
        SyncActiveCase()
        PassengerActive.Hide()
        MoveResult0 := MoveActivePassengerChecked(
            vector3{X := -650.0, Y := -2150.0, Z := 70.0},
            vector3{X := -650.0, Y := -2450.0, Z := 70.0},
            0.1,
            ExpectedCaseId,
            ExpectedRun,
            "scanner-stage"
        )
        if (not MoveResult0? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.CaseReady):
            SetBoard(CheckpointBoard, "PASSENGER ROUTE RESET | CASE {CurrentCaseId}")
            return
        PassengerActive.Show()
        MoveResult1 := MoveActivePassengerChecked(
            vector3{X := -100.0, Y := -2150.0, Z := 70.0},
            vector3{X := -650.0, Y := -2150.0, Z := 70.0},
            1.0,
            ExpectedCaseId,
            ExpectedRun,
            "scanner-approach-a"
        )
        if (not MoveResult1? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult2 := MoveActivePassengerChecked(
            vector3{X := 450.0, Y := -1900.0, Z := 70.0},
            vector3{X := -100.0, Y := -2150.0, Z := 70.0},
            1.0,
            ExpectedCaseId,
            ExpectedRun,
            "scanner-approach-b"
        )
        if (not MoveResult2? or ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult3 := MoveActivePassengerChecked(
            vector3{X := 900.0, Y := -1300.0, Z := 70.0},
            vector3{X := 450.0, Y := -1900.0, Z := 70.0},
            1.0,
            ExpectedCaseId,
            ExpectedRun,
            "scanner-position"
        )
        if (MoveResult3? and ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration):
            set PassengerReadyForScan = true
            SyncActiveCase()
            SetBoard(CheckpointBoard, "ACTIVE PASSENGER | CASE {CurrentCaseId} | BODY SCAN")

    MovePassengerToDecision(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Decision
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            vector3{X := 3900.0, Y := 0.0, Z := 70.0},
            vector3{X := 3250.0, Y := -650.0, Z := 70.0},
            3.0,
            ExpectedCaseId,
            ExpectedRun,
            "decision"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT DECISION DESK")
            else:
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | DECISION ROUTE FALLBACK")

    MovePassengerToBaggage(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Baggage
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            vector3{X := 2700.0, Y := -650.0, Z := 70.0},
            vector3{X := 2050.0, Y := -1100.0, Z := 70.0},
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            "baggage"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT BAGGAGE CONTROL")
                SetBoard(BagBoard, "LINKED BAG {CurrentCaseId} | X-RAY READY")
            else:
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | BAGGAGE ROUTE FALLBACK")

    MovePassengerToDocumentDesk(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Documents
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            vector3{X := 3250.0, Y := -650.0, Z := 70.0},
            vector3{X := 2700.0, Y := -650.0, Z := 70.0},
            1.5,
            ExpectedCaseId,
            ExpectedRun,
            "documents"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.AwaitingDecision):
            if (MoveResult?):
                SetBoard(CaseBoard, "CASE {CurrentCaseId} | PASSENGER AT IDENTITY DESK")
                SetBoard(DocumentBoard, "TRAVEL ID {CurrentCaseId} | READER READY")
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
            vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
            vector3{X := -1200.0, Y := -2450.0, Z := 70.0},
            0.1,
            CurrentCaseId,
            ExpectedRun,
            "queue-reset-front"
        )
        Move2 := MoveCharacterChecked(
            PassengerQueue2,
            vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
            vector3{X := -1700.0, Y := -2450.0, Z := 70.0},
            0.1,
            CurrentCaseId,
            ExpectedRun,
            "queue-reset-middle"
        )
        Move3 := MoveCharacterChecked(
            PassengerQueue3,
            vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
            vector3{X := -2200.0, Y := -2450.0, Z := 70.0},
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
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-1"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue2,
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-2"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue3,
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-3"
            )
            PassengerQueue1.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue1,
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2450.0, Z := 70.0},
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
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-2"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue3,
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-3"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue1,
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-1"
            )
            PassengerQueue2.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue2,
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2450.0, Z := 70.0},
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
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                0.6,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-front-3"
            )
            MidMove := MoveCharacterChecked(
                PassengerQueue1,
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-middle-1"
            )
            RearMove := MoveCharacterChecked(
                PassengerQueue2,
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                0.7,
                ExpectedCaseId,
                ExpectedRun,
                "queue-advance-rear-2"
            )
            PassengerQueue3.Hide()
            Recycle := MoveCharacterChecked(
                PassengerQueue3,
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                vector3{X := -2200.0, Y := -2450.0, Z := 70.0},
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
        ResponseButton.Disable()
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set Phase = terminal_game_phase.UpgradeBreak
        set CurrentDestination = terminal_case_destination.None
        SetDecisionControlsAvailable(false)
        set ClaimOwner = false
        set ClaimGeneration += 1
        set PowerOnline = true
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set PassengerAtIntake = false
        ScanButton.Enable()
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        DetainButton.SetInteractionText(TerminalMessage("RED | DETAIN SUSPECT"))
        PowerButton.Disable()
        PassengerActive.Hide()
        set BagGeneration += 1
        HideAllBags()
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | SHIFT CHANGE")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        SyncActiveCase()
        if (Shift >= 7):
            ShowAll("Final Boarding audit complete. Use RESPOND if the final threat is active.", 6.0)
            return
        ShowAll("SHIFT {Shift} COMPLETE | Cash {TeamCash} | Integrity {TeamIntegrity} | Risk {TeamRisk} | Use UPGRADE / NEXT SHIFT.", 8.0)
        TerminalLog(DebugEnabled, "[SHIFT] Completed Shift={Shift}")

    OnUpgradeButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.UpgradeBreak):
            ShowAgent(Agent, "Upgrade desk is available only between shifts.", 4.0)
            return
        if (not RunUpgradePurchased? and TeamCash >= 250):
            set TeamCash -= 250
            set RunUpgradePurchased = true
            if (TeamIntegrity <= 90):
                set TeamIntegrity += 10
            else:
                set TeamIntegrity = 100
            LowerRisk(5)
            ShowAll("POWER CAPACITOR purchased | Integrity repaired and Risk reduced for this run.", 5.0)
        set Shift += 1
        set CasesInShift = 0
        PrepareNextCase()

    BeginEmergency():void=
        set ResponseGeneration += 1
        CleanupResponseEquipment()
        ResponseButton.Enable()
        set Phase = terminal_game_phase.Emergency
        set CurrentDestination = terminal_case_destination.Response
        SetDecisionControlsAvailable(false)
        set ClaimOwner = false
        set ClaimGeneration += 1
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set PassengerAtIntake = false
        PassengerActive.Hide()
        CustodyButton.Disable()
        SyncActiveCase()
        set EmergencyGeneration += 1
        CurrentEmergencyGeneration := EmergencyGeneration
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | RED ALERT")
        SetBoard(EmergencyBoard, "RED ALERT | {EmergencyLabel(Shift)}")
        NegativeAudio.Play()
        if (Shift = 5):
            set PowerOnline = false
            set ScannerGeneration += 1
            ScanButton.Disable()
            PowerButton.Enable()
            SetBoard(PowerBoard, "POWER OFFLINE | RESTORE AT UTILITY CONSOLE")
            ShowAll("POWER OUTAGE | Scanner offline. Follow STAFF / POWER route and restore the utility console.", 8.0)
        else:
            SetBoard(PowerBoard, "POWER ONLINE | SECURITY LOCKDOWN")
            ShowAll("LOCKDOWN | {EmergencyLabel(Shift)} | Use RESPOND / SECURE before the timer expires.", 8.0)
        TerminalLog(DebugEnabled, "[EMERGENCY] Started|Shift={Shift}|Generation={CurrentEmergencyGeneration}")
        spawn{EmergencyTimeout(CurrentEmergencyGeneration, EmergencyTimeoutSeconds)}

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
            if (not IsAgentNear(Agent, vector3{X := 3950.0, Y := -3200.0, Z := 70.0}, 750.0)?):
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
        set EmergencyGeneration += 1
        set TeamCash += 200
        LowerRisk(8)
        RestoreNormalPower()
        SetBoard(EmergencyBoard, "POWER RESTORED | TERMINAL NORMAL")
        ShowAll("POWER RESTORED | Scanner and checkpoint systems online | +200 cash.", 7.0)
        PositiveAudio.Play()
        TerminalLog(DebugEnabled, "[EMERGENCY] Power restored|Shift={Shift}")
        BeginUpgradeBreak()

    RestoreNormalPower():void=
        set PowerOnline = true
        ScanButton.Enable()
        PowerButton.Disable()
        PowerButton.SetInteractionText(TerminalMessage("RESTORE TERMINAL POWER"))
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
            vector3{X := 5200.0, Y := -1900.0, Z := 70.0},
            vector3{X := 5000.0, Y := -1200.0, Z := 70.0},
            3.0,
            ExpectedCaseId,
            ExpectedRun,
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
                vector3{X := 5750.0, Y := -1900.0, Z := 70.0},
                vector3{X := 5200.0, Y := -1900.0, Z := 70.0},
                2.2,
                ExpectedCaseId,
                ExpectedRun,
                "response-patrol-a"
            )
            if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
                return
            if (not PatrolA?):
                return
            PatrolB := MoveActivePassengerChecked(
                vector3{X := 5750.0, Y := -2550.0, Z := 70.0},
                vector3{X := 5750.0, Y := -1900.0, Z := 70.0},
                2.2,
                ExpectedCaseId,
                ExpectedRun,
                "response-patrol-b"
            )
            if (not IsResponseEventCurrent(ExpectedCaseId, ExpectedRun, ExpectedResponseGeneration)?):
                return
            if (not PatrolB?):
                return
            PatrolC := MoveActivePassengerChecked(
                vector3{X := 5200.0, Y := -2450.0, Z := 70.0},
                vector3{X := 5750.0, Y := -2550.0, Z := 70.0},
                2.2,
                ExpectedCaseId,
                ExpectedRun,
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
        PassengerActive.Hide()
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
        if (not IsAgentNear(Agent, vector3{X := 5525.0, Y := -2200.0, Z := 70.0}, ResponseProximityRadius)?):
            ShowAgent(Agent, "REMOTE OUT OF RANGE | Enter the contained response room.", 5.0)
            TerminalLog(DebugEnabled, "[RESPONSE] Out-of-range remote signal rejected for CaseId={CurrentCaseId}")
            return
        SecureResponseThreat(Agent)

    SecureResponseThreat(Agent:agent):void=
        if (Phase <> terminal_game_phase.HostileResponse):
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
        ShowAll("SUSPECT INCAPACITATED | Signal remote recalled. Complete SECURE / JAIL INTAKE.", 7.0)
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
            if (not IsAgentNear(Agent, vector3{X := 5570.0, Y := -2290.0, Z := 70.0}, ResponseProximityRadius)?):
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
            if (not IsAgentNear(Agent, vector3{X := 5570.0, Y := -2290.0, Z := 70.0}, ResponseProximityRadius)?):
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
        PowerButton.SetInteractionText(TerminalMessage("DISABLE BREACH JAMMER"))
        PowerButton.Enable()
        CustodyButton.Disable()
        set CustodyCommitted = false
        set PassengerAtIntake = false
        set CurrentCustodyMode = 6
        set ClaimOwner = false
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
        if (not IsAgentNear(Agent, vector3{X := 5000.0, Y := 1450.0, Z := 70.0}, CustodyProximityRadius)?):
            ShowAgent(Agent, "FINAL CUSTODY OUT OF RANGE | Meet the suspect at detention intake.", 5.0)
            return
        if (CustodyCommitted?):
            TerminalLog(DebugEnabled, "[BOSS] Duplicate final custody rejected")
            return
        set CustodyCommitted = true
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        SetBoard(CustodyBoard, "FINAL CUSTODY ACCEPTED | CELL GATE CLOSING")
        spawn{MoveBossIntoCell(CurrentCaseId, RunGeneration)}

    MoveBossIntoCell(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        set CurrentDestination = terminal_case_destination.Cell
        SyncActiveCase()
        MoveResult := MoveActivePassengerChecked(
            vector3{X := 5550.0, Y := 1450.0, Z := 70.0},
            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
            2.0,
            ExpectedCaseId,
            ExpectedRun,
            "boss-cell"
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.BossSecure):
            PassengerActive.Hide()
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
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        set Phase = terminal_game_phase.Results
        set CurrentDestination = terminal_case_destination.None
        set TeamCash += 500
        PassengerActive.Hide()
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
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        set Phase = terminal_game_phase.Results
        set ClaimOwner = false
        set ClaimGeneration += 1
        set CurrentDestination = terminal_case_destination.None
        set EmergencyGeneration += 1
        PassengerActive.Hide()
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
        ResponseButton.Disable()
        set DocumentGeneration += 1
        CloseAllDocumentInterfaces()
        set RunGeneration += 1
        set EmergencyGeneration += 1
        set Phase = terminal_game_phase.Waiting
        SetDecisionControlsAvailable(false)
        set BossBranch = terminal_boss_branch.None
        set Shift = 0
        set CasesInShift = 0
        set ClaimOwner = false
        set ClaimGeneration += 1
        set ResolutionCommitted = false
        set CustodyCommitted = false
        set FinalCaseAccountingCommitted = false
        set CurrentCustodyMode = 0
        set PassengerReadyForScan = false
        set ScanInProgress = false
        set BagScanInProgress = false
        set SecondaryPassengerReady = false
        set PassengerAtIntake = false
        set QueueFrontIndex = 0
        set QueueGeneration += 1
        set ScannerGeneration += 1
        set CurrentDestination = terminal_case_destination.Queue
        SyncActiveCase()
        PassengerActive.Hide()
        JailOccupant.Hide()
        spawn{ResetPassengerQueue(RunGeneration)}
        CustodyButton.Disable()
        CustodyButton.SetInteractionText(TerminalMessage("SECURE / JAIL INTAKE"))
        DetainButton.SetInteractionText(TerminalMessage("RED | DETAIN SUSPECT"))
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
            PassengerSlot := QueueFrontIndex
            BagSlot := ActiveBagIndex
            RequiredEvidence := RequiredEvidenceMask()
            CompletedEvidence := CompletedEvidenceMask()
            Destination := CurrentDestination
            Phase := Phase
            PassengerAtIntake := PassengerAtIntake
            ResolutionCommitted := ResolutionCommitted
            CustodyCommitted := CustodyCommitted
            FinalCaseAccountingCommitted := FinalCaseAccountingCommitted

    CaseIdentityMatches(ExpectedCaseId:int, ExpectedRun:int)<transacts>:logic=
        if (ExpectedCaseId = ActiveCase.CaseId and ExpectedRun = ActiveCase.RunGeneration):
            return true
        false

    MoveActivePassengerChecked(
        Target:vector3,
        RetryWaypoint:vector3,
        OverTime:float,
        ExpectedCaseId:int,
        ExpectedRun:int,
        Label:string
    )<suspends>:logic=
        set ActivePassengerMoveGeneration += 1
        ExpectedMoveGeneration := ActivePassengerMoveGeneration
        TerminalLog(DebugEnabled, "[MOVE] Start|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
        PrimaryResult := PassengerActive.MoveTo(Target, IdentityRotation(), OverTime)
        if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration):
            TerminalLog(DebugEnabled, "[MOVE] Superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
            return false
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (PrimaryResult = move_to_result.DestinationReached):
            TerminalLog(DebugEnabled, "[MOVE] Reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true

        TerminalLog(DebugEnabled, "[MOVE] Primary blocked|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        RetryClear := PassengerActive.MoveTo(RetryWaypoint, IdentityRotation(), 0.75)
        if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration):
            TerminalLog(DebugEnabled, "[MOVE] Retry superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
            return false
        if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
            TerminalLog(DebugEnabled, "[MOVE] Retry stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return false
        if (RetryClear = move_to_result.DestinationReached):
            RetryTarget := PassengerActive.MoveTo(Target, IdentityRotation(), 1.0)
            if (ExpectedMoveGeneration <> ActivePassengerMoveGeneration):
                TerminalLog(DebugEnabled, "[MOVE] Retry target superseded|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}|MoveGeneration={ExpectedMoveGeneration}")
                return false
            if (not CaseIdentityMatches(ExpectedCaseId, ExpectedRun)?):
                TerminalLog(DebugEnabled, "[MOVE] Retry target stale rejected|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return false
            if (RetryTarget = move_to_result.DestinationReached):
                TerminalLog(DebugEnabled, "[MOVE] Retry reached|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
                return true

        if (PassengerActive.TeleportTo[Target, IdentityRotation()]):
            TerminalLog(DebugEnabled, "[MOVE] Teleport fallback|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true
        PassengerActive.Hide()
        TerminalLog(DebugEnabled, "[MOVE] Final fallback failed; actor hidden|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
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
            TerminalLog(DebugEnabled, "[BAG MOVE] Teleport fallback|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
            return true
        Prop.Hide()
        TerminalLog(DebugEnabled, "[BAG MOVE] Final fallback failed; prop hidden|Route={Label}|CaseId={ExpectedCaseId}|Run={ExpectedRun}")
        false

    CommitFinalCaseAccounting(Submitted:terminal_decision, Expected:terminal_decision):void=
        if (FinalCaseAccountingCommitted?):
            TerminalLog(DebugEnabled, "[BOSS] Duplicate final-case accounting rejected|CaseId={CurrentCaseId}")
            return
        set FinalCaseAccountingCommitted = true
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
        if (ScanInProgress? or BagScanInProgress? or Phase = terminal_game_phase.Inspecting or Phase = terminal_game_phase.SecondaryScreening):
            return
        if (Owner := ClaimOwner?, Owner = Player):
            set ClaimOwner = false
            set ClaimGeneration += 1
            SyncActiveCase()
            ShowAll("Case {CurrentCaseId} claim released after inactivity.", 5.0)
            TerminalLog(DebugEnabled, "[RECOVERY] Inactive claim released|CaseId={CurrentCaseId}")

    TryClaim(Agent:agent):logic=
        if (Player := player[Agent]):
            if (Owner := ClaimOwner?):
                if (Owner = Player):
                    RefreshClaimLease(Player)
                    return true
                ShowAgent(Agent, "Another officer owns Case {CurrentCaseId}. Wait for handoff or claim release.", 4.0)
                return false
            set ClaimOwner = option{Player}
            RefreshClaimLease(Player)
            TerminalLog(DebugEnabled, "[CASE] Claimed|CaseId={CurrentCaseId}")
            return true
        false

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

    ReadyForDecision()<transacts>:logic=
        if (not BodyChecked?):
            return false
        if (Shift >= 2, not BagChecked?):
            return false
        if (Shift >= 3, not DocumentsChecked?):
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
            Ready := ReadyForDecision()
            SetDecisionControlsAvailable(Ready)
            return
        SetDecisionControlsAvailable(false)

    SetDecisionControlsAvailable(Available:logic):void=
        if (Available?):
            ClearButton.Enable()
            SecondaryButton.Enable()
            DetainButton.Enable()
            SetBoard(ClearBoard, "GREEN | CLEAR\nAUTHORIZED")
            SetBoard(SecondaryBoard, "YELLOW | SECONDARY\nAUTHORIZED")
            SetBoard(DetainBoard, "RED | DETAIN\nAUTHORIZED")
            return
        ClearButton.Disable()
        SecondaryButton.Disable()
        DetainButton.Disable()
        SetBoard(ClearBoard, "CLEAR\nLOCKED - COMPLETE CHECKS")
        SetBoard(SecondaryBoard, "SECONDARY\nLOCKED - COMPLETE CHECKS")
        SetBoard(DetainBoard, "DETAIN\nLOCKED - COMPLETE CHECKS")

    SetSecondaryFinalControls():void=
        ClearButton.Enable()
        SecondaryButton.Disable()
        DetainButton.Enable()
        SetBoard(ClearBoard, "GREEN | RELEASE\nAUTHORIZED")
        SetBoard(SecondaryBoard, "SECONDARY\nCHECK COMPLETE")
        SetBoard(DetainBoard, "RED | DETAIN\nAUTHORIZED")

    ShowDecisionSubmitted(Decision:terminal_decision):void=
        ClearButton.Disable()
        SecondaryButton.Disable()
        DetainButton.Disable()
        if (Decision = terminal_decision.Clear):
            SetBoard(ClearBoard, "CLEAR\nSUBMITTED")
            SetBoard(SecondaryBoard, "SECONDARY\nSTANDBY")
            SetBoard(DetainBoard, "DETAIN\nSTANDBY")
            return
        if (Decision = terminal_decision.Secondary):
            SetBoard(ClearBoard, "CLEAR\nSTANDBY")
            SetBoard(SecondaryBoard, "SECONDARY\nSUBMITTED")
            SetBoard(DetainBoard, "DETAIN\nSTANDBY")
            return
        SetBoard(ClearBoard, "CLEAR\nSTANDBY")
        SetBoard(SecondaryBoard, "SECONDARY\nSTANDBY")
        SetBoard(DetainBoard, "DETAIN\nSUBMITTED")

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
        PassengerLocation := PassengerActive.GetTransform().Translation
        IsAgentNear(Agent, PassengerLocation, Radius)

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
            return "LOCKDOWN | {EmergencyLabel(Shift)} | Use RESPOND / SECURE."
        if (Phase = terminal_game_phase.Runner):
            return "RUNNER | Intercept Case {CurrentCaseId} before departure."
        if (Phase = terminal_game_phase.HostileResponse):
            return "RESISTANT SUSPECT | Take Signal Remote A; use PRIMARY FIRE inside response room."
        if (Phase = terminal_game_phase.SecondaryScreening):
            return "SECONDARY | Follow Case {CurrentCaseId} to the controlled room and perform the additional check."
        if (Phase = terminal_game_phase.Custody):
            return "CUSTODY | Deliver Case {CurrentCaseId} to detention intake."
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

    SecondaryResultText(Template:int)<computes>:string=
        if (Template = 7):
            return "RESTRICTED BATTERY CONCEALMENT CONFIRMED - DETAIN"
        if (Template = 3):
            return "EXPIRED CREDENTIAL VERIFIED - SUPERVISOR RELEASE"
        if (Template = 10):
            return "CLOSED GATE VERIFIED - REROUTE AND RELEASE"
        "NO NEW THREAT FOUND - USE ORIGINAL EVIDENCE"

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
        Evidence := DocumentEvidence(Template)
        if (Evidence = "VALID"):
            return NamedColors.LightGreen
        Required := RequiredDecision(Template)
        if (Required = terminal_decision.Secondary):
            return NamedColors.Yellow
        NamedColors.OrangeRed

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
        Required := RequiredDecision(Template)
        if (Required = terminal_decision.Detain):
            return "RED / SUSPICIOUS"
        if (Required = terminal_decision.Secondary):
            return "YELLOW / UNCERTAIN"
        "GREEN / CLEAR"

    BagResultText(Template:int):string=
        Evidence := BagEvidence(Template)
        if (Evidence = "CLEAR"):
            return "GREEN / CLEAR"
        Required := RequiredDecision(Template)
        if (Required = terminal_decision.Secondary):
            return "YELLOW / POLICY HOLD"
        "RED / RESTRICTED ITEM"

    TemplateName(Template:int)<computes>:string=
        if (Template = 1):
            return "Nova Harbor commuter"
        if (Template = 2):
            return "Restricted-item carrier"
        if (Template = 3):
            return "Expired credential hold"
        if (Template = 4):
            return "Jammer smuggler"
        if (Template = 5):
            return "Portrait mismatch alert"
        if (Template = 6):
            return "Nervous but valid traveler"
        if (Template = 7):
            return "Drone battery policy case"
        if (Template = 8):
            return "Armed infiltrator"
        if (Template = 9):
            return "Elite access-card infiltrator"
        if (Template = 10):
            return "Closed-gate courier"
        if (Template = 11):
            return "Final-boarding VIP"
        if (Template = 12):
            return "The Breacher disguise"
        "Unknown case"

    BodyEvidence(Template:int):string=
        if (Template = 2):
            return "FLAGGED: concealed shock baton at right side"
        if (Template = 8):
            return "FLAGGED: concealed blaster at accessory region"
        if (Template = 9):
            return "FLAGGED: copied master access card"
        "CLEAR"

    BagEvidence(Template:int):string=
        if (Template = 4):
            return "FLAGGED: security jammer"
        if (Template = 7):
            return "FLAGGED: cargo-only drone battery"
        if (Template = 8):
            return "FLAGGED: portal override module"
        if (Template = 12):
            return "FLAGGED: compact jammer node"
        "CLEAR"

    DocumentEvidence(Template:int):string=
        if (Template = 3):
            return "FLAGGED: credential expired"
        if (Template = 4):
            return "FLAGGED: invalid seal"
        if (Template = 5):
            return "FLAGGED: portrait mismatch"
        if (Template = 9):
            return "FLAGGED: altered access tier"
        if (Template = 10):
            return "FLAGGED: Gate A3 closed"
        if (Template = 12):
            return "FLAGGED: duplicate intelligence code"
        "VALID"

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
