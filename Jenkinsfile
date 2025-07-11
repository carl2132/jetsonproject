#!/bin/bash

# ========== ✅ 基本配置 ==========
MODEL_PATH="$1"
MODEL_NAME=$(basename "$MODEL_PATH")

OSS_BUCKET="oss://cqutxc/models/"
CONFIG_FILE="/var/jenkins_home/.ossutilconfig"   # Jenkins 容器中配置路径
OSSUTIL="/var/jenkins_home/bin/ossutil"

JETSON_USER="cqut"
JETSON_IP="172.20.10.2"

# ========== 🔍 工具检测 ==========
if ! command -v "$OSSUTIL" &>/dev/null && [ ! -x "$OSSUTIL" ]; then
    echo "❌ 未找到 ossutil 可执行文件: $OSSUTIL"
    exit 1
fi

if ! command -v ssh &>/dev/null; then
    echo "❌ 未安装 SSH 命令，请确认 Jenkins 镜像包含 openssh-client"
    exit 1
fi

# ========== 🔍 输入校验 ==========
if [ -z "$MODEL_PATH" ]; then
    echo "❗ 用法: ./upload_and_ota.sh <模型路径>"
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "❌ 模型文件不存在: $MODEL_PATH"
    exit 1
fi

# ========== 🚀 上传模型 ==========
echo "📤 上传模型文件到 OSS: $MODEL_NAME"
"$OSSUTIL" --config-file "$CONFIG_FILE" cp "$MODEL_PATH" "${OSS_BUCKET}${MODEL_NAME}" --force
if [ $? -ne 0 ]; then
    echo "❌ 模型上传失败"
    exit 1
fi

# ========== 📝 写入 latest.txt ==========
echo "$MODEL_NAME" > latest.txt
"$OSSUTIL" --config-file "$CONFIG_FILE" cp latest.txt "${OSS_BUCKET}latest.txt" --force

echo "✅ 模型和 latest.txt 上传成功: $MODEL_NAME"

# ========== 📡 触发 Jetson OTA ==========
echo "📡 正在通过 SSH 通知 Jetson 执行 pull_model.service..."
ssh -o StrictHostKeyChecking=no ${JETSON_USER}@${JETSON_IP} 'sudo systemctl start pull_model.service'
if [ $? -ne 0 ]; then
    echo "⚠️ Jetson OTA 执行失败，请检查 SSH 免密和 sudo 权限"
    exit 1
else
    echo "✅ Jetson OTA 执行成功"
fi
