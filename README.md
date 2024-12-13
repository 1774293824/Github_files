# serv00一键安装运行sing-box
```
bash <(curl -Ls "https://raw.githubusercontent.com/1774293824/BPB_worker/main/serv00_hy2.sh?$(date +%s)")

```
# 后续运行使用下面的命令
```
screen -dmS box /home/$(whoami)/sing-box/sb run
```
# 老王项目：下载singbox
download_singbox() {
  ARCH=$(uname -m) && DOWNLOAD_DIR="." && mkdir -p "$DOWNLOAD_DIR" && FILE_INFO=()
  if [ "$ARCH" == "arm" ] || [ "$ARCH" == "arm64" ] || [ "$ARCH" == "aarch64" ]; then
      FILE_INFO=("https://github.com/eooce/test/releases/download/arm64/sb web" "https://github.com/eooce/test/releases/download/arm64/bot13 bot" "https://github.com/eooce/test/releases/download/ARM/swith npm")
  elif [ "$ARCH" == "amd64" ] || [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "x86" ]; then
      FILE_INFO=("https://github.com/eooce/test/releases/download/freebsd/sb web" "https://github.com/eooce/test/releases/download/freebsd/server bot" "https://github.com/eooce/test/releases/download/freebsd/npm npm")
  else
      echo "Unsupported architecture: $ARCH"
      exit 1
  fi

# 延迟测试链接

| 服务提供者 | 链接 |
|------------|------|
| Google     | [http://www.gstatic.com/generate_204](http://www.gstatic.com/generate_204) |
| Google     | [http://www.google-analytics.com/generate_204](http://www.google-analytics.com/generate_204) |
| Google     | [http://www.google.com/generate_204](http://www.google.com/generate_204) |
| Google     | [http://connectivitycheck.gstatic.com/generate_204](http://connectivitycheck.gstatic.com/generate_204) |
| Apple      | [http://captive.apple.com](http://captive.apple.com) |
| Apple      | [http://www.apple.com/library/test/success.html](http://www.apple.com/library/test/success.html) |
| Microsoft  | [http://www.msftconnecttest.com/connecttest.txt](http://www.msftconnecttest.com/connecttest.txt) |
| Cloudflare | [http://cp.cloudflare.com/](http://cp.cloudflare.com/) |
| Firefox    | [http://detectportal.firefox.com/success.txt](http://detectportal.firefox.com/success.txt) |
| V2ex       | [http://www.v2ex.com/generate_204](http://www.v2ex.com/generate_204) |
| 小米       | [http://connect.rom.miui.com/generate_204](http://connect.rom.miui.com/generate_204) |
| 华为       | [http://connectivitycheck.platform.hicloud.com/generate_204](http://connectivitycheck.platform.hicloud.com/generate_204) |
| Vivo       | [http://wifi.vivo.com.cn/generate_204](http://wifi.vivo.com.cn/generate_204) |
