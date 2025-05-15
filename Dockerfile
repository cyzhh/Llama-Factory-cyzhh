# 使用 NVIDIA 官方镜像作为基础
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:24.12-py3
FROM ${BASE_IMAGE}

# 环境变量配置
ENV MAX_JOBS=4
ENV FLASH_ATTENTION_FORCE_BUILD=TRUE
ENV VLLM_WORKER_MULTIPROC_METHOD=spawn

# 安装参数（根据需求开启）
ARG INSTALL_DEEPSPEED=true
ARG INSTALL_FLASHATTN=true
ARG PIP_INDEX=https://mirrors.ustc.edu.cn/pypi/simple

WORKDIR /app

# 1. 安装基础依赖
COPY requirements.txt /app
RUN pip config set global.index-url "$PIP_INDEX" && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# 2. 克隆仓库（替换为您fork的仓库）
RUN git clone https://github.com/cyzhh/Llama-Factory-cyzhh.git /app

# 3. 安装扩展包（启用deepspeed和flash-attn）
RUN pip install -e ".[deepspeed,torch,metrics]" && \
    if [ "$INSTALL_FLASHATTN" == "true" ]; then \
        pip uninstall -y ninja transformer-engine flash-attn && \
        pip install ninja && \
        pip install --no-cache-dir flash-attn --no-build-isolation; \
    fi

# 4. 数据准备
RUN mkdir -p /app/data && \
    huggingface-cli download cyzhh/train --repo-type dataset --local-dir /app/data

# 5. 挂载点配置
VOLUME ["/app/data", "/app/output", "/app/models"]

# 6. 训练启动命令（覆盖默认CMD）
CMD ["llamafactory-cli", "train", "examples/train_lora/llama3_lora_sft.yaml"]