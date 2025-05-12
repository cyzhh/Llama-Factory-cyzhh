FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-devel AS builder

# 第一阶段编译flash-attn
RUN pip install flash-attn --no-build-isolation && \
    pip wheel flash-attn -w /tmp/wheels/

FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime

COPY --from=builder /tmp/wheels /tmp/wheels

# apt换源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 安装Llama-Factory及依赖
RUN pip install /tmp/wheels/flash-attn.whl && \
    pip install --no-cache-dir deepspeed && \
    git clone --depth=1 https://github.com/hiyouga/LLaMA-Factory.git . && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install -e ".[torch,metrics]"

# 训练启动命令（Lora微调配置）
CMD ["llamafactory-cli", "train", "examples/train_full/sft_ds2.yaml"]