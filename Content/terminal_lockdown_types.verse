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
    RequiredEvidence:int = 0
    CompletedEvidence:int = 0
    Destination:terminal_case_destination = terminal_case_destination.None
    Phase:terminal_game_phase = terminal_game_phase.Waiting
    PassengerAtIntake:logic = false
    ResolutionCommitted:logic = false
    CustodyCommitted:logic = false
    FinalCaseAccountingCommitted:logic = false

TerminalLog(DebugEnabled:logic, Text:string):void=
    if (DebugEnabled?):
        Print("[TL] {Text}")
