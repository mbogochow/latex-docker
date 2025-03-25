FROM alpine:latest AS minimal
LABEL maintainer="Mike Bogochow"

ARG LATEX_UID=1000
ARG LATEX_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN addgroup -g ${LATEX_GID} latex && \
    adduser -u ${LATEX_UID} -G latex -D latex && \
    mkdir -p /data && \
    chown latex:latex /data

RUN apk add --no-cache perl curl fontconfig libgcc gnupg && \
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    mkdir /install-tl-unx && \
    tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1 && \
    ( \
        echo "selected_scheme scheme-minimal" && \
        echo "instopt_adjustpath 0" && \
        echo "tlpdbopt_install_docfiles 0" && \
        echo "tlpdbopt_install_srcfiles 0" \
        # echo "TEXDIR /opt/texlive/" && \
        # echo "TEXMFLOCAL /opt/texlive/texmf-local" && \
        # echo "TEXMFSYSCONFIG /opt/texlive/texmf-config" && \
        # echo "TEXMFSYSVAR /opt/texlive/texmf-var" && \
        # echo "TEXMFHOME ~/.texmf" \
    ) > /install-tl-unx/texlive.profile && \
    /install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile && \
    rm -rf /install-tl-unx && \
    rm install-tl-unx.tar.gz && \
    ln -s $(find /usr/local/texlive -type d -maxdepth 1 -regex '^.*\d\{4\}$') /usr/local/texlive/current && \
    /usr/local/texlive/current/bin/x86_64-linuxmusl/tlmgr install latexmk && \
    apk del libgcc

ENV PATH="/usr/local/texlive/current/bin/x86_64-linuxmusl:${PATH}"

USER latex

WORKDIR /data
VOLUME ["/data"]

########################################################
# Small variant
FROM minimal AS small
USER root
RUN tlmgr install scheme-small
USER latex

########################################################
# Basic variant
FROM minimal AS basic
USER root
RUN tlmgr install scheme-basic
USER latex

########################################################
# Medium variant
FROM minimal AS medium
USER root
RUN tlmgr install scheme-medium
USER latex

########################################################
# Full variant
FROM minimal AS full
USER root
RUN tlmgr install scheme-full
USER latex