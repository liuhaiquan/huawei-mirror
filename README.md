# 华为镜像

在 Mac 上一键投屏并操作华为 / 鸿蒙手机。连上手机后打开应用，即可在电脑窗口里点按、滑动、打字。

本项目是对 [scrcpy](https://github.com/Genymobile/scrcpy) 的 macOS 封装，**与华为官方无关**，不是华为官方镜像功能。

---

## 一键安装（macOS）

要求：macOS 13 或更高。Apple Silicon 和 Intel 都可以。

别人只需在终端执行一行：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/liuhaiquan/huawei-mirror/main/install.sh)"
```

安装脚本会：

1. 没有 Homebrew 时先安装 Homebrew
2. 安装 `scrcpy` 和 `adb`
3. 把 **华为镜像.app** 放到 `~/Applications` 和桌面

在已经克隆下来的仓库里，也可以直接：

```bash
chmod +x install.sh
./install.sh
```

装好后按提示选择现在启动，或之后自己打开。

---

## 一键启动

任选一种：

- 双击桌面上的 **华为镜像**
- 把图标拖进 Dock，以后一点即可
- 终端：

```bash
open ~/Applications/华为镜像.app
```

第一次若提示「无法打开，因为无法验证开发者」：按住 **Control** 点击图标 → **打开**。

打开后选择 **有线连接** 或 **无线连接**。有线更稳；无线需手机和 Mac 在同一 Wi‑Fi，第一次建议先插数据线开通后再拔线。

---

## 手机只需设置一次

在华为手机上：

1. **设置 → 关于手机**，连续点击 **版本号**，打开开发人员选项
2. **设置 → 系统和更新 → 开发人员选项**，打开：
   - **USB 调试**
   - **仅充电模式下允许 ADB 调试**（息屏后 USB 不断开）
   - **USB 调试（安全设置）**（锁屏时允许电脑点击；没有这一项可跳过）
3. 按提示重启一次手机更稳

之后日常：用数据线连上（USB 选 **传输文件** 或 **传输照片**），打开 **华为镜像**。手机弹出 USB 调试授权时点 **允许**，可勾选始终允许。

---

## 日常使用

| 场景 | 说明 |
| --- | --- |
| 已解锁 | 应用会尽量关掉手机屏幕，只在 Mac 窗口操作 |
| 已锁屏 | 窗口里先解锁；解锁后按 **Option + O** 可关掉手机屏幕 |
| 中文输入 | 先点进手机输入框，再用弹出的「发到手机」窗口输入，回车发送 |
| 结束 | 关掉投屏窗口即可 |

常用快捷键（投屏窗口激活时）：

- **Option + O**：关掉手机屏幕
- **Option + Shift + O**：点亮手机屏幕

日志：`~/Library/Logs/HuaweiMirror.log`

---

## 卸载

```bash
rm -rf ~/Applications/华为镜像.app ~/Desktop/华为镜像.app
brew uninstall scrcpy
```

`adb` 若只给本项目用，可再执行 `brew uninstall --cask android-platform-tools`。

---

## 常见问题

**找不到 scrcpy 或 adb**  
再跑一次 `./install.sh`，或手动：

```bash
brew install scrcpy
brew install --cask android-platform-tools
```

**连上没反应**  
看手机是否要授权；USB 是否选了传输文件/照片；打开上面的日志。

**锁屏点不动**  
打开开发人员选项里的 **USB 调试（安全设置）**，按提示重启后再试。锁屏密码无法绕过，需在窗口里解锁一次。

**画面发虚**  
不要把窗口拉得比手机分辨率还大。无线会略降码率，清晰度优先用有线。

---

## 仓库说明

| 路径 | 作用 |
| --- | --- |
| `install.sh` | macOS 一键安装 |
| `app/HuaweiMirror.app` | 应用包（启动脚本 + 图标 + 中文输入辅助） |
| `LICENSE` | MIT |

投屏能力来自 scrcpy（Apache-2.0）。本仓库不附带 scrcpy 二进制，安装时通过 Homebrew 获取。

---

## License

MIT。Huawei、HarmonyOS 等为各自权利人的商标。
