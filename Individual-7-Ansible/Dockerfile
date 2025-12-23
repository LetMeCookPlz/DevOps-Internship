FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir ansible

COPY ./ssh-keys/id_rsa /root/.ssh/id_rsa

WORKDIR /ansible