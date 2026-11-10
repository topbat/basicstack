# =====================================================================================
# MinerU（PDF/文档智能解析）本地构建镜像 —— CPU 版
# 说明：MinerU 官方不提供 Docker Hub 镜像，此处基于官方 Python 包构建
#   - 版本固定为 3.4.5（当前最新稳定版，4.0 尚为 alpha）
#   - MINERU_MODEL_SOURCE=modelscope：模型从 ModelScope 国内源下载（首次解析时自动下载到挂载卷）
#   - MINERU_DEVICE_MODE=cpu：本机无 GPU，使用 CPU 推理
# 构建命令：docker compose build mineru
# =====================================================================================
# 基础镜像使用本地已拉取的国内镜像源版本（BuildKit 不走代理，直接引用 docker.io 会拉取失败）
FROM docker.m.daocloud.io/library/python:3.11-slim-bookworm

ENV PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple \
    MINERU_MODEL_SOURCE=modelscope \
    MINERU_DEVICE_MODE=cpu

# 安装 MinerU 核心（含 torch 等 CPU 依赖，约 3-5GB）
RUN pip install --no-cache-dir "mineru[core]==3.4.5"

# opencv/pdf 渲染所需系统库（缺 libxcb/libgl 会导致 mineru-api 启动 ImportError）
# 注意：放在 pip 层之后，保证重建时 pip 大层可命中缓存
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 libxcb1 libsm6 libxext6 libxrender1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
EXPOSE 8000
ENTRYPOINT ["mineru-api"]
CMD ["--host", "0.0.0.0", "--port", "8000"]
