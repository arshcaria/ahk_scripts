#Requires AutoHotkey v2.0

; Toggle Desktop Icons when double-clicking on desktop
~LButton::
{
    if (A_PriorHotkey != "~LButton" or A_TimeSincePriorHotkey > 400)
        return
    
    MouseGetPos ,, &hWnd
    if WinGetClass(hWnd) != "WorkerW" and WinGetClass(hWnd) != "Progman"
        return
        
    ; Toggle desktop icons using direct Windows API calls
    static ToggleDesktopIcons := true
    
    ; Find Progman window
    hProgman := WinExist("ahk_class Progman")
    if !hProgman
        return
    
    ; Send message to Progman to get WorkerW
    DllCall("SendMessageTimeout", "Ptr", hProgman, "UInt", 0x052C, "Ptr", 0, "Ptr", 0, "UInt", 0, "UInt", 1000, "Ptr", 0)
    
    ; Get desktop handle using FindWindowEx
    hDefView := 0
    
    ; First try with Progman
    hDefView := DllCall("FindWindowEx", "Ptr", hProgman, "Ptr", 0, "Str", "SHELLDLL_DefView", "Ptr", 0, "Ptr")
    
    ; If not found, try with WorkerW
    if !hDefView
    {
        hWorkerW := 0
        while ((hWorkerW := DllCall("FindWindowEx", "Ptr", 0, "Ptr", hWorkerW, "Str", "WorkerW", "Ptr", 0, "Ptr")) != 0)
        {
            if (hDefView := DllCall("FindWindowEx", "Ptr", hWorkerW, "Ptr", 0, "Str", "SHELLDLL_DefView", "Ptr", 0, "Ptr"))
                break
        }
    }
    
    if !hDefView
        return
    
    ; Get the ListView control (desktop icons)
    hSysListView := DllCall("FindWindowEx", "Ptr", hDefView, "Ptr", 0, "Str", "SysListView32", "Ptr", 0, "Ptr")
    
    if hSysListView
    {
        ; Toggle visibility
        DllCall("ShowWindow", "Ptr", hSysListView, "Int", ToggleDesktopIcons ? 0 : 5)
        ToggleDesktopIcons := !ToggleDesktopIcons
        
        ; Show a tooltip to indicate the current state
        ToolTip("Desktop icons " . (ToggleDesktopIcons ? "visible" : "hidden"))
        SetTimer () => ToolTip(), -1000  ; Hide tooltip after 1 second
    }
} 