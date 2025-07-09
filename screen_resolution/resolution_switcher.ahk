#Requires AutoHotkey v2.0

;
; 使用说明:
; 1. 这是一个 AutoHotkey v2 脚本。
; 2. 按下快捷键可以在预设的分辨率列表之间循环切换。
; 3. 您可以编辑下方的快捷键和分辨率列表。
;

; ======================================================================
;                           自定义快捷键
; ======================================================================
; 符号说明:
; ^ : Ctrl
; ! : Alt
; + : Shift
; # : Win (Windows 徽标键)
;
; 下面的示例是 Ctrl+Alt+Shift+F12。
; 您可以修改为您想要的快捷键。
; ======================================================================

^+!F12::
{
    ; ==================================================================
    ;                         自定义分辨率列表
    ; ==================================================================
    ; 在下方添加您想要切换的分辨率。
    ; 格式为 ["宽x高", "宽x高", ...]
    ; ==================================================================
    static resolutions := [
        "5120x2160",
        "3840x2160"
        ; , "2560x1440" ; 您可以像这样添加更多分辨率
    ]

    ; --- 脚本核心逻辑，通常无需修改 ---

    ; 获取当前屏幕分辨率
    local currentRes := A_ScreenWidth . "x" . A_ScreenHeight
    local foundIndex := 0 ; 0 表示未找到

    ; 在列表中查找当前分辨率
    for index, res in resolutions
    {
        if (res = currentRes)
        {
            foundIndex := index
            break
        }
    }

    local targetIndex := 1
    ; 如果找到了，计算下一个分辨率的索引
    if (foundIndex != 0)
    {
        ; Mod 函数确保索引在 [0, length-1] 范围内, +1 后变为 [1, length], 实现循环
        targetIndex := Mod(foundIndex, resolutions.Length) + 1
    }
    ; 如果没找到，targetIndex 默认为 1，即列表中的第一个

    ; 获取目标分辨率字符串，例如 "5120x2160"
    local resolutionString := resolutions[targetIndex]

    ; 如果目标分辨率与当前分辨率相同（例如列表中只有一个分辨率），则无需操作
    if (resolutionString = currentRes) {
        ToolTip("当前已是目标分辨率: " . currentRes)
        SetTimer(() => ToolTip(), -2000)
        return
    }
    
    ; 将字符串分割为宽度和高度
    local parts := StrSplit(resolutionString, "x")
    local width := parts[1]
    local height := parts[2]

    ; 构建 setres 命令
    ; 格式: setres h[宽度] v[高度]
    local command := "setres h" . width . " v" . height

    ; 运行命令来改变分辨率
    ; 使用 "Hide" 选项来避免显示命令行窗口
    Run(command, , "Hide")

    ; (可选) 显示一个工具提示来确认切换
    ToolTip("分辨率已切换至: " . resolutionString)
    ; 2秒后自动清除工具提示
    SetTimer(() => ToolTip(), -2000)
} 