# Latex docker container

This container helps compiling latex sources without the need to install all latex packages on your system.

## Why should I use this container?

- Easy setup, compile immediately after image download
- Preserves UID and GID of local user
- Use container like local command: `latexdockercmd.sh pdflatex main.tex`
- Multiple distributions like ubuntu's `texlive-full` to cover all needs

## Versions

All versions are based on Ubuntu: ([See all tags](https://github.com/mbogochow/latex-docker/pkgs/container/latex))

- [mbogochow/latex:ubuntu - Dockerfile.ubuntu (ubuntu stage)](Dockerfile.ubuntu) Ubuntu TexLive distribution: Old but stable, most needed package: texlive-full (4.2GB)
- [mbogochow/latex:scientific - Dockerfile.ubuntu (scientific stage)](Dockerfile.ubuntu) Ubuntu TexLive distribution plus scientific packages (GB)
- [mbogochow/latex:minimal - Dockerfile (minimal stage)](Dockerfile) CTAN TexLive Scheme-minimal: minimal packages, base for custom builds (135MB)
- [mbogochow/latex:basic - Dockerfile (basic stage)](Dockerfile) CTAN TexLive Scheme-basic: only basic packages (218MB)
- [mbogochow/latex:small - Dockerfile (small stage)](Dockerfile) CTAN TexLive Scheme-small: only essential packages (326MB)
- [mbogochow/latex:medium - Dockerfile (medium stage)](Dockerfile) CTAN TexLive Scheme-medium: common packages (MB)
- [mbogochow/latex:full - Dockerfile (full stage)](Dockerfile) CTAN TexLive Scheme-full: all packages (GB)

If you need...

- ...the most-stuff-works-out-of-the-box package, try `mbogochow/latex:ubuntu`.
- ...the most recent version of everything, try `mbogochow/latex:full`.
- ...a stable base for your custom texlive build, try `mbogochow/latex:basic`.

For stability, choose a more specific version tag ([See all tags](https://github.com/mbogochow/latex-docker/pkgs/container/latex))

## Quick Setup

Compile latex sources using docker:

```bash
# Change to your project
cd my_latex_project

# Download the command wrapper and make it executable
wget https://raw.githubusercontent.com/mbogochow/latex-docker/master/latexdockercmd.sh
chmod +x latexdockercmd.sh

# Optional: Change the version (see above, default mbogochow/latex-ubuntu)
edit ./latexdockercmd.sh

# Compile using pdflatex (docker will pull the image automatically)
./latexdockercmd.sh pdflatex main.tex

# Or use latexmk (best option)
./latexdockercmd.sh latexmk -cd -f -interaction=batchmode -pdf main.tex
# Cleanup: ./dockercmd.sh latexmk -c or -C

# Or make multiple passes (does not start container twice)
../latexdockercmd.sh /bin/sh -c "pdflatex main.tex && pdflatex main.tex"

# Alternateve: add the following alias to your shell rc file
alias texdoc='docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data "ghcr.io/mbogochow/latex:ubuntu"'
```

## Requirements

First, add your local user to docker group (should already be the case):

```bash
sudo usermod -aG docker YOURUSERNAME
```

The `latexdockercmd.sh` will use your current user and group id to compile.

## Daemon setup

If you're working on source in latex, you might want to compile it multiple times and don't want to start a container each time.

```
cd my_latex_source

# Start a daemon container on this path, it accepts commands from latexdockerdaemoncmd.sh
latexdockerdaemon.sh

# Execute the command in the daemon container, only the daemon container is running
latexdockerdaemoncmd.sh pdflatex main.tex

# Stop the daemon
docker stop latex_daemon
```

## Customize

If you need additional packages, extend this base image with your own customizations. Below are some example recipes for common setups that you can use as a starting point for your custom Dockerfile:

```dockerfile
# Remember to change your base version if needed
FROM ghcr.io/mbogochow/latex:ubuntu

# Example 1: Installing Minted + Pygments for code highlighting
RUN tlmgr install minted
RUN apt-get update \
    && apt-get install -qy python python-pip \
    && pip install pygments \
    && rm -rf /var/lib/apt/lists/*
```

You can create your own Dockerfile using any of these recipes or combine them based on your needs.

Build your custom image:

```bash
docker build -t mycustomlateximg .
```

Edit `latexdockercmd.sh` to use your image `mycustomlateximg`.

## Latex Make

Clean build using `latexmk`:

```
mkdir out
latexmk -cd -f -jobname=output -outdir=out -auxdir=out -interaction=batchmode -pdf ./main.tex
```

## CTAN Packages

A list of available ctan packages can be found here: [http://mirror.ctan.org/systems/texlive/tlnet/archive](http://mirror.ctan.org/systems/texlive/tlnet/archive)

Install texlive packages:

```
RUN tlmgr install minted
```
