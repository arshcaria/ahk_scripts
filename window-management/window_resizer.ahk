#Requires AutoHotkey v2.0

; Configuration
; Modifier keys: ! = Alt, + = Shift, ^ = Ctrl, # = Win
modifier := "!+" ; Alt+Shift

; Resolution map: key is the hotkey number, value is [width, height]
resolutions := Map(
    "1", [2560, 1600],
    "2", [1920, 1200],
    "3", [1680, 1050],
    "4", [1440, 900],
    "5", [1280, 800]
)

; Create hotkeys dynamically
for key, dims in resolutions {
    hotkey modifier . key, ResizeWindow.Bind(dims*)
}

; Always-on-top toggle hotkey (Alt+Shift+T)
Hotkey modifier . "t", ToggleAlwaysOnTop

ResizeWindow(width, height, *) {
    ; Get the active window
    try {
        winX := 0, winY := 0, winW := 0, winH := 0  ; Initialize variables
        WinGetPos(&winX, &winY, &winW, &winH, "A")
        ; Resize the window while maintaining its position
        WinMove(winX, winY, width, height, "A")
    }
}

ToggleAlwaysOnTop(*) {
    ; Toggle the always-on-top state for the active window
    try {
        win := WinExist("A")
        if WinGetExStyle(win) & 0x8  ; 0x8 is WS_EX_TOPMOST
        {
            WinSetAlwaysOnTop 0, "A"  ; Remove always on top
            ToolTip "Always on Top: OFF"
        }
        else
        {
            WinSetAlwaysOnTop 1, "A"  ; Set always on top
            ToolTip "Always on Top: ON"
        }
        SetTimer () => ToolTip(), -1000  ; Hide tooltip after 1 second
    }
}

; Example of how to add a new resolution:
; resolutions["6"] := [3840, 2160]  ; 4K resolution
