# 运行命令
```
screen -dmS box ./wordpress run
```
# serv00一键安装运行sing-box
```
bash <(curl -Ls "https://raw.githubusercontent.com/1774293824/Github_files/main/serv00.sh?$(date +%s)")
```
serv00生成 private.key 与 cert.pem
```
openssl ecparam -genkey -name prime256v1 -out private.key
openssl req -new -x509 -days 3650 -key private.key -out cert.pem -subj "/CN={这里填写自己的域名}"
```

安装 vless 节点
```
bash <(curl -Ls "https://raw.githubusercontent.com/1774293824/Github_files/main/serv00_vless.sh?$(date +%s)")
```
# 老王项目：下载singbox
下载说明：在release中下载 wordpress 文件，再配合cert.pem文件和private.key文件，即可实现运行sing-box
下载地址
```
https://github.com/eooce/test/releases/tag/freebsd
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
