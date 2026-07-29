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

TerminalLog(DebugEnabled:logic, Text:string):void=
    if (DebugEnabled?):
        Print("[TL] {Text}")
