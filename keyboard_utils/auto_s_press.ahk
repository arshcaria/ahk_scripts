#Requires AutoHotkey v2.0

; --- Admin Rights Check ---
if not A_IsAdmin
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '"'
        else
            Run '*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"'
    }
    ExitApp
}
; --- End Admin Rights Check ---

; This script presses 's' every 2 seconds and '1' every 3 seconds.

PressS() {
    ; Use SendEvent with a key delay, which can be more reliable in emulators.
    SetKeyDelay(50, 50)
    SendEvent "s"
}

Press1() {
    SetKeyDelay(50, 50)
    SendEvent "1"
}

; SetTimer(PressS, 2000)
SetTimer(Press1, 1000)