# 设置变量（根据实际修改）
export USERNAME=$(whoami | tr '[:upper:]' '[:lower:]')
export snb=$(hostname | cut -d. -f1)
export nb=$(hostname | cut -d '.' -f 1 | tr -d 's')
export HOSTNAME=$(hostname)
export hona=$(hostname | cut -d. -f2)

# 设置工作目录
if [ "$hona" = "serv00" ]; then
  address="serv00.net"
  keep_path="${HOME}/domains/${snb}.${USERNAME}.serv00.net/public_nodejs"
  mkdir -p "$keep_path"
else
  address="useruno.com"
fi

export WORKDIR="${HOME}/domains/${USERNAME}.${address}/logs"
export FILE_PATH="${HOME}/domains/${USERNAME}.${address}/public_html"

# 创建目录
mkdir -p "$FILE_PATH" "$WORKDIR"
chmod 777 "$WORKDIR"

# 开启 binexec
devil binexec on
