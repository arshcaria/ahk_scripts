#Requires AutoHotkey v2.0

; Toggle Desktop Icons when double-clicking on desktop
~LButton::
{
    if (A_PriorHotkey != "~LButton" or A_TimeSincePriorHotkey > 350)
        return
    
    MouseGetPos ,, &hWnd
    if WinGetClass(hWnd) != "WorkerW" and WinGetClass(hWnd) != "Progman"
        return
        
    ; Toggle desktop icons
    static ToggleDesktopIcons := true
    
    ; Try multiple approaches to find the desktop icons
    desktopHwnd := 0
    
    ; Approach 1: Try SysListView32 in WorkerW
    if WinExist("ahk_class WorkerW")
        desktopHwnd := ControlGetHwnd("SysListView321", "ahk_class WorkerW")
    
    ; Approach 2: Try SysListView32 in Progman
    if !desktopHwnd && WinExist("ahk_class Progman")
        desktopHwnd := ControlGetHwnd("SysListView321", "ahk_class Progman")
    
    ; Approach 3: Try finding desktop directly
    if !desktopHwnd {
        hwndDesktop := DllCall("GetDesktopWindow", "Ptr")
        if hwndDesktop {
            ; Try to find shell view
            IID_IShellView := "{000214E3-0000-0000-C000-000000000046}"
            ; Alternative approach with direct window handle
            desktopHwnd := DllCall("FindWindowEx", "Ptr", hwndDesktop, "Ptr", 0, "Str", "SysListView32", "Ptr", 0, "Ptr")
        }
    }
    
    ; If we found a handle, toggle visibility
    if desktopHwnd {
        DllCall("ShowWindow", "Ptr", desktopHwnd, "Int", ToggleDesktopIcons ? 0 : 5)
        ToggleDesktopIcons := !ToggleDesktopIcons
        
        ; Show a tooltip to indicate the current state
        ; ToolTip("Desktop icons " . (ToggleDesktopIcons ? "visible" : "hidden"))
        ;SetTimer () => ToolTip(), -1000  ; Hide tooltip after 1 second
    } else {
        ; If we couldn't find the desktop icons, show an error
        ToolTip("Could not find desktop icons control")
        SetTimer () => ToolTip(), -2000
    }
}

