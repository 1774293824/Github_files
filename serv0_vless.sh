#!/bin/sh
set -e

WORK_DIR="./vless"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

# 下载并解压缩文件
wget -q 'https://github.com/1774293824/Github_files/releases/download/serv00/vless.zip'
echo "下载完成"
unzip vless.zip

echo "安装完成"
echo "请运行 【 screen -dmS vless node /home/$(whoami)/vless/app.js 】"
