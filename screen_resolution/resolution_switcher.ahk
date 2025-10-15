#Requires AutoHotkey v2.0

; 定义快捷键: Ctrl+Alt+Shift+F12
^!+F12::
{
    ; 分辨率列表: 每个分辨率是一个对象 {width: "宽度", height: "高度", bits: "色深(可选)", freq: "刷新率(可选)"}
    resolutions := [
        { width: "5120", height: "2160" }, 
        { width: "3840", height: "2160" },
    ]

    ; 获取当前分辨率
    currentWidth := A_ScreenWidth
    currentHeight := A_ScreenHeight

    ; 查找当前分辨率在列表中的索引 (只基于宽度和高度)
    foundIndex := -1
    loop resolutions.Length {
        res := resolutions[A_Index]
        if (res.width == currentWidth && res.height == currentHeight) {
            foundIndex := A_Index
            break
        }
    }

    ; 确定下一个分辨率索引
    if (foundIndex != -1) {
        nextIndex := Mod(foundIndex, resolutions.Length) + 1
    }
    else {
        nextIndex := 1
    }

    ; 获取下一个分辨率
    nextRes := resolutions[nextIndex]
    nextWidth := nextRes.width
    nextHeight := nextRes.height

    ; 构建 setres 命令
    cmd := 'setres h' . nextWidth . ' v' . nextHeight
    if (nextRes.HasOwnProp("bits"))
        cmd .= ' b' . nextRes.bits
    if (nextRes.HasOwnProp("freq"))
        cmd .= ' f' . nextRes.freq

    ; 执行 setres 命令
    Run(cmd)
}
