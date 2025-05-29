docker build -f Dockerfile \
    --build-arg INSTALL_BNB=false \
    --build-arg INSTALL_VLLM=false \
    --build-arg INSTALL_DEEPSPEED=true \
    --build-arg INSTALL_FLASHATTN=true \
    --build-arg PIP_INDEX=https://mirrors.ustc.edu.cn/pypi/simple \
    -t temp .