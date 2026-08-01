using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

TerminalMessage<localizes>(Text:string):message = "{Text}"

terminal_game_phase := enum:
    Waiting
    Briefing
    CaseReady
    Inspecting
    AwaitingDecision
    SecondaryScreening
    Resolving
    Runner
    HostileResponse
    Custody
    Emergency
    UpgradeBreak
    BossJammer
    BossBreach
    BossVulnerable
    BossSecure
    Results

terminal_decision := enum:
    Clear
    Secondary
    Detain

terminal_boss_branch := enum:
    None
    Detected
    Missed

terminal_case_destination := enum:
    None
    Queue
    Scanner
    Baggage
    Documents
    Decision
    Secondary
    Departure
    Response
    Detention
    Cell

# Physical locations are independent from the high-level phase.  A station is
# never made available merely because a route was requested; movement code
# commits one of these values only after the intended actor is inside the
# destination tolerance.
terminal_passenger_location := enum:
    Hidden
    QueueFront
    Transit
    ScannerEntry
    ScannerCenter
    ScannerExit
    Baggage
    Documents
    Decision
    SecondaryPassenger
    SecurePad
    DetentionIntake
    Cell
    Departure
    Response

terminal_bag_location := enum:
    Hidden
    Queue
    ConveyorEntry
    XRayTunnel
    ConveyorExit
    SecondaryTable
    ClearedExit
    CustodyHold

terminal_claim_stage := enum:
    None
    Body
    Baggage
    Documents
    Secondary
    Decision
    Custody
    Response

terminal_detention_state := enum:
    None
    MarkedForDetention
    Handcuffed
    BeingEscorted
    EnteringJail
    Jailed

terminal_body_observation := enum:
    None
    NoAnomaly
    Head
    UpperTorso
    LowerTorso
    LeftArm
    RightArm
    LeftLeg
    RightLeg
    Uncertain

terminal_bag_observation := enum:
    None
    ClearImage
    UpperLeft
    UpperRight
    LowerLeft
    LowerRight
    CenterDense
    ManualSearch

terminal_document_observation := enum:
    None
    NoVisibleIssue
    Expired
    NameMismatch
    PortraitMismatch
    WrongFlight
    WrongGate
    RestrictedAccess
    SuspiciousSeal
    NeedsSecondary

# Immutable snapshot of the production case identity and all state that must
# travel together. The controller replaces this value whenever the active case
# changes, and movement callbacks use it to reject stale completions.
terminal_active_case := struct:
    CaseId:int = 0
    RunGeneration:int = 0
    Shift:int = 0
    Template:int = 0
    ClaimOwner:?player = false
    PassengerSlot:int = 0
    BagSlot:int = 0
    PassengerGeneration:int = 0
    MovementGeneration:int = 0
    RequiredEvidence:int = 0
    CompletedEvidence:int = 0
    Destination:terminal_case_destination = terminal_case_destination.None
    PassengerLocation:terminal_passenger_location = terminal_passenger_location.Hidden
    PassengerTarget:terminal_passenger_location = terminal_passenger_location.Hidden
    BagLocation:terminal_bag_location = terminal_bag_location.Hidden
    ClaimStage:terminal_claim_stage = terminal_claim_stage.None
    DetentionState:terminal_detention_state = terminal_detention_state.None
    BodyObservation:terminal_body_observation = terminal_body_observation.None
    BagObservation:terminal_bag_observation = terminal_bag_observation.None
    DocumentObservation:terminal_document_observation = terminal_document_observation.None
    ManualSearchRequested:logic = false
    Phase:terminal_game_phase = terminal_game_phase.Waiting
    PassengerAtIntake:logic = false
    ResolutionCommitted:logic = false
    CustodyCommitted:logic = false
    FinalCaseAccountingCommitted:logic = false

TerminalLog(DebugEnabled:logic, Text:string):void=
    if (DebugEnabled?):
        Print("[TL] {Text}")
