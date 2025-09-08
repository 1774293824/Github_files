#!/usr/bin/env bash
# 精简版：serv00/hostuno 三协议共存脚本（无前端保活）
# 快捷方式：sb

set -euo pipefail
# -------------------- 颜色函数 --------------------
red(){ echo -e "\e[1;31m$1\033[0m"; }
green(){ echo -e "\e[1;32m$1\033[0m"; }
yellow(){ echo -e "\e[1;33m$1\033[0m"; }
purple(){ echo -e "\e[1;35m$1\033[0m"; }
reading(){ read -rp "$(red "$1")" "$2"; }

# -------------------- 全局变量 --------------------
USERNAME=$(whoami | tr '[:upper:]' '[:lower:]')
HOSTNAME=$(hostname)
snb=$(hostname | cut -d. -f1)
hona=$(hostname | cut -d. -f2)
address=$([ "$hona" = "serv00" ] && echo "serv00.net" || echo "useruno.com")
WORKDIR="${HOME}/domains/${USERNAME}.${address}/logs"
FILE_PATH="${HOME}/domains/${USERNAME}.${address}/public_html"
mkdir -p "$WORKDIR" "$FILE_PATH"

# -------------------- 依赖检查 --------------------
command -v jq >/dev/null || { yellow "安装 jq ..."; devil binexec on >/dev/null 2>&1; }
command -v uuidgen >/dev/null || { yellow "安装 uuidgen ..."; devil binexec on >/dev/null 2>&1; }

# -------------------- 端口管理 --------------------
check_port(){
  local tl=$(devil port list | grep -c tcp) tu=$(devil port list | grep -c udp)
  if [[ $tl -ne 2 || $tu -ne 1 ]]; then
    devil port list | grep -E '^[0-9]' | awk '{print $2,$1}' | while read t p; do
      devil port del "$t" "$p" 2>/dev/null; done
    for _ in {1..2}; do
      while :; do
        pt=$(shuf -i 10000-65000 -n1)
        devil port add tcp "$pt" 2>/dev/null | grep -q succ && { tcp+=($pt); break; }
      done; done
    while :; do
      pu=$(shuf -i 10000-65000 -n1)
      devil port add udp "$pu" 2>/dev/null | grep -q succ && break
    done
  else
    read -r tcp1 tcp2 <<<$(devil port list | awk '/tcp/{print $1}')
    pu=$(devil port list | awk '/udp/{print $1}')
    tcp=($tcp1 $tcp2)
  fi
  vless_port=${tcp[0]} vmess_port=${tcp[1]} hy2_port=$pu
  green "vless-reality端口：$vless_port  |  vmess-ws端口：$vmess_port  |  hysteria2端口：$hy2_port"
}

# -------------------- 交互变量 --------------------
read_ip(){
  rm -f ip.txt
  for h in "$HOSTNAME" "cache$snb.$hona.com" "web$snb.$hona.com"; do
    dig @8.8.8.8 +short +time=2 "$h" | grep -E '^[0-9.]+$' >> ip.txt; done
  reading "请输入上面任意一个可用IP（直接回车自动选第一个）：" IP
  [[ -z $IP ]] && IP=$(head -n1 ip.txt | awk '{print $1}')
  echo "$IP" > "$WORKDIR/ip.txt"
}
read_uuid(){
  reading "输入统一UUID（回车随机）：" UUID
  [[ -z $UUID ]] && UUID=$(uuidgen -r)
  echo "$UUID" > "$WORKDIR/uuid.txt"
}
read_reym(){
  reading "输入reality域名（回车默认 $USERNAME.$address）：" reym
  [[ -z $reym ]] && reym=$USERNAME.$address
  echo "$reym" > "$WORKDIR/reym.txt"
}
argo_configure(){
  reading "选argo模式：回车=临时隧道  g=固定隧道：" ac
  if [[ $ac == [Gg] ]]; then
    reading "输入argo固定域名：" ARGO_DOMAIN
    reading "输入argo token（ey开头）：" ARGO_AUTH
    echo "$ARGO_DOMAIN" > "$WORKDIR/argo_domain.txt"
    echo "$ARGO_AUTH"   > "$WORKDIR/argo_auth.txt"
  else
    rm -f "$WORKDIR"/argo_*.txt
  fi
}

# -------------------- 下载内核 --------------------
download_core(){
  cd "$WORKDIR"
  [[ -e sb ]] && return
  yellow "下载 sing-box ..."
  curl -sL -o sb https://github.com/yonggekkk/Cloudflare_vless_trojan/releases/download/serv00/sb
  chmod +x sb
  ./sb generate reality-keypair > keypair.txt
  public_key=$(awk '/PublicKey/{print $2}' keypair.txt)
  private_key=$(awk '/PrivateKey/{print $2}' keypair.txt)
  openssl ecparam -genkey -name prime256v1 -out private.key
  openssl req -new -x509 -days 3650 -key private.key -out cert.pem -subj "/CN=$USERNAME.$address"
}

# -------------------- 生成配置 --------------------
build_config(){
  cat > config.json <<EOF
{
  "log":{"level":"info","timestamp":true},
  "inbounds":[
    {"tag":"hy","type":"hysteria2","listen":"::","listen_port":$hy2_port,"users":[{"password":"$UUID"}],"tls":{"enabled":true,"alpn":["h3"],"certificate_path":"cert.pem","key_path":"private.key"}},
    {"tag":"vl","type":"vless","listen":"::","listen_port":$vless_port,"users":[{"uuid":"$UUID","flow":"xtls-rprx-vision"}],"tls":{"enabled":true,"server_name":"$reym","reality":{"enabled":true,"handshake":{"server":"$reym","server_port":443},"private_key":"$private_key","short_id":[""]}}},
    {"tag":"vm","type":"vmess","listen":"::","listen_port":$vmess_port,"users":[{"uuid":"$UUID"}],"transport":{"type":"ws","path":"/$UUID-vm"}}
  ],
  "outbounds":[{"type":"direct","tag":"direct"}]
}
EOF
}

# -------------------- 启动 --------------------
run_core(){
  pkill -x sb 2>/dev/null || true
  nohup ./sb run -c config.json >/dev/null 2>&1 &
  sleep 3
  pgrep -x sb >/dev/null && green "sing-box 主进程已启动" || red "主进程启动失败"
}
run_argo(){
  if [[ -f argo_auth.txt ]]; then
    args="tunnel --no-autoupdate run --token $(cat argo_auth.txt)"
  else
    args="tunnel --url http://localhost:$vmess_port --no-autoupdate --logfile boot.log --loglevel info"
  fi
  curl -sL -o argo https://github.com/yonggekkk/Cloudflare_vless_trojan/releases/download/serv00/server
  chmod +x argo
  pkill -x argo 2>/dev/null || true
  nohup ./argo $args >/dev/null 2>&1 &
  sleep 5
  pgrep -x argo >/dev/null && green "Argo 已启动" || red "Argo 启动失败"
}

# -------------------- 节点信息 --------------------
show_links(){
  argodomain=$(cat boot.log 2>/dev/null | awk '/trycloudflare.com/{print $4;exit}' | awk -F// '{print $2}' || cat argo_domain.txt 2>/dev/null)
  base64 -w0 jh.txt > sub.txt
  cat <<EOF
=================== 节点链接 ===================
vless-reality：
vless://$UUID@$IP:$vless_port?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$reym&fp=chrome&pbk=$public_key&type=tcp#$snb-vl-$USERNAME

vmess-ws：
vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$snb-vm-$USERNAME\", \"add\": \"$IP\", \"port\": \"$vmess_port\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"path\": \"/$UUID-vm\" }" | base64 -w0)

hysteria2：
hysteria2://$UUID@$IP:$hy2_port?security=tls&sni=www.bing.com&alpn=h3&insecure=1#$snb-hy2-$USERNAME

Argo 域名：${argodomain:-未启用}
订阅地址：https://${USERNAME}.${address}/${UUID}_sub.txt
==============================================
EOF
}

# -------------------- 安装 --------------------
install(){
  [[ -e $WORKDIR/sb ]] && { yellow "已安装，先卸载再装"; return; }
  cd "$WORKDIR"
  read_ip; read_uuid; read_reym; check_port; argo_configure
  download_core; build_config
  run_core; run_argo
  # 生成订阅文件
  cat > jh.txt <<EOF
vless://$UUID@$IP:$vless_port?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$reym&fp=chrome&pbk=$public_key&type=tcp#$snb-vl-$USERNAME
vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$snb-vm-$USERNAME\", \"add\": \"$IP\", \"port\": \"$vmess_port\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"path\": \"/$UUID-vm\" }" | base64 -w0)
hysteria2://$UUID@$IP:$hy2_port?security=tls&sni=www.bing.com&alpn=h3&insecure=1#$snb-hy2-$USERNAME
EOF
  base64 -w0 jh.txt > ${FILE_PATH}/${UUID}_sub.txt
  green "安装完成！菜单输入 6 查看节点"
}

# -------------------- 卸载 --------------------
uninstall(){
  reading "确认卸载？[y/n]：" c
  [[ $c != [Yy] ]] && return
  pkill -x sb argo 2>/dev/null || true
  devil www list | awk 'NR>1{print $1}' | xargs -r -I{} devil www del {} 2>/dev/null || true
  rm -rf "$WORKDIR" ~/bin/sb 2>/dev/null
  green "卸载完成"
}

# -------------------- 重启 --------------------
restart(){
  cd "$WORKDIR"
  run_core; run_argo
  show_links
}

# -------------------- 换端口 --------------------
change_port(){
  cd "$WORKDIR"
  check_port
  # 直接替换端口
  jq --arg vp "$vless_port" --arg mp "$vmess_port" --arg hp "$hy2_port" \
    '.inbounds[0].listen_port=($hp|tonumber) | .inbounds[1].listen_port=($vp|tonumber) | .inbounds[2].listen_port=($mp|tonumber)' \
    config.json > tmp.json && mv tmp.json config.json
  restart
}

# -------------------- 换 Argo --------------------
change_argo(){
  cd "$WORKDIR"
  argo_configure
  run_argo
  show_links
}

# -------------------- 菜单 --------------------
menu(){
  clear
  echo "========= Serv00/Hostuno 三协议精简版 ========="
  echo "1) 安装"
  echo "2) 卸载"
  echo "3) 重启进程"
  echo "4) 重置端口"
  echo "5) 重置 Argo"
  echo "6) 查看节点"
  echo "0) 退出"
  echo "=============================================="
  reading "请选择：" choice
  case $choice in
    1) install ;;
    2) uninstall ;;
    3) restart ;;
    4) change_port ;;
    5) change_argo ;;
    6) cd "$WORKDIR" && show_links ;;
    0) exit 0 ;;
    *) red "无效选择" ;;
  esac
}

# 如果直接运行脚本则进菜单
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && menu
