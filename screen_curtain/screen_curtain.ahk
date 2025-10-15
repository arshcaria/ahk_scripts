#Requires AutoHotkey v2.0
#SingleInstance Force

; Screen Curtain - always-on-top draggable color rectangle to cover areas (e.g., system tray)

; -------- Config File --------
configFile := A_ScriptDir "\screen_curtain_config.ini"

; -------- Default Settings --------
defaultColor := "#202020"        ; hex (#RRGGBB) or named color (e.g., "Black")
defaultOpacity := 230             ; 0-255 (255 = fully opaque)
defaultWidth := 420
defaultHeight := 90
defaultX := A_ScreenWidth - defaultWidth - 20
defaultY := A_ScreenHeight - defaultHeight - 40

; -------- Globals --------
global curtainGui
global curtainHwnd
global currentOpacity := defaultOpacity
global currentColor := defaultColor

; -------- Load Settings --------
LoadSettings()

; -------- Create GUI --------
curtainGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
curtainGui.BackColor := NormalizeColor(currentColor)
curtainGui.MarginX := 0
curtainGui.MarginY := 0

curtainGui.Show(Format("x{} y{} w{} h{}", defaultX, defaultY, defaultWidth, defaultHeight))
curtainHwnd := curtainGui.Hwnd
WinSetTransparent(currentOpacity, "ahk_id " curtainHwnd)

; Save settings on exit
OnExit((*) => SaveSettings())

; Drag window from anywhere with left mouse button
OnMessage(0x201, OnDragLButtonDown)

; Right-click context menu
ctxMenu := Menu()
ctxMenu.Add("设置颜色...", (*) => SetColor())
ctxMenu.Add("拾色器", (*) => PickColor())
ctxMenu.Add("设置透明度...", (*) => SetOpacity())
ctxMenu.Add("设置大小...", (*) => SetSize())
ctxMenu.Add()
ctxMenu.Add("退出", (*) => ExitApp())
curtainGui.OnEvent("ContextMenu", ShowContextMenu)

SetColor() {
    global curtainGui, currentColor
    result := InputBox("输入颜色值（如 #202020 或 Red）", "设置颜色", "w320 h140", currentColor)
    if (result.Result != "OK") {
        return
    }
    color := Trim(result.Value)
    if (color = "") {
        return
    }
    currentColor := color
    if (SubStr(color, 1, 1) = "#" || SubStr(color, 1, 2) ~= "i)0x") {
        color := NormalizeColor(color)
    }
    try {
        curtainGui.BackColor := color
        WinRedraw("ahk_id " . curtainGui.Hwnd)
        SaveSettings()
    } catch {
        MsgBox("颜色无效: " . result.Value)
    }
}

PickColor() {
    global curtainGui, curtainHwnd, currentColor
    static pickActive := false
    static lastColor := ""

    if (pickActive) {
        ; Already picking, cancel
        pickActive := false
        SetTimer(UpdateColorPreview, 0)
        Hotkey("Enter", "Off")
        Hotkey("Esc", "Off")
        ToolTip()
        return
    }

    ; Start color picking mode
    pickActive := true
    lastColor := ""
    Notify("拾色模式：移动鼠标，按 Enter 确认，Esc 取消")

    ; Set up hotkeys for Enter and Esc
    Hotkey("Enter", ConfirmPick, "On")
    Hotkey("Esc", CancelPick, "On")

    ; Monitor mouse and show color preview
    SetTimer(UpdateColorPreview, 50)

    UpdateColorPreview() {
        if (!pickActive) {
            SetTimer(UpdateColorPreview, 0)
            return
        }

        MouseGetPos(&mx, &my)
        pixelColor := PixelGetColor(mx, my)

        ; Convert to hex format
        colorHex := Format("#{:06X}", pixelColor)

        if (colorHex != lastColor) {
            lastColor := colorHex
            ToolTip("颜色: " colorHex "`n按 Enter 确认，Esc 取消", mx + 20, my + 20)
        }
    }

    ConfirmPick(*) {
        if (!pickActive) {
            return
        }

        MouseGetPos(&mx, &my)
        pickedColor := PixelGetColor(mx, my)
        colorHex := Format("#{:06X}", pickedColor)

        currentColor := colorHex
        curtainGui.BackColor := NormalizeColor(colorHex)
        WinRedraw("ahk_id " curtainHwnd)
        SaveSettings()

        pickActive := false
        SetTimer(UpdateColorPreview, 0)
        Hotkey("Enter", "Off")
        Hotkey("Esc", "Off")
        ToolTip()
        Notify("已应用颜色: " colorHex)
    }

    CancelPick(*) {
        if (!pickActive) {
            return
        }

        pickActive := false
        SetTimer(UpdateColorPreview, 0)
        Hotkey("Enter", "Off")
        Hotkey("Esc", "Off")
        ToolTip()
        Notify("已取消拾色")
    }
}

SetOpacity() {
    global curtainHwnd, currentOpacity
    result := InputBox("输入透明度 0-255（255=不透明）", "设置透明度", "w320 h140", currentOpacity)
    if (result.Result != "OK") {
        return
    }
    value := Integer(Trim(result.Value))
    if (value < 0) {
        value := 0
    }
    if (value > 255) {
        value := 255
    }
    currentOpacity := value
    WinSetTransparent(currentOpacity, "ahk_id " curtainHwnd)
    SaveSettings()
}

SetSize() {
    global curtainGui, curtainHwnd, currentColor
    ; Get current size
    curtainGui.GetPos(&curX, &curY, &curW, &curH)

    result := InputBox("输入宽度和高度（用逗号或空格分隔，如 420,90 或 420 90）", "设置大小", "w360 h140", curW "," curH)
    if (result.Result != "OK") {
        return
    }

    ; Parse width and height
    input := Trim(result.Value)
    input := StrReplace(input, ",", " ")
    input := RegExReplace(input, "\s+", " ")
    parts := StrSplit(input, " ")

    if (parts.Length < 2) {
        MsgBox("格式错误！请输入宽度和高度，如: 420,90")
        return
    }

    newW := Integer(Trim(parts[1]))
    newH := Integer(Trim(parts[2]))

    if (newW < 10) {
        newW := 10
    }
    if (newH < 10) {
        newH := 10
    }

    curtainGui.Move(, , newW, newH)
    ; Force redraw to prevent visual artifacts
    curtainGui.BackColor := NormalizeColor(currentColor)
    WinRedraw("ahk_id " curtainHwnd)
    SaveSettings()
}

NormalizeColor(color) {
    c := Trim(color)
    if (SubStr(c, 1, 1) = "#") {
        hex := SubStr(c, 2)
        if (StrLen(hex) = 6) {
            return "0x" hex
        }
    }
    return c  ; already named color or 0xRRGGBB
}

Notify(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1200)
}

OnDragLButtonDown(wParam, lParam, msg, hwnd) {
    global curtainHwnd
    if (hwnd != curtainHwnd) {
        return
    }
    DllCall("ReleaseCapture")
    PostMessage(0xA1, 2, , , "ahk_id " curtainHwnd) ; HTCAPTION
}

ShowContextMenu(gui, ctrl, item, isRightClick, x, y) {
    global ctxMenu
    ctxMenu.Show(x, y)
}

LoadSettings() {
    global configFile, currentColor, currentOpacity, defaultX, defaultY, defaultWidth, defaultHeight

    if (!FileExist(configFile)) {
        return
    }

    try {
        currentColor := IniRead(configFile, "Settings", "Color", currentColor)
        currentOpacity := Integer(IniRead(configFile, "Settings", "Opacity", currentOpacity))
        defaultX := Integer(IniRead(configFile, "Settings", "X", defaultX))
        defaultY := Integer(IniRead(configFile, "Settings", "Y", defaultY))
        defaultWidth := Integer(IniRead(configFile, "Settings", "Width", defaultWidth))
        defaultHeight := Integer(IniRead(configFile, "Settings", "Height", defaultHeight))
    } catch {
        ; If any error reading config, use defaults
    }
}

SaveSettings() {
    global configFile, curtainGui, currentColor, currentOpacity

    ; Get current position and size
    curtainGui.GetPos(&x, &y, &w, &h)

    try {
        IniWrite(currentColor, configFile, "Settings", "Color")
        IniWrite(currentOpacity, configFile, "Settings", "Opacity")
        IniWrite(x, configFile, "Settings", "X")
        IniWrite(y, configFile, "Settings", "Y")
        IniWrite(w, configFile, "Settings", "Width")
        IniWrite(h, configFile, "Settings", "Height")
    } catch {
        ; Silently fail if can't write config
    }
}
