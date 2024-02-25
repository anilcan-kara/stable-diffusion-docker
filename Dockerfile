FROM python:3.11-slim-bullseye

RUN rm -rf /usr/local/cuda/lib64/stubs

RUN apt-get update && apt-get install -y build-essential
RUN python -m pip install shap
RUN apt-get update && apt-get install -y gcc

RUN pip install numpy
RUN pip install thinc
RUN pip install torch==2.1.0
RUN pip install audiocraft
RUN pip install diffusers[torch]
RUN pip install onnxruntime
RUN pip install safetensors
RUN pip install transformers

COPY requirements.txt /

RUN pip install -r requirements.txt \
  --extra-index-url https://download.pytorch.org/whl/cu118

RUN useradd -m huggingface

USER huggingface

WORKDIR /home/huggingface

ENV USE_TORCH=1

RUN mkdir -p /home/huggingface/.cache/huggingface \
  && mkdir -p /home/huggingface/input \
  && mkdir -p /home/huggingface/output

COPY docker-entrypoint.py /usr/local/bin
COPY token.txt /home/huggingface

ENTRYPOINT [ "docker-entrypoint.py" ]
