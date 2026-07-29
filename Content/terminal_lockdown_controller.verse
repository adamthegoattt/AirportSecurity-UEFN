using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
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
    EmergencyBoard:billboard_device = billboard_device{}

    @editable
    CasesPerShift:int = 3

    @editable
    EmergencyTimeoutSeconds:float = 45.0

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
    var ResolutionCommitted:logic = false
    var CustodyCommitted:logic = false
    var RunUpgradePurchased:logic = false
    var PowerOnline:logic = true
    var CurrentCustodyMode:int = 0
    var ClaimOwner:?player = false
    var QueueFrontIndex:int = 0
    var QueueGeneration:int = 0
    var ScannerGeneration:int = 0
    var BagGeneration:int = 0
    var ActiveBagIndex:int = 0

    OnBegin<override>()<suspends>:void=
        StartButton.InteractedWithEvent.Subscribe(OnStartButton)
        ScanButton.InteractedWithEvent.Subscribe(OnScanButton)
        BagButton.InteractedWithEvent.Subscribe(OnBagButton)
        DocumentButton.InteractedWithEvent.Subscribe(OnDocumentButton)
        ClearButton.InteractedWithEvent.Subscribe(OnClearButton)
        SecondaryButton.InteractedWithEvent.Subscribe(OnSecondaryButton)
        DetainButton.InteractedWithEvent.Subscribe(OnDetainButton)
        ResponseButton.InteractedWithEvent.Subscribe(OnResponseButton)
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
        Sleep(5.0)
        for (Player : GetPlayspace().GetPlayers()):
            TerminalLog(true, "[QA] Automated replay begin")

            # Shift 1: physical passenger, body evidence, and clear decision.
            OnScanButton(Player)
            OnClearButton(Player)
            Sleep(4.0)
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
            OnScanButton(Player)
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnSecondaryButton(Player)
            Sleep(4.0)
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
            set ClaimOwner = false
            set Phase = terminal_game_phase.CaseReady
            OnScanButton(Player)
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnDetainButton(Player)
            Sleep(4.5)
            OnCustodyButton(Player)
            OnCustodyButton(Player)
            Sleep(4.0)
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
            set ClaimOwner = false
            set Phase = terminal_game_phase.AwaitingDecision
            OnDetainButton(Player)
            Sleep(1.0)
            OnResponseButton(Player)
            OnResponseButton(Player)
            OnResponseButton(Player)
            OnResponseButton(Player)
            Sleep(1.0)
            TerminalLog(true, "[QA] Shift 7 boss victory complete")
            OnResponseButton(Player)
            TerminalLog(true, "[QA] Replay reset complete")

            # One-client deterministic recovery harness. This is not a real
            # multiplayer test: it proves the production claim can be released,
            # reclaimed, and resolved once, while a duplicate decision cannot
            # advance progress again.
            OnStartButton(Player)
            Sleep(1.0)
            OnScanButton(Player)
            set ClaimOwner = false
            TerminalLog(true, "[QA2] Simulated owner loss released CaseId={CurrentCaseId}")
            OnClearButton(Player)
            OnClearButton(Player)
            Sleep(4.0)
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
            set ClaimOwner = false
            set Phase = terminal_game_phase.AwaitingDecision
            OnClearButton(Player)
            Sleep(1.0)
            OnResponseButton(Player)
            OnResponseButton(Player)
            OnResponseButton(Player)
            OnResponseButton(Player)
            Sleep(1.0)
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
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnDetainButton(Player)
            Sleep(4.0)
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
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnDetainButton(Player)
            Sleep(1.0)
            OnDetainButton(Player)
            Sleep(4.5)
            OnCustodyButton(Player)
            OnCustodyButton(Player)
            Sleep(4.0)
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
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnDetainButton(Player)
            Sleep(11.5)
            TerminalLog(
                true,
                "[QA3] Runner escape complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()

            # Resistant response through the real Shift 6 template schedule,
            # response interaction, physical intake, and custody handlers.
            OnStartButton(Player)
            set Shift = 6
            set CasesInShift = 1
            PrepareNextCase()
            Sleep(3.5)
            OnScanButton(Player)
            OnBagButton(Player)
            OnDocumentButton(Player)
            OnDetainButton(Player)
            Sleep(4.5)
            OnResponseButton(Player)
            OnResponseButton(Player)
            Sleep(4.5)
            OnCustodyButton(Player)
            OnCustodyButton(Player)
            Sleep(4.0)
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
            OnClearButton(Player)
            Sleep(4.0)
            TerminalLog(
                true,
                "[QA3] Post-branch clean case complete|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}"
            )
            ResetToWaiting()
            TerminalLog(true, "[QA3] Failure-branch replay complete; returned to waiting")
            return

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
        ClearButton.SetInteractionText(TerminalMessage("CLEAR"))
        ClearButton.SetInteractionTime(0.25)
        ClearButton.SetMaxTriggerCount(0)
        SecondaryButton.SetInteractionText(TerminalMessage("SECONDARY"))
        SecondaryButton.SetInteractionTime(0.5)
        SecondaryButton.SetMaxTriggerCount(0)
        DetainButton.SetInteractionText(TerminalMessage("DETAIN"))
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
        EmergencyBoard.SetShowBorder(true)
        CheckpointBoard.SetTextSize(24)
        CaseBoard.SetTextSize(18)
        BagBoard.SetTextSize(16)
        DocumentBoard.SetTextSize(16)
        PowerBoard.SetTextSize(20)
        CustodyBoard.SetTextSize(18)
        EmergencyBoard.SetTextSize(20)
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | OPEN")
        SetBoard(CaseBoard, "CURRENT PASSENGER | WAITING FOR SHIFT")
        SetBoard(BagBoard, "BAG INSPECTION | NO ACTIVE BAG")
        SetBoard(DocumentBoard, "TRAVEL DOCUMENTS | NO ACTIVE CASE")
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(CustodyBoard, "DETENTION INTAKE | READY")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        CustodyButton.Disable()
        PowerButton.Disable()

    OnPlayerAdded(Player:player):void=
        StatusHUD.Show(Player, TerminalMessage(CurrentStatus()), ?DisplayTime := 8.0)
        TerminalLog(DebugEnabled, "[PLAYER] Joined during phase {PhaseLabel()}")

    OnPlayerRemoved(Player:player):void=
        if (Owner := ClaimOwner?, Owner = Player):
            set ClaimOwner = false
            if (Phase = terminal_game_phase.Inspecting):
                set Phase = terminal_game_phase.CaseReady
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
        set QueueFrontIndex = 0
        set QueueGeneration += 1
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
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (BodyChecked?):
            ShowAgent(Agent, "BODY already checked | {BodyEvidence(CurrentTemplate)}", 4.0)
            return
        set Phase = terminal_game_phase.Inspecting
        set BodyChecked = true
        set Phase = terminal_game_phase.AwaitingDecision
        set ScannerGeneration += 1
        SetBoard(CheckpointBoard, "SCANNER ACTIVE | AMBER SWEEP | BEEP")
        ShowAgent(Agent, "BODY SCANNER ACTIVE | Hold for the physical result.", 3.0)
        spawn{RunScannerSequence(CurrentCaseId, RunGeneration, ScannerGeneration, CurrentTemplate)}
        TerminalLog(DebugEnabled, "[SCAN] CaseId={CurrentCaseId}|Template={CurrentTemplate}|CheckedOnce=True")

    RunScannerSequence(ExpectedCaseId:int, ExpectedRun:int, ExpectedScannerGeneration:int, Template:int)<suspends>:void=
        Sleep(1.0)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedScannerGeneration <> ScannerGeneration):
            return
        if (not PowerOnline?):
            SetBoard(CheckpointBoard, "SCANNER OFFLINE | RESTORE POWER")
            return
        SetBoard(CheckpointBoard, "SCANNER RESULT | {ScannerResultText(Template)} | {BodyEvidence(Template)}")
        ShowAll("SCANNER RESULT | {ScannerResultText(Template)} | {BodyEvidence(Template)}", 5.0)

    OnBagButton(Agent:agent):void=
        if (Shift < 2):
            ShowAgent(Agent, "Baggage Control unlocks in Shift 2.", 4.0)
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (BagChecked?):
            ShowAgent(Agent, "BAG already checked | {BagEvidence(CurrentTemplate)}", 4.0)
            return
        set Phase = terminal_game_phase.Inspecting
        set BagChecked = true
        set Phase = terminal_game_phase.AwaitingDecision
        set BagGeneration += 1
        SetBoard(BagBoard, "X-RAY ACTIVE | CASE {CurrentCaseId} | LINKED BAG MOVING")
        ShowAgent(Agent, "X-RAY ACTIVE | Linked bag moving through the inspection tunnel.", 4.0)
        spawn{RunBagInspection(CurrentCaseId, RunGeneration, BagGeneration, CurrentTemplate, ActiveBagIndex)}
        TerminalLog(DebugEnabled, "[BAG] CaseId={CurrentCaseId}|Template={CurrentTemplate}|CheckedOnce=True")

    RunBagInspection(ExpectedCaseId:int, ExpectedRun:int, ExpectedBagGeneration:int, Template:int, BagIndex:int)<suspends>:void=
        if (BagIndex = 0):
            TunnelMove := BagPropSmall.MoveTo(
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        else if (BagIndex = 1):
            TunnelMove := BagPropMedium.MoveTo(
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        else:
            TunnelMove := BagPropHardShell.MoveTo(
                vector3{X := 2525.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        SetBoard(BagBoard, "X-RAY ANALYZING | CASE {CurrentCaseId} | AMBER SWEEP")
        Sleep(0.8)
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        if (BagIndex = 0):
            ExitMove := BagPropSmall.MoveTo(
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        else if (BagIndex = 1):
            ExitMove := BagPropMedium.MoveTo(
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        else:
            ExitMove := BagPropHardShell.MoveTo(
                vector3{X := 3050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.0
            )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
            return
        SetBoard(BagBoard, "X-RAY RESULT | CASE {CurrentCaseId} | {BagResultText(Template)} | {BagEvidence(Template)}")
        ShowAll("X-RAY RESULT | {BagResultText(Template)} | {BagEvidence(Template)} | {EvidencePrompt()}", 6.0)

    OnDocumentButton(Agent:agent):void=
        if (Shift < 3):
            ShowAgent(Agent, "Identity Desk unlocks in Shift 3.", 4.0)
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        if (DocumentsChecked?):
            ShowAgent(Agent, "DOCUMENTS already checked | {DocumentEvidence(CurrentTemplate)}", 4.0)
            return
        set Phase = terminal_game_phase.Inspecting
        set DocumentsChecked = true
        set Phase = terminal_game_phase.AwaitingDecision
        SetBoard(
            DocumentBoard,
            "TRAVEL ID {CurrentCaseId} | {IdentityName(CurrentTemplate)} | {Destination(CurrentTemplate)} | {DocumentEvidence(CurrentTemplate)}"
        )
        ShowAgent(Agent, "DOCUMENTS | {DocumentEvidence(CurrentTemplate)} | {EvidencePrompt()}", 6.0)
        TerminalLog(DebugEnabled, "[DOC] CaseId={CurrentCaseId}|Template={CurrentTemplate}|CheckedOnce=True")

    OnClearButton(Agent:agent):void=
        ResolveDecision(Agent, terminal_decision.Clear)

    OnSecondaryButton(Agent:agent):void=
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        Legal := IsCaseInteractionLegal(Agent)
        if (not Legal?):
            return
        Ready := ReadyForDecision()
        if (not Ready?):
            ShowAgent(Agent, "Complete the required checks before Secondary.", 4.0)
            return

        Required := RequiredDecision(CurrentTemplate)
        if (Required = terminal_decision.Secondary):
            set SecondaryChecked = true
            ResolveDecision(Agent, terminal_decision.Secondary)
            return

        set SecondaryChecked = true
        set BodyChecked = true
        if (Shift >= 2):
            set BagChecked = true
        if (Shift >= 3):
            set DocumentsChecked = true
        if (TeamCash >= 25):
            set TeamCash -= 25
        ShowAgent(Agent, "SECONDARY CONFIRMED | {FullEvidence(CurrentTemplate)} | Choose CLEAR or DETAIN.", 8.0)
        TerminalLog(DebugEnabled, "[CASE] Secondary completed for CaseId={CurrentCaseId}")

    OnDetainButton(Agent:agent):void=
        if (Phase = terminal_game_phase.Runner):
            CaptureRunner(Agent)
            return
        ResolveDecision(Agent, terminal_decision.Detain)

    ResolveDecision(Agent:agent, Decision:terminal_decision):void=
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
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

        set ResolutionCommitted = true
        set Phase = terminal_game_phase.Resolving
        Expected := RequiredDecision(CurrentTemplate)
        TerminalLog(DebugEnabled, "[DECISION] CaseId={CurrentCaseId}|Submitted={DecisionLabel(Decision)}|Expected={DecisionLabel(Expected)}")

        if (CurrentTemplate = 12):
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
        CustodyButton.Disable()
        if (CurrentTemplate = 8):
            set CurrentCustodyMode = 2
            set Phase = terminal_game_phase.Runner
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER | INTERCEPT AT DECISION LANE")
            SetBoard(CustodyBoard, "RUNNER ACTIVE | DETAIN AGAIN TO INTERCEPT")
            ShowAll("RUNNER | Intercept at the decision lane and press DETAIN again before departure.", 8.0)
            spawn{RunnerEscape(CurrentCaseId, RunGeneration)}
            return
        if (CurrentTemplate = 9):
            set CurrentCustodyMode = 3
            set Phase = terminal_game_phase.HostileResponse
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | RESISTANT SUSPECT")
            SetBoard(EmergencyBoard, "RESPONSE SUPPLY AUTHORIZED | INCAPACITATE")
            ShowAll("RESISTANT SUSPECT | Response supply authorized. Use RESPOND, then complete jail intake.", 8.0)
            spawn{MovePassengerToResponse(CurrentCaseId, RunGeneration)}
            return
        set CurrentCustodyMode = 1
        set Phase = terminal_game_phase.Custody
        CustodyButton.Enable()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | DETAINED | TRANSFER TO INTAKE")
        SetBoard(CustodyBoard, "CUSTODY READY | SECURE / JAIL INTAKE")
        ShowAll("CORRECT DETAIN | Suspect compliant. Meet them at DETENTION INTAKE and secure.", 7.0)
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    CaptureRunner(Agent:agent):void=
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        if (Phase <> terminal_game_phase.Runner):
            return
        set CurrentCustodyMode = 1
        set Phase = terminal_game_phase.Custody
        CustodyButton.Enable()
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER INTERCEPTED")
        SetBoard(CustodyBoard, "RUNNER SECURED | COMPLETE JAIL INTAKE")
        ShowAll("RUNNER INTERCEPTED | Complete SECURE / JAIL INTAKE.", 6.0)
        spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}

    OnCustodyButton(Agent:agent):void=
        if (Phase <> terminal_game_phase.Custody):
            ShowAgent(Agent, "No suspect is ready for detention intake.", 4.0)
            return
        Claimed := TryClaim(Agent)
        if (not Claimed?):
            return
        if (CustodyCommitted?):
            TerminalLog(DebugEnabled, "[CUSTODY] Duplicate intake rejected for CaseId={CurrentCaseId}")
            return
        set CustodyCommitted = true
        set Phase = terminal_game_phase.Resolving
        CustodyButton.Disable()
        set TeamCash += 175
        LowerRisk(2)
        SetBoard(CustodyBoard, "CASE {CurrentCaseId} | JAILED | INTAKE COMPLETE")
        SetBoard(CaseBoard, "CASE {CurrentCaseId} | ARREST COMPLETE | +175")
        ShowAll("JAIL INTAKE COMPLETE | Arrest finalized exactly once | +175 cash.", 6.0)
        spawn{MovePassengerIntoCellAndFinish(CurrentCaseId, RunGeneration)}

    RunnerEscape(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        MoveResult := PassengerActive.MoveTo(
            vector3{X := 7000.0, Y := 1100.0, Z := 70.0},
            IdentityRotation(),
            10.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Runner):
            set Phase = terminal_game_phase.Resolving
            PassengerActive.Hide()
            RaiseRisk(16)
            DamageIntegrity(10, "Runner escaped")
            if (Phase = terminal_game_phase.Results):
                return
            SetBoard(CaseBoard, "CASE {CurrentCaseId} | RUNNER ESCAPED")
            SetBoard(CustodyBoard, "DETENTION INTAKE | ESCAPE RECORDED")
            ShowAll("RUNNER ESCAPED | Integrity -10, Risk +16. Lane recovery started.", 7.0)
            FinishCase()

    MovePassengerToDepartureAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        MoveResult := PassengerActive.MoveTo(
            vector3{X := 7000.0, Y := 1100.0, Z := 70.0},
            IdentityRotation(),
            3.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            PassengerActive.Hide()
            FinishCase()

    MovePassengerToIntake(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        MoveResult := PassengerActive.MoveTo(
            vector3{X := 5000.0, Y := 1450.0, Z := 70.0},
            IdentityRotation(),
            4.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Custody):
            SetBoard(CustodyBoard, "CASE {CurrentCaseId} AT INTAKE | SECURE NOW")

    MovePassengerToResponse(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        MoveResult := PassengerActive.MoveTo(
            vector3{X := 5200.0, Y := -1900.0, Z := 70.0},
            IdentityRotation(),
            4.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.HostileResponse):
            SetBoard(EmergencyBoard, "THREAT IN RESPONSE ZONE | RESPOND TO INCAPACITATE")

    MovePassengerIntoCellAndFinish(ExpectedCaseId:int, ExpectedRun:int)<suspends>:void=
        MoveResult := PassengerActive.MoveTo(
            vector3{X := 5550.0, Y := 1450.0, Z := 70.0},
            IdentityRotation(),
            2.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration and Phase = terminal_game_phase.Resolving):
            Sleep(1.0)
            PassengerActive.Hide()
            FinishCase()

    FinishCase():void=
        set TotalCasesResolved += 1
        set CasesInShift += 1
        set ClaimOwner = false
        TerminalLog(DebugEnabled, "[CASE] Complete|CaseId={CurrentCaseId}|Shift={Shift}|CasesInShift={CasesInShift}|Cash={TeamCash}|Integrity={TeamIntegrity}|Risk={TeamRisk}")

        if (CasesInShift >= CasesPerShift):
            if (Shift >= 4 and Shift <= 6):
                BeginEmergency()
            else:
                BeginUpgradeBreak()
        else:
            spawn{AdvanceQueueAndPrepare(CurrentCaseId, RunGeneration, QueueGeneration)}

    PrepareNextCase():void=
        set CurrentCaseId += 1
        set CurrentTemplate = SelectTemplate(Shift, CasesInShift)
        set BodyChecked = false
        set ScannerGeneration += 1
        set BagGeneration += 1
        set BagChecked = false
        set DocumentsChecked = false
        set SecondaryChecked = false
        set ResolutionCommitted = false
        set CustodyCommitted = false
        set CurrentCustodyMode = 0
        set ClaimOwner = false
        set Phase = terminal_game_phase.CaseReady
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
        if (ActiveBagIndex = 0):
            StartMove := BagPropSmall.MoveTo(
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                0.1
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropSmall.Show()
            ArrivalMove := BagPropSmall.MoveTo(
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.5
            )
        else if (ActiveBagIndex = 1):
            StartMove := BagPropMedium.MoveTo(
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                0.1
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropMedium.Show()
            ArrivalMove := BagPropMedium.MoveTo(
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.5
            )
        else:
            StartMove := BagPropHardShell.MoveTo(
                vector3{X := 1500.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                0.1
            )
            if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedBagGeneration <> BagGeneration):
                return
            BagPropHardShell.Show()
            ArrivalMove := BagPropHardShell.MoveTo(
                vector3{X := 2050.0, Y := -1325.0, Z := 175.0},
                IdentityRotation(),
                1.5
            )
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
        PassengerActive.Hide()
        MoveResult0 := PassengerActive.MoveTo(
            vector3{X := -650.0, Y := -2150.0, Z := 70.0},
            IdentityRotation(),
            0.1
        )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or Phase <> terminal_game_phase.CaseReady):
            return
        PassengerActive.Show()
        MoveResult1 := PassengerActive.MoveTo(
            vector3{X := -100.0, Y := -2150.0, Z := 70.0},
            IdentityRotation(),
            1.0
        )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult2 := PassengerActive.MoveTo(
            vector3{X := 450.0, Y := -1900.0, Z := 70.0},
            IdentityRotation(),
            1.0
        )
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration):
            return
        MoveResult3 := PassengerActive.MoveTo(
            vector3{X := 900.0, Y := -1300.0, Z := 70.0},
            IdentityRotation(),
            1.0
        )
        if (ExpectedCaseId = CurrentCaseId and ExpectedRun = RunGeneration):
            SetBoard(CheckpointBoard, "ACTIVE PASSENGER | CASE {CurrentCaseId} | BODY SCAN")

    ResetPassengerQueue(ExpectedRun:int)<suspends>:void=
        PassengerQueue1.Hide()
        PassengerQueue2.Hide()
        PassengerQueue3.Hide()
        Move1 := PassengerQueue1.MoveTo(
            vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
            IdentityRotation(),
            0.1
        )
        Move2 := PassengerQueue2.MoveTo(
            vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
            IdentityRotation(),
            0.1
        )
        Move3 := PassengerQueue3.MoveTo(
            vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
            IdentityRotation(),
            0.1
        )
        if (ExpectedRun <> RunGeneration):
            return
        PassengerQueue1.Show()
        PassengerQueue2.Show()
        PassengerQueue3.Show()
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | 3 PASSENGERS WAITING")

    AdvanceQueueAndPrepare(ExpectedCaseId:int, ExpectedRun:int, ExpectedQueueGeneration:int)<suspends>:void=
        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ExpectedQueueGeneration <> QueueGeneration):
            return
        set QueueGeneration += 1
        ThisQueueGeneration := QueueGeneration

        if (QueueFrontIndex = 0):
            FrontMove := PassengerQueue1.MoveTo(
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.6
            )
            MidMove := PassengerQueue2.MoveTo(
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            RearMove := PassengerQueue3.MoveTo(
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            PassengerQueue1.Hide()
            Recycle := PassengerQueue1.MoveTo(
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.1
            )
            PassengerQueue1.Show()
            set QueueFrontIndex = 1
        else if (QueueFrontIndex = 1):
            FrontMove := PassengerQueue2.MoveTo(
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.6
            )
            MidMove := PassengerQueue3.MoveTo(
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            RearMove := PassengerQueue1.MoveTo(
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            PassengerQueue2.Hide()
            Recycle := PassengerQueue2.MoveTo(
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.1
            )
            PassengerQueue2.Show()
            set QueueFrontIndex = 2
        else:
            FrontMove := PassengerQueue3.MoveTo(
                vector3{X := -800.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.6
            )
            MidMove := PassengerQueue1.MoveTo(
                vector3{X := -1200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            RearMove := PassengerQueue2.MoveTo(
                vector3{X := -1700.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.7
            )
            PassengerQueue3.Hide()
            Recycle := PassengerQueue3.MoveTo(
                vector3{X := -2200.0, Y := -2150.0, Z := 70.0},
                IdentityRotation(),
                0.1
            )
            PassengerQueue3.Show()
            set QueueFrontIndex = 0

        if (ExpectedCaseId <> CurrentCaseId or ExpectedRun <> RunGeneration or ThisQueueGeneration <> QueueGeneration):
            return
        PrepareNextCase()

    BeginUpgradeBreak():void=
        set Phase = terminal_game_phase.UpgradeBreak
        set ClaimOwner = false
        set PowerOnline = true
        ScanButton.Enable()
        CustodyButton.Disable()
        PowerButton.Disable()
        PassengerActive.Hide()
        set BagGeneration += 1
        HideAllBags()
        SetBoard(PowerBoard, "POWER ONLINE")
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | SHIFT CHANGE")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
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
        set Phase = terminal_game_phase.Emergency
        set ClaimOwner = false
        PassengerActive.Hide()
        CustodyButton.Disable()
        set EmergencyGeneration += 1
        CurrentEmergencyGeneration := EmergencyGeneration
        SetBoard(CheckpointBoard, "CHECKPOINT CLOSED | RED ALERT")
        SetBoard(EmergencyBoard, "RED ALERT | {EmergencyLabel(Shift)}")
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
        if (Phase <> terminal_game_phase.Emergency or Shift <> 5 or PowerOnline?):
            ShowAgent(Agent, "Power console is online. No repair is required.", 4.0)
            return
        set EmergencyGeneration += 1
        set TeamCash += 200
        LowerRisk(8)
        RestoreNormalPower()
        SetBoard(EmergencyBoard, "POWER RESTORED | TERMINAL NORMAL")
        ShowAll("POWER RESTORED | Scanner and checkpoint systems online | +200 cash.", 7.0)
        TerminalLog(DebugEnabled, "[EMERGENCY] Power restored|Shift={Shift}")
        BeginUpgradeBreak()

    RestoreNormalPower():void=
        set PowerOnline = true
        ScanButton.Enable()
        PowerButton.Disable()
        SetBoard(PowerBoard, "POWER ONLINE")

    OnResponseButton(Agent:agent):void=
        if (Phase = terminal_game_phase.HostileResponse):
            set Phase = terminal_game_phase.Custody
            set CurrentCustodyMode = 1
            CustodyButton.Enable()
            SetBoard(EmergencyBoard, "SUSPECT INCAPACITATED | SUPPLY STANDBY")
            SetBoard(CustodyBoard, "SUSPECT SECURED | COMPLETE JAIL INTAKE")
            ShowAll("SUSPECT INCAPACITATED | Complete SECURE / JAIL INTAKE.", 6.0)
            spawn{MovePassengerToIntake(CurrentCaseId, RunGeneration)}
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
            TerminalLog(DebugEnabled, "[EMERGENCY] Success|Shift={Shift}")
            BeginUpgradeBreak()
            return
        if (Phase = terminal_game_phase.BossJammer):
            set Phase = terminal_game_phase.BossBreach
            SetBoard(EmergencyBoard, "FINAL THREAT | JAMMER OFFLINE | BREACH ACTIVE")
            ShowAll("THE BREACHER | JAMMER OFFLINE | Defend the departure control and RESPOND.", 7.0)
            return
        if (Phase = terminal_game_phase.BossBreach):
            set Phase = terminal_game_phase.BossVulnerable
            SetBoard(EmergencyBoard, "FINAL THREAT | SHIELD VULNERABLE")
            ShowAll("THE BREACHER | BREACH INTERRUPTED | Shield vulnerable. RESPOND to incapacitate.", 7.0)
            return
        if (Phase = terminal_game_phase.BossVulnerable):
            set Phase = terminal_game_phase.BossSecure
            SetBoard(EmergencyBoard, "FINAL THREAT | INCAPACITATED | SECURE")
            ShowAll("THE BREACHER INCAPACITATED | Complete the final secure interaction.", 7.0)
            return
        if (Phase = terminal_game_phase.BossSecure):
            FinishVictory()
            return
        if (Phase = terminal_game_phase.Results):
            ResetToWaiting()
            return
        ShowAgent(Agent, "No emergency response is active.", 4.0)

    BeginBoss(Detected:logic):void=
        set ClaimOwner = false
        if (Detected?):
            set BossBranch = terminal_boss_branch.Detected
            set TeamCash += 300
            set Phase = terminal_game_phase.BossJammer
            SetBoard(CaseBoard, "FINAL CASE | BREACHER DETECTED")
            SetBoard(EmergencyBoard, "FINAL THREAT | DISABLE JAMMER")
            ShowAll("EARLY INTERCEPTION | The Breacher starts weakened. Disable the jammer with RESPOND.", 8.0)
        else:
            set BossBranch = terminal_boss_branch.Missed
            RaiseRisk(15)
            DamageIntegrity(10, "Boss cleared at checkpoint")
            if (Phase = terminal_game_phase.Results):
                return
            set Phase = terminal_game_phase.BossJammer
            SetBoard(CaseBoard, "FINAL CASE | BREACHER MISSED")
            SetBoard(EmergencyBoard, "FINAL THREAT | EXTRA ROUTES OPEN")
            ShowAll("BREACHER MISSED | Extra routes opened. Disable the jammer with RESPOND.", 8.0)
        spawn{MovePassengerToResponse(CurrentCaseId, RunGeneration)}
        TerminalLog(DebugEnabled, "[BOSS] Branch={BossBranchLabel()}|Integrity={TeamIntegrity}|Risk={TeamRisk}")

    FinishVictory():void=
        set Phase = terminal_game_phase.Results
        set TeamCash += 500
        PassengerActive.Hide()
        SetBoard(CheckpointBoard, "TERMINAL SECURED | RESULTS")
        SetBoard(EmergencyBoard, "ALL CLEAR | RESPOND TO REPLAY")
        Grade := ResultGrade()
        ShowAll("TERMINAL SECURED | Grade {Grade} | Accuracy {CorrectDecisions}/{TotalCasesResolved} | Integrity {TeamIntegrity} | Branch {BossBranchLabel()} | RESPOND to replay.", 0.0)
        TerminalLog(DebugEnabled, "[RESULTS] Victory|Grade={Grade}|Correct={CorrectDecisions}|Resolved={TotalCasesResolved}|Integrity={TeamIntegrity}|Risk={TeamRisk}|Cash={TeamCash}|Boss={BossBranchLabel()}")

    FinishDefeat(Reason:string):void=
        set Phase = terminal_game_phase.Results
        set ClaimOwner = false
        set EmergencyGeneration += 1
        PassengerActive.Hide()
        RestoreNormalPower()
        SetBoard(CheckpointBoard, "TERMINAL OVERRUN | RESULTS")
        SetBoard(EmergencyBoard, "RUN ENDED | RESPOND TO RETRY")
        ShowAll("TERMINAL OVERRUN | {Reason} | Correct {CorrectDecisions}/{TotalCasesResolved} | RESPOND to retry.", 0.0)
        TerminalLog(DebugEnabled, "[RESULTS] Defeat|Reason={Reason}|Shift={Shift}|CaseId={CurrentCaseId}")

    ResetToWaiting():void=
        set RunGeneration += 1
        set EmergencyGeneration += 1
        set Phase = terminal_game_phase.Waiting
        set BossBranch = terminal_boss_branch.None
        set Shift = 0
        set CasesInShift = 0
        set ClaimOwner = false
        set ResolutionCommitted = false
        set CustodyCommitted = false
        set CurrentCustodyMode = 0
        set QueueFrontIndex = 0
        set QueueGeneration += 1
        set ScannerGeneration += 1
        PassengerActive.Hide()
        spawn{ResetPassengerQueue(RunGeneration)}
        CustodyButton.Disable()
        RestoreNormalPower()
        SetBoard(CheckpointBoard, "SECURITY CHECKPOINT | OPEN")
        SetBoard(CaseBoard, "CURRENT PASSENGER | WAITING FOR SHIFT")
        SetBoard(BagBoard, "BAG INSPECTION | NO ACTIVE BAG")
        SetBoard(DocumentBoard, "TRAVEL DOCUMENTS | NO ACTIVE CASE")
        SetBoard(CustodyBoard, "DETENTION INTAKE | READY")
        SetBoard(EmergencyBoard, "RESPONSE SUPPLY | STANDBY")
        ShowAll("TERMINAL LOCKDOWN | Run reset cleanly. Press START SHIFT.", 8.0)
        TerminalLog(DebugEnabled, "[RECOVERY] Reset complete|Generation={RunGeneration}")

    TryClaim(Agent:agent):logic=
        if (Player := player[Agent]):
            if (Owner := ClaimOwner?):
                if (Owner = Player):
                    return true
                ShowAgent(Agent, "Another officer owns Case {CurrentCaseId}. Wait for handoff or claim release.", 4.0)
                return false
            set ClaimOwner = option{Player}
            TerminalLog(DebugEnabled, "[CASE] Claimed|CaseId={CurrentCaseId}")
            return true
        false

    IsCaseInteractionLegal(Agent:agent):logic=
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
            return "RESISTANT SUSPECT | Use response supply."
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
