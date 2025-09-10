# Serv00 一键安装 & 运行 Sing-Box
本文档介绍如何在 **Serv00** 上快速部署并运行 **Sing-Box**。
---
## 🚀 一键安装 Sing-Box
运行以下命令即可一键安装：
```bash
bash <(curl -Ls "https://raw.githubusercontent.com/1774293824/Github_files/main/serv00.sh?$(date +%s)")
```
> ⚠️ 脚本会自动下载依赖并配置运行环境，请耐心等待执行完成。
---
## 🔑 生成证书（private.key & cert.pem）
在 Serv00 中生成自签名证书（可用于 TLS 配置）：
```bash
# 生成私钥
openssl ecparam -genkey -name prime256v1 -out private.key

# 生成自签名证书（请将 {your_domain} 替换为你绑定的域名）
openssl req -new -x509 -days 3650 -key private.key -out cert.pem -subj "/CN={your_domain}"
```
---

## 📦 下载 Sing-Box 程序
从 **Release 页面** 下载 `wordpress` 文件（实际上是 `sing-box` 的可执行文件）：
👉 [下载地址](https://github.com/eooce/test/releases/tag/freebsd)
下载后请将其重命名为 `wordpress` 并赋予可执行权限：
```bash
chmod +x wordpress
```
---
## ▶️ 启动 Sing-Box
使用 `screen` 在后台运行 Sing-Box：
```bash
screen -dmS box ./wordpress run
```
说明：
* `screen -dmS box` → 在后台新建一个名为 **box** 的会话
* `./wordpress run` → 启动 sing-box
如果需要进入 screen 会话：
```bash
screen -r box
```
如果需要退出后台运行：
```bash
screen -S box -X quit
```
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
