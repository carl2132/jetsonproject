#!/bin/bash

set -e  # 遇到错误立即退出

MODEL_PATH="$1"
BUCKET_NAME="cqutxc"
OSSUTIL="/var/jenkins_home/bin/ossutil"
DEST_PATH="models/$(basename "${MODEL_PATH}")"
LATEST_FILE="/tmp/latest.txt"

echo "📤 正在上传模型: ${MODEL_PATH} 到 OSS..."

if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ 模型文件不存在: $MODEL_PATH"
  exit 1
fi

# 上传模型
$OSSUTIL cp "$MODEL_PATH" "oss://${BUCKET_NAME}/${DEST_PATH}" --force
echo "✅ 模型上传成功"

# 写入 latest.txt 以模拟 OTA 触发
echo "$(basename "${MODEL_PATH}")" > "$LATEST_FILE"

# 上传 latest.txt
$OSSUTIL cp "$LATEST_FILE" "oss://${BUCKET_NAME}/latest.txt" --force
echo "🚀 OTA 模型更新记录完成: $(basename "${MODEL_PATH}")"
