FROM nvidia/cuda:11.8.0-base-ubuntu22.04

ENV PYTHONUNBUFFERED=1 

# system
# python3
RUN apt update -y -q && DEBIAN_FRONTEND=noninteractive apt install -y -q --no-install-recommends \
    software-properties-common apt-utils \
    curl git git-lfs vim python3-dev g++ build-essential \
    python3.10 pip libgl1-mesa-dev ffmpeg \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# git
RUN git clone https://github.com/liujing04/Retrieval-based-Voice-Conversion-WebUI.git ./RVC-WebUI
RUN mkdir /huggingface && cd /huggingface && \
git init . && git config core.sparsecheckout true && \
echo -e "\nhubert_base.pt\nrmvpe.pt\n/uvr5_weights\n/pretrained\n/pretrained_v2\nrmvpe.onnx" > .git/info/sparse-checkout && \
git remote add origin https://huggingface.co/lj1995/VoiceConversionWebUI.git && git pull origin main && \
cp -p -r ./hubert_base.pt ./rmvpe.pt ./rmvpe.onnx ./pretrained ./pretrained_v2 ./uvr5_weights /RVC-WebUI/. &&  rm -r -f /huggingface
WORKDIR /RVC-WebUI

# requirements pytorch
RUN pip install -r requirements.txt && pip install onnx

# shell
COPY ./service/entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python3 infer-web.py ${CLI_ARGS}
