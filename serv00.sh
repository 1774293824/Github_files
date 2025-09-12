#!/bin/sh
set -e
export UUID=${UUID:-'ccc33d85-681b-41f7-b9db-079ed095d2df'}
export USERNAME=$(whoami | tr '[:upper:]' '[:lower:]')

# 下载并解压缩文件
wget -q 'https://raw.githubusercontent.com/1774293824/Github_files/main/config_copy.json'
echo "下载源文件'config_copy.json', done"
# wget -q 'https://github.com/1774293824/Github_files/releases/download/serv00/private.key'
echo "下载源文件'private.key', done"
# wget -q 'https://github.com/1774293824/Github_files/releases/download/serv00/cert.pem'
echo "下载源文件'cert.pem', done"
wget -q 'https://github.com/1774293824/Github_files/releases/download/serv00/wordpress'
echo "下载伪装后的源文件'wordpress', done"
echo "下载完成"

openssl ecparam -genkey -name prime256v1 -out private.key
openssl req -new -x509 -days 3650 -key private.key -out cert.pem -subj "/CN=${USERNAME}.serv00.net"

# 获取用户输入的函数
prompt_for_input() {
    local prompt_msg=$1
    local default_value=$2
    read -p "$(echo -e '\033[0;32m'"$prompt_msg"' \033[0m')" input
    echo "${input:-$default_value}"
}

while true; do
    cluster=$(prompt_for_input "请输入服务器所属 (11/12/13/14):" "")
    case "$cluster" in
        11) DEFAULT_IP="128.204.223.117"; break;;
        12) DEFAULT_IP="85.194.246.69"; break;;
        13) DEFAULT_IP="128.204.223.42"; break;;
        14) DEFAULT_IP="188.68.240.160"; break;;
        *) echo "输入无效，请输入 11/12/13/14 中的某一个:";;
    esac
done

UUID=$(prompt_for_input "输入UUID:" "ccc33d85-681b-41f7-b9db-079ed095d2df")
PORT1=$(prompt_for_input "输入配置的第一个udp端口号,回车默认31205:" "31205")
PORT2=$(prompt_for_input "输入配置的第二个udp端口号,回车默认12117:" "12117")

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
    sed -i '' "s/33333/$PORT1/g" "$NEW_CONFIG_FILE"
    sed -i '' "s/{{IP_2}}/$DEFAULT_IP/g; s/44444/$PORT2/g" "$NEW_CONFIG_FILE"
else
    echo "配置文件 $BACKUP_CONFIG_FILE 不存在！"
    exit 1
fi

# 设置文件权限
chmod 755 wordpress

# 启动服务
echo "自2025年5月1日开始,需要手动启动,请先cd到对应的文件夹再运行下面的命令:"
echo ""
echo "screen -dmS box ./wordpress run"
echo ""
