# Screen Curtain (屏幕幕布)

一个基于 AutoHotkey v2 的轻量级工具，用于创建可自定义的始终置顶遮挡区域，主要用于遮盖系统托盘或其他需要隐藏的屏幕区域。

## 目录

- [功能特性](#功能特性)
- [系统要求](#系统要求)
- [安装与使用](#安装与使用)
- [用户指南](#用户指南)
  - [基本操作](#基本操作)
  - [功能菜单](#功能菜单)
  - [配置文件](#配置文件)
- [开发文档](#开发文档)
  - [项目结构](#项目结构)
  - [代码架构](#代码架构)
  - [核心功能实现](#核心功能实现)
  - [自定义开发](#自定义开发)
- [常见问题](#常见问题)
- [更新日志](#更新日志)

---

## 功能特性

- ✅ **始终置顶**：遮挡窗口始终显示在最前端
- ✅ **自由拖动**：左键点击任意位置即可拖动窗口
- ✅ **自定义颜色**：支持十六进制颜色值和颜色名称
- ✅ **拾色器**：从屏幕任意位置实时拾取颜色
- ✅ **透明度调节**：0-255 级透明度自由设置
- ✅ **自定义尺寸**：任意调整遮挡区域的宽度和高度
- ✅ **配置持久化**：所有设置自动保存，下次启动自动恢复
- ✅ **无边框设计**：轻量简洁的界面
- ✅ **右键菜单**：所有功能通过右键菜单访问

---

## 系统要求

- **操作系统**：Windows 10 或更高版本
- **运行环境**：[AutoHotkey v2.0](https://www.autohotkey.com/) 或更高版本

---

## 安装与使用

### 1. 安装 AutoHotkey v2

如果尚未安装 AutoHotkey v2，请访问 [AutoHotkey 官网](https://www.autohotkey.com/) 下载并安装最新版本。

### 2. 运行脚本

双击 `screen_curtain.ahk` 文件即可运行。脚本会在屏幕右下角（靠近系统托盘区域）显示一个深灰色的遮挡窗口。

### 3. 首次运行

首次运行时，脚本会使用默认设置：
- **颜色**：`#202020`（深灰色）
- **透明度**：230（接近不透明）
- **尺寸**：420 × 90 像素
- **位置**：屏幕右下角

---

## 用户指南

### 基本操作

#### 拖动窗口
- **操作**：在遮挡窗口的任意位置按住鼠标左键并拖动
- **用途**：将遮挡区域移动到需要覆盖的位置（如系统托盘）

#### 打开菜单
- **操作**：在遮挡窗口上点击鼠标右键
- **用途**：访问所有功能选项

### 功能菜单

右键点击遮挡窗口，会显示以下功能菜单：

#### 1. 设置颜色...
手动输入颜色值来改变遮挡区域的颜色。

**支持的颜色格式**：
- **十六进制格式**：`#RRGGBB`（如 `#202020`、`#FF5733`）
- **0x 格式**：`0xRRGGBB`（如 `0x202020`）
- **颜色名称**：`Red`、`Blue`、`Black`、`White` 等

**示例**：
```
#202020    → 深灰色
#FFFFFF    → 白色
#000000    → 黑色
Red        → 红色
```

#### 2. 拾色器
从屏幕任意位置实时拾取颜色。

**使用步骤**：
1. 右键菜单选择"拾色器"
2. 移动鼠标到想要拾取颜色的位置
3. 工具提示会实时显示当前像素的颜色值（十六进制格式）
4. 按 **Enter** 键确认并应用该颜色
5. 按 **Esc** 键取消拾色

**提示**：拾色器可以从任何窗口、图片、网页等位置拾取颜色。

#### 3. 设置透明度...
调整遮挡区域的透明度。

**输入范围**：0 - 255
- **0**：完全透明（不可见）
- **128**：半透明
- **255**：完全不透明

**示例**：
```
230   → 接近不透明（推荐用于遮挡）
180   → 轻度透明
100   → 中度透明
```

#### 4. 设置大小...
自定义遮挡区域的宽度和高度。

**输入格式**：
- 用逗号分隔：`宽度,高度`（如 `420,90`）
- 用空格分隔：`宽度 高度`（如 `420 90`）

**最小尺寸**：10 × 10 像素

**示例**：
```
420,90     → 宽 420 像素，高 90 像素（默认尺寸）
800,50     → 宽 800 像素，高 50 像素（更宽）
300,150    → 宽 300 像素，高 150 像素（更高）
```

#### 5. 退出
关闭脚本并保存当前所有设置。

### 配置文件

脚本会自动在同目录下生成 `screen_curtain_config.ini` 配置文件。

**保存的设置包括**：
- 颜色值
- 透明度
- 窗口位置（X、Y 坐标）
- 窗口尺寸（宽度、高度）

**配置文件示例**：
```ini
[Settings]
Color=#202020
Opacity=230
X=1480
Y=990
Width=420
Height=90
```

**注意**：
- 每次修改颜色、透明度或大小时，配置会立即保存
- 退出脚本时，会自动保存当前窗口的位置和尺寸
- 下次启动脚本时，会自动加载上次保存的所有设置

---

## 开发文档

### 项目结构

```
screen_curtain/
├── screen_curtain.ahk           # 主脚本文件
├── screen_curtain_config.ini    # 配置文件（运行后自动生成）
└── README.md                     # 本文档
```

### 代码架构

#### 1. 脚本头部声明
```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force
```
- `#Requires AutoHotkey v2.0`：确保脚本只在 AHK v2 环境下运行
- `#SingleInstance Force`：防止脚本多次运行，新实例会自动替换旧实例

#### 2. 配置与全局变量

**配置文件路径**：
```ahk
configFile := A_ScriptDir "\screen_curtain_config.ini"
```

**默认设置**：
```ahk
defaultColor := "#202020"        ; 默认颜色
defaultOpacity := 230            ; 默认透明度
defaultWidth := 420              ; 默认宽度
defaultHeight := 90              ; 默认高度
defaultX := A_ScreenWidth - defaultWidth - 20    ; 默认 X 位置
defaultY := A_ScreenHeight - defaultHeight - 40  ; 默认 Y 位置
```

**全局变量**：
```ahk
global curtainGui          ; GUI 对象
global curtainHwnd         ; 窗口句柄
global currentOpacity      ; 当前透明度
global currentColor        ; 当前颜色
```

#### 3. GUI 创建与配置

**GUI 选项说明**：
```ahk
curtainGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
```
- `+AlwaysOnTop`：窗口始终置顶
- `-Caption`：无标题栏（无边框）
- `+ToolWindow`：工具窗口样式（不在任务栏显示）

**背景色与透明度**：
```ahk
curtainGui.BackColor := NormalizeColor(currentColor)
WinSetTransparent(currentOpacity, "ahk_id " curtainHwnd)
```

#### 4. 事件处理

**鼠标拖动**：
```ahk
OnMessage(0x201, OnDragLButtonDown)
```
- `0x201`：`WM_LBUTTONDOWN` 消息
- 捕获左键按下事件，实现窗口拖动

**右键菜单**：
```ahk
curtainGui.OnEvent("ContextMenu", ShowContextMenu)
```
- 捕获右键点击事件，显示上下文菜单

**退出时保存**：
```ahk
OnExit((*) => SaveSettings())
```
- 脚本退出时自动保存配置

### 核心功能实现

#### 1. 拖动功能（OnDragLButtonDown）

**原理**：
- 使用 `DllCall("ReleaseCapture")` 释放鼠标捕获
- 发送 `WM_NCLBUTTONDOWN` 消息（`0xA1`）模拟拖动标题栏
- `wParam = 2`（`HTCAPTION`）表示拖动标题栏区域

```ahk
OnDragLButtonDown(wParam, lParam, msg, hwnd) {
  global curtainHwnd
  if (hwnd != curtainHwnd) {
    return
  }
  DllCall("ReleaseCapture")
  PostMessage(0xA1, 2,,, "ahk_id " curtainHwnd)
}
```

#### 2. 颜色设置（SetColor）

**流程**：
1. 弹出输入框获取用户输入
2. 验证并格式化颜色值
3. 应用颜色到 GUI
4. 保存配置

**颜色格式化**：
```ahk
NormalizeColor(color) {
  c := Trim(color)
  if (SubStr(c, 1, 1) = "#") {
    hex := SubStr(c, 2)
    if (StrLen(hex) = 6) {
      return "0x" hex
    }
  }
  return c  ; 命名颜色或已是 0xRRGGBB 格式
}
```

#### 3. 拾色器（PickColor）

**实现机制**：
1. 使用 `SetTimer` 创建循环，每 50ms 更新一次
2. 使用 `PixelGetColor()` 获取鼠标位置的像素颜色
3. 实时显示颜色值在 ToolTip 中
4. 临时注册 Enter 和 Esc 热键
5. Enter 确认应用，Esc 取消

**关键代码**：
```ahk
MouseGetPos(&mx, &my)
pixelColor := PixelGetColor(mx, my)
colorHex := Format("#{:06X}", pixelColor)
```

**静态变量**：
```ahk
static pickActive := false
static lastColor := ""
```
- 使用 `static` 保持状态，避免全局污染

#### 4. 配置持久化

**保存配置（SaveSettings）**：
```ahk
SaveSettings() {
  global configFile, curtainGui, currentColor, currentOpacity
  curtainGui.GetPos(&x, &y, &w, &h)
  
  IniWrite(currentColor, configFile, "Settings", "Color")
  IniWrite(currentOpacity, configFile, "Settings", "Opacity")
  IniWrite(x, configFile, "Settings", "X")
  IniWrite(y, configFile, "Settings", "Y")
  IniWrite(w, configFile, "Settings", "Width")
  IniWrite(h, configFile, "Settings", "Height")
}
```

**加载配置（LoadSettings）**：
```ahk
LoadSettings() {
  global configFile, currentColor, currentOpacity, defaultX, defaultY, defaultWidth, defaultHeight
  
  if (!FileExist(configFile)) {
    return  ; 首次运行，使用默认值
  }
  
  try {
    currentColor := IniRead(configFile, "Settings", "Color", currentColor)
    currentOpacity := Integer(IniRead(configFile, "Settings", "Opacity", currentOpacity))
    defaultX := Integer(IniRead(configFile, "Settings", "X", defaultX))
    defaultY := Integer(IniRead(configFile, "Settings", "Y", defaultY))
    defaultWidth := Integer(IniRead(configFile, "Settings", "Width", defaultWidth))
    defaultHeight := Integer(IniRead(configFile, "Settings", "Height", defaultHeight))
  } catch {
    ; 配置读取失败，使用默认值
  }
}
```

### 自定义开发

#### 修改默认设置

编辑脚本顶部的默认设置：

```ahk
defaultColor := "#202020"        ; 修改默认颜色
defaultOpacity := 230            ; 修改默认透明度（0-255）
defaultWidth := 420              ; 修改默认宽度
defaultHeight := 90              ; 修改默认高度
```

#### 添加新功能到菜单

在菜单创建部分添加新项：

```ahk
ctxMenu := Menu()
ctxMenu.Add("设置颜色...", (*) => SetColor())
ctxMenu.Add("拾色器", (*) => PickColor())
ctxMenu.Add("设置透明度...", (*) => SetOpacity())
ctxMenu.Add("设置大小...", (*) => SetSize())
ctxMenu.Add("你的新功能", (*) => YourNewFunction())  ; 新增
ctxMenu.Add()
ctxMenu.Add("退出", (*) => ExitApp())
```

然后实现对应的函数：

```ahk
YourNewFunction() {
  ; 你的功能实现
}
```

#### 修改窗口样式

**添加边框**：
```ahk
curtainGui := Gui("+AlwaysOnTop +Border +ToolWindow")
```

**修改窗口样式**：
```ahk
; 普通窗口（显示在任务栏）
curtainGui := Gui("+AlwaysOnTop -Caption")

; 带标题栏的窗口
curtainGui := Gui("+AlwaysOnTop")
curtainGui.Title := "屏幕幕布"
```

#### 调整拾色器更新频率

修改 SetTimer 的间隔（单位：毫秒）：

```ahk
SetTimer(UpdateColorPreview, 50)  ; 50ms = 每秒 20 次
SetTimer(UpdateColorPreview, 100) ; 100ms = 每秒 10 次（更省资源）
```

#### 扩展配置项

在 `SaveSettings()` 和 `LoadSettings()` 中添加新的配置项：

```ahk
; 保存
IniWrite(yourValue, configFile, "Settings", "YourKey")

; 加载
yourValue := IniRead(configFile, "Settings", "YourKey", defaultValue)
```

---

## 常见问题

### Q1: 脚本运行后没有显示窗口？
**A**: 检查以下几点：
1. 确认已安装 AutoHotkey v2.0（不是 v1.1）
2. 窗口可能在屏幕边缘外，尝试删除 `screen_curtain_config.ini` 后重新运行
3. 检查透明度是否设置为 0（完全透明）

### Q2: 无法拖动窗口？
**A**: 确保：
1. 使用鼠标左键（不是右键）
2. 点击的是遮挡窗口本身，不是透过它点击了下层窗口
3. 透明度不要设置过低，否则难以点击

### Q3: 配置没有保存？
**A**: 
1. 确保脚本目录有写入权限
2. 正常退出脚本（右键菜单 → 退出），不要强制结束进程
3. 修改设置后会立即保存，无需等待退出

### Q4: 颜色显示不正确？
**A**: 
1. 使用标准的十六进制格式：`#RRGGBB`（如 `#FF0000` 表示红色）
2. 避免使用缩写格式（如 `#F00`）
3. 如果拾色器拾取的颜色不对，检查是否拾取了透明或半透明像素

### Q5: 如何完全卸载？
**A**: 
1. 右键菜单选择"退出"关闭脚本
2. 删除 `screen_curtain.ahk` 和 `screen_curtain_config.ini` 文件
3. 如需保留配置，只删除 `.ahk` 文件

### Q6: 脚本占用资源高吗？
**A**: 
- 正常运行时资源占用极低（< 5MB 内存）
- 拾色器模式会占用稍多资源（因为实时读取像素），使用完毕后会自动释放

### Q7: 可以同时运行多个遮挡窗口吗？
**A**: 
- 默认不支持（`#SingleInstance Force` 限制）
- 如需多个窗口，复制脚本文件并重命名，然后编辑脚本修改 `configFile` 的文件名以避免配置冲突

---

## 更新日志

### v1.0.0（当前版本）
- ✅ 初始版本发布
- ✅ 支持自定义颜色、透明度、尺寸
- ✅ 实现拾色器功能
- ✅ 配置持久化
- ✅ 右键菜单操作
- ✅ 自由拖动窗口

---

## 许可协议

本项目为个人开源项目，可自由使用、修改和分发。

---

## 技术支持

如有问题或建议，请通过以下方式联系：
- 提交 Issue（如果项目托管在 Git 平台）
- 直接修改代码并测试

---

**享受使用 Screen Curtain！** 🎉

