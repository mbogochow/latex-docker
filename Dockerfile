FROM ubuntu:noble AS base
LABEL maintainer="Mike Bogochow"

ARG LATEX_UID=1000
ARG LATEX_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q \
    && apt-get install -qy build-essential wget libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Remove ubuntu user/group and create latex user
RUN userdel -r ubuntu || true \
    && groupdel ubuntu || true \
    && groupadd -g ${LATEX_GID} latex \
    && useradd -u ${LATEX_UID} -g latex -m latex

# Install TexLive with scheme-basic
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    mkdir /install-tl-unx; \
    tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile; \
    /install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
    rm install-tl-unx.tar.gz

RUN cd /usr/local/texlive/ \
    && ln -s $(find . -type d -regextype posix-egrep -regex '^./2[0-9]{3}$') current
ENV PATH="/usr/local/texlive/current/bin/x86_64-linux:${PATH}"

ENV HOME=/data
WORKDIR /data

# Install latex packages
RUN tlmgr install latexmk

RUN mkdir -p /data && chown latex:latex /data

USER latex

VOLUME ["/data"]

# Full variant
FROM base AS full
USER root
RUN tlmgr install scheme-full
USER latex