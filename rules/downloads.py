import os
import time
import requests
from urllib.parse import urlparse, unquote


def format_size(size):
    """格式化文件大小"""
    if size < 1024:
        return f"{size:.2f} B"
    elif size < 1024**2:
        return f"{size / 1024:.2f} KB"
    elif size < 1024**3:
        return f"{size / 1024 ** 2:.2f} MB"
    else:
        return f"{size / 1024 ** 3:.2f} GB"


def download_file(url, save_path=None):
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, stream=True, headers=headers)
    response.raise_for_status()

    # 获取文件总大小
    total_size = int(response.headers.get("Content-Length", 0))

    # 如果没有指定保存路径，则使用URL中的文件名
    if save_path is None:
        save_path = os.path.basename(unquote(urlparse(url).path))

        if not save_path:
            save_path = "download.file"

    downloaded = 0
    chunk_size = 1024 * 64  # 64KB
    start_time = time.time()
    last_time = start_time
    last_downloaded = 0

    print(f"开始下载：{save_path}")
    print(f"文件大小：{format_size(total_size)}")

    with open(save_path, "wb") as f:
        for chunk in response.iter_content(chunk_size=chunk_size):
            if not chunk:
                continue

            f.write(chunk)
            downloaded += len(chunk)

            now = time.time()

            # 每0.2秒刷新一次显示
            if now - last_time >= 0.2 or downloaded == total_size:

                speed = (downloaded - last_downloaded) / (now - last_time)

                last_time = now
                last_downloaded = downloaded

                if total_size:
                    percent = downloaded / total_size * 100

                    bar_length = 40
                    filled = int(bar_length * downloaded / total_size)
                    bar = "█" * filled + "-" * (bar_length - filled)

                    print(
                        f"\r[{bar}] "
                        f"{percent:6.2f}% "
                        f"{format_size(downloaded)}/{format_size(total_size)} "
                        f"速度: {format_size(speed)}/s",
                        end="",
                        flush=True,
                    )
                else:
                    print(
                        f"\r已下载 {format_size(downloaded)} "
                        f"速度: {format_size(speed)}/s",
                        end="",
                        flush=True,
                    )

    total_time = time.time() - start_time

    print()
    print("=" * 60)
    print("下载完成！")
    print(f"保存位置：{os.path.abspath(save_path)}")
    print(f"总耗时：{total_time:.2f} 秒")
    print(f"平均速度：{format_size(downloaded / total_time)}/s")


if __name__ == "__main__":
    url = "https://wolfsir.serv00.net/%e5%82%ac%e7%9c%a0%e6%80%a7%e6%8c%87%e5%b0%8e3.mp4"
    download_file(url)
