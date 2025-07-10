#!/bin/bash

MODEL_PATH=$1
BUCKET_NAME="cqutxc"
DEST_PATH="models/$(basename ${MODEL_PATH})"
OSSUTIL="/usr/local/bin/ossutil"

echo "📤 正在上传模型: ${MODEL_PATH} 到 OSS..."

${OSSUTIL} cp "$MODEL_PATH" "oss://${BUCKET_NAME}/${DEST_PATH}" --force
if [ $? -ne 0 ]; then
  echo "❌ OSS 上传失败"
  exit 1
fi

echo "✅ 模型上传成功"

# OTA 模拟触发
echo "$(basename ${MODEL_PATH})" > ~/latest.txt
${OSSUTIL} cp ~/latest.txt "oss://${BUCKET_NAME}/latest.txt" --force

echo "🚀 OTA 模型更新记录完成: $(basename ${MODEL_PATH})"
