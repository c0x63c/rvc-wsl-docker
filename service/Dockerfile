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

# poetry
ENV POETRY_HOME=/opt/poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# git
RUN git clone https://github.com/liujing04/Retrieval-based-Voice-Conversion-WebUI.git ./RVC-WebUI
RUN mkdir /huggingface && cd /huggingface && \
git init . && git config core.sparsecheckout true && \
echo -e "\nhubert_base.pt\n/uvr5_weights\n/pretrained" > .git/info/sparse-checkout && \
git remote add origin https://huggingface.co/lj1995/VoiceConversionWebUI.git && git pull origin main && \
cp -p -r ./hubert_base.pt ./pretrained ./uvr5_weights /RVC-WebUI/. &&  rm -r -f /huggingface
WORKDIR /RVC-WebUI

# requirements pytorch
RUN pip install torch torchvision torchaudio \
&& poetry install

# shell
COPY ./service/entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python3 infer-web.py ${CLI_ARGS}
