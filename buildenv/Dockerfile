FROM ubuntu:latest

LABEL maintainer="c.lobrano@gmail.com"

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y \
        bash \
        binutils \
        bison \
        bzip2 \
        coreutils \
        diffutils \
        findutils \
        gawk \
        gcc \
        g++ \
        libc6 \
        grep \
        gzip \
        m4 \
        make \
        patch \
        perl \
        python3 \
        sed \
        tar \
        texinfo \
        xz-utils

WORKDIR /workspace
ENTRYPOINT ["bash"]

