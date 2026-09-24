#!/bin/bash
# 华为镜像：macOS 一键安装依赖并部署桌面应用
set -euo pipefail

APP_NAME="华为镜像"
REPO_URL="${HUAWEI_MIRROR_REPO:-https://github.com/liuhaiquan/huawei-mirror.git}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "只支持 macOS。"
  exit 1
fi

echo "==> 安装 ${APP_NAME}（macOS）"

if ! command -v brew >/dev/null 2>&1; then
  echo "==> 未检测到 Homebrew，开始安装"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew 安装后仍不可用。请新开一个终端，再运行本脚本。"
  exit 1
fi

echo "==> 安装 scrcpy 与 adb"
brew install scrcpy
if ! command -v adb >/dev/null 2>&1; then
  brew install --cask android-platform-tools || brew install android-platform-tools
fi

resolve_source_app() {
  local here
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -d "${here}/app/HuaweiMirror.app" ]]; then
    echo "${here}/app/HuaweiMirror.app"
    return 0
  fi
  return 1
}

SRC_APP=""
if SRC_APP="$(resolve_source_app)"; then
  echo "==> 使用本地仓库中的应用包"
else
  if ! command -v git >/dev/null 2>&1; then
    echo "==> 安装 git"
    brew install git
  fi
  TMP="$(mktemp -d)"
  echo "==> 从 GitHub 克隆：${REPO_URL}"
  if ! git clone --depth 1 "$REPO_URL" "$TMP/huawei-mirror"; then
    echo
    echo "克隆失败。请先把仓库推到 GitHub，并把 install.sh 顶部的 YOUR_GITHUB_USERNAME 改成你的账号。"
    echo "或先 git clone 本仓库后，在仓库目录执行：./install.sh"
    exit 1
  fi
  SRC_APP="${TMP}/huawei-mirror/app/HuaweiMirror.app"
fi

if [[ ! -x "${SRC_APP}/Contents/MacOS/HuaweiMirror" ]]; then
  echo "应用包不完整：缺少可执行文件 HuaweiMirror"
  exit 1
fi

DEST_DIR="${HOME}/Applications"
DESKTOP_DIR="${HOME}/Desktop"
mkdir -p "$DEST_DIR"

DEST_APP="${DEST_DIR}/${APP_NAME}.app"
DESKTOP_APP="${DESKTOP_DIR}/${APP_NAME}.app"

echo "==> 安装到 ${DEST_APP}"
rm -rf "$DEST_APP"
cp -R "$SRC_APP" "$DEST_APP"
chmod +x "${DEST_APP}/Contents/MacOS/HuaweiMirror"
chmod +x "${DEST_APP}/Contents/Resources/type_to_phone.py" 2>/dev/null || true

echo "==> 同步到桌面"
rm -rf "$DESKTOP_APP"
cp -R "$DEST_APP" "$DESKTOP_APP"

xattr -cr "$DEST_APP" "$DESKTOP_APP" 2>/dev/null || true

if ! command -v scrcpy >/dev/null 2>&1 || ! command -v adb >/dev/null 2>&1; then
  echo "依赖未就绪。请确认 brew 已把 scrcpy 和 adb 装进 PATH。"
  exit 1
fi

echo
echo "安装完成。"
echo "  应用：${DEST_APP}"
echo "  桌面：${DESKTOP_APP}"
echo
echo "启动方式："
echo "  1. 双击桌面上的「${APP_NAME}」"
echo "  2. 或把图标拖到 Dock，以后一点即可"
echo "  3. 或运行：open \"${DEST_APP}\""
echo
echo "第一次若被系统拦截：按住 Control 点击图标 → 打开。"
echo

if [[ "${HUAWEI_MIRROR_NO_OPEN:-}" != "1" ]]; then
  read -r -p "现在启动应用？[Y/n] " answer || true
  answer="${answer:-Y}"
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    open "$DEST_APP"
  fi
fi
