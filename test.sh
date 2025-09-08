# 设置变量（根据实际修改）
export USERNAME="a2409041774"
export snb="s11"
export nb="s11"
export HOSTNAME="s11.serv00.com"
export hona="serv00"

mkdir -p "${HOME}/domains/s11.a2409041774.serv00.net/public_nodejs"

export WORKDIR="${HOME}/domains/a2409041774.serv00.net/logs"
export FILE_PATH="${HOME}/domains/a2409041774.serv00.net/public_html"

# 创建目录
mkdir -p "$FILE_PATH" "$WORKDIR"
chmod 777 "$WORKDIR"

# 开启 binexec
devil binexec on
