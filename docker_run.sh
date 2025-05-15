docker run -dit --gpus=all \
    -v /var/lib/docker/raw_models/:/app/raw_models \
    -v /var/lib/docker/train_models/:/app/trained_models \
    -v ./hf_cache:/root/.cache/huggingface \
    -v ./ms_cache:/root/.cache/modelscope \
    -v ./om_cache:/root/.cache/openmind \
    -v ./data:/app/data \
    -v ./output:/app/output \
    --shm-size 100G \
    --name llamafactory-2 \
    llamafactory
