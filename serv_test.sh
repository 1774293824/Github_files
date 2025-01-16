#!/bin/sh
set -e
export UUID=${UUID:-'ccc33d85-681b-41f7-b9db-079ed095d2df'}
USERNAME=$(whoami)

WORK_DIR="./sing-box"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

# 下载并解压缩文件
echo "下载 sing-box.zip..."
wget -O 'sing-box.zip' 'https://raw.githubusercontent.com/1774293824/Github_files/main/sing-box.zip' && unzip sing-box.zip

# 获取用户输入的函数
prompt_for_input() {
    local prompt_msg=$1
    local default_value=$2
    read -p "$(echo -e '\033[0;32m'"$prompt_msg"' \033[0m')" input
    echo "${input:-$default_value}"
}
UUID=$(prompt_for_input "输入UUID:" "ccc33d85-681b-41f7-b9db-079ed095d2df")
PORT1=$(prompt_for_input "输入配置的第一个udp端口号: " "33333")
IP_1=$(prompt_for_input "请输入第 1 个IP地址: " "{{IP_1}}")
PORT2=$(prompt_for_input "输入配置的第二个udp端口号: " "44444")
IP_2=$(prompt_for_input "请输入第 2 个IP地址: " "{{IP_2}}")

# 配置文件备份路径
BACKUP_CONFIG_FILE="config_copy.json"
NEW_CONFIG_FILE="config.json"

# 删除旧的 config.json 文件
if [ -f "$NEW_CONFIG_FILE" ]; then
    echo "删除旧的 $NEW_CONFIG_FILE 文件..."
    rm -f "$NEW_CONFIG_FILE"
fi

# 检查备份配置文件是否存在
if [ -f "$BACKUP_CONFIG_FILE" ]; then
    echo "复制 $BACKUP_CONFIG_FILE 为 $NEW_CONFIG_FILE..."
    cp "$BACKUP_CONFIG_FILE" "$NEW_CONFIG_FILE"

    echo "替换配置文件中的占位符..."
    sed -i '' "s/a03e977f-6491-42a2-b56d-abbab6c3a9ac/$UUID/g" "$NEW_CONFIG_FILE"
    sed -i '' "s/{{IP_1}}/$IP_1/g; s/33333/$PORT1/g" "$NEW_CONFIG_FILE"
    sed -i '' "s/{{IP_2}}/$IP_2/g; s/44444/$PORT2/g" "$NEW_CONFIG_FILE"
else
    echo "配置文件 $BACKUP_CONFIG_FILE 不存在！"
    exit 1
fi

# 设置文件权限
chmod 755 sb

# 启动服务
echo "启动服务..."
screen -dmS box /home/$(whoami)/sing-box/sb run
echo "启动服务: successful\n服务已成功启动,可运行 ps aux 查看进程"
echo ""
