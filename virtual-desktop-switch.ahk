#Requires AutoHotkey v2.0

; 初始化 Windows COM 接口
VirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir "\VirtualDesktopAccessor.dll", "Ptr")

; 获取当前桌面编号的函数
GetCurrentDesktopNumber() {
    return DllCall("VirtualDesktopAccessor\GetCurrentDesktopNumber", "UInt")
}

; 获取总桌面数的函数
GetDesktopCount() {
    return DllCall("VirtualDesktopAccessor\GetDesktopCount", "UInt")
}

; 切换到指定桌面的函数
GoToDesktopNumber(num) {
    DllCall("VirtualDesktopAccessor\GoToDesktopNumber", "Int", num)
}

; 定义鼠标按键 - XButton1 (X1)
XButton1::
{
    current := GetCurrentDesktopNumber()
    total := GetDesktopCount()
    
    ; 切换到下一个桌面，如果是最后一个则回到第一个
    next := (current + 1) >= total ? 0 : current + 1
    GoToDesktopNumber(next)
    
    ; 添加短暂延迟以防止按键重复
    Sleep 200
    return
}


#HotIf  ; 结束特定条件的热键定义