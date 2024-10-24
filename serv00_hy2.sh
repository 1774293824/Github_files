#!/bin/sh
set -e
export UUID=${UUID:-'a03e977f-6491-42a2-b56d-abbab6c3a9ac'}
USERNAME=$(whoami)

WORK_DIR="./sing-box"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

# 下载并解压缩文件
echo "下载 s-box.zip..."
wget -O 's-box.zip' 'https://raw.githubusercontent.com/1774293824/BPB_worker/main/s-box.zip' && unzip s-box.zip

# 获取用户输入的函数
prompt_for_input() {
    local prompt_msg=$1
    local default_value=$2
    read -p "$(echo -e '\033[0;32m'"$prompt_msg"' \033[0m')" input
    echo "${input:-$default_value}"
}

IP=$(prompt_for_input "请输入 IP地址: " "{{IP}}")
PORT1=$(prompt_for_input "输入 hysteria2的udp端口号: " "33333")

# 配置文件备份路径
BACKUP_CONFIG_FILE="config_backup.json"
NEW_CONFIG_FILE="config.json"

# 删除旧的 config.json 文件
if [ -f "$NEW_CONFIG_FILE" ]; then
    echo "删除旧的 $NEW_CONFIG_FILE 文件..."
    rm -f "$NEW_CONFIG_FILE"  # 删除旧的 config.json 文件
fi

# 检查备份配置文件是否存在
if [ -f "$BACKUP_CONFIG_FILE" ]; then
    echo "复制 $BACKUP_CONFIG_FILE 为 $NEW_CONFIG_FILE..."
    cp "$BACKUP_CONFIG_FILE" "$NEW_CONFIG_FILE"  # 从备份文件复制新文件

    echo "替换配置文件中的占位符..."
    sed -i '' "s/{{IP}}/$IP/g; s/33333/$PORT1/g" "$NEW_CONFIG_FILE"  # 替换新配置文件中的占位符
else
    echo "配置文件 $BACKUP_CONFIG_FILE 不存在！"
    exit 1
fi

# 设置文件权限
chmod 755 sb

# 启动服务
echo "启动服务..."
screen -dmS box /home/${USERNAME}/sing-box/sb run
echo "启动服务: successful\n服务已成功启动。要重新附加到屏幕会话，请使用：screen -r box\n请测试下面的订阅:"
echo ""
echo -e "\033[0;32m hysteria2://$UUID@$IP:$PORT1/?sni=www.bing.com&alpn=h3&insecure=1#${USERNAME} \033[0m"
echo ""
