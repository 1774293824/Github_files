# 进阶示例：在 Serv00 上部署一个 AI 接口

不想搭博客？用 Serv00 跑一个自己的 AI 接口也行。

## 思路

使用 **Python + Flask** 写一个简单的 Web 服务：接收请求 → 调用 OpenAI / Claude / DeepSeek API → 返回结果。

部署到 Serv00 之后，你就拥有了一个 **24 小时在线的私人 AI 接口地址**。

---

## 1. 添加 Python 网站

1. 面板左侧点击 **WWW Websites** → **Add new website**
2. **Domain** 填你的域名
3. 点击 **Advanced settings**
4. **Website type** 选择 `Python`
5. **Python binary** 选择 `Python 3.11`

---

## 2. SSH 登录并创建虚拟环境

```bash
cd ~/domains/你的域名/public_python
virtualenv venv -p /usr/local/bin/python3.11
source venv/bin/activate
pip install flask openai
```

---

## 3. 编写 Flask 应用

在 `public_python` 目录下创建以下两个文件。

### `passenger_wsgi.py`

Serv00 通过这个文件启动应用：

```python
import sys, os
sys.path.append(os.getcwd())
from application import app as application
```

### `application.py`

核心逻辑（以 DeepSeek 为例）：

```python
from flask import Flask, request, jsonify
from openai import OpenAI

app = Flask(__name__)
client = OpenAI(
    api_key="你的API Key",
    base_url="https://api.deepseek.com"
)

@app.route("/ask", methods=["POST"])
def ask():
    data = request.json
    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[{"role": "user", "content": data["question"]}]
    )
    return jsonify({"answer": response.choices[0].message.content})
```

> ⚠️ **安全提示**：API Key 不要硬写在代码里，建议使用环境变量或配置文件管理，避免泄露。

---

## 4. 重启应用

```bash
devil www restart 你的域名
```

重启后，访问 `https://你的域名/ask`，向其 POST 一个 JSON 请求，即可拿到 AI 的回答。

请求示例：

```bash
curl -X POST https://你的域名/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "你好"}'
```

---

## 5. 申请 SSL

同 WordPress 示例第 6 步：

1. 面板左侧点击 **SSL**
2. 点击 **Add certificate**
3. 选择 **Let's Encrypt**

完成后，接口即可通过 HTTPS 访问。
