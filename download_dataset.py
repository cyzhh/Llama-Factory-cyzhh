import os

if __name__ == '__main__':
    os.environ['HF_ENDPOINT'] = 'https://hf-mirror.com'
    os.environ['HF_HOME'] = 'source_dataset/hf_cache'
    
    os.system('huggingface-cli download --repo-type dataset cyzhh/train --local-dir data --local-dir-use-symlinks False')
