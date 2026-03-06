#!/bin/bash
# 龙门计划 - Mac 一键安装脚本
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUSH_SCRIPT="$SCRIPT_DIR/auto_push_mac.sh"
LOG_DIR="$SCRIPT_DIR/.longmen"
PLIST_TEMPLATE="$SCRIPT_DIR/com.longmen.autopush.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.longmen.autopush.plist"

echo "=== 龙门计划 自动上传 - 安装程序 ==="
echo ""

# 检查 git
if ! command -v git &>/dev/null; then
    echo "错误：未检测到 Git，请先安装 Xcode Command Line Tools"
    echo "运行：xcode-select --install"
    exit 1
fi

# 创建日志目录
mkdir -p "$LOG_DIR"

# 赋予脚本执行权限
chmod +x "$PUSH_SCRIPT"

# 将 plist 模板中的占位符替换为实际路径，写入 LaunchAgents
sed \
    -e "s|__SCRIPT_PATH__|$PUSH_SCRIPT|g" \
    -e "s|__LOG_PATH__|$LOG_DIR/auto_push.log|g" \
    -e "s|__ERR_PATH__|$LOG_DIR/auto_push_error.log|g" \
    "$PLIST_TEMPLATE" > "$PLIST_DEST"

# 加载定时任务
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "安装完成！"
echo ""
echo "  自动上传时间：每天 23:00"
echo "  日志位置：$LOG_DIR/auto_push.log"
echo ""
echo "提示：如需立即测试上传，运行："
echo "  bash $PUSH_SCRIPT"
