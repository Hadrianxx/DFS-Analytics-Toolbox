# Copyright (C) 2016 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

FROM docker.io/ubuntu:xenial
MAINTAINER M. Edward (Ed) Borasky <znmeb@znmeb.net>

# Home base
USER root
RUN mkdir -p /usr/local/src/
WORKDIR /usr/local/src/

# Force "bash" shell - Conda doesn't work with "sh"
RUN ln -f /bin/bash /bin/sh

# Set up locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_US.UTF-8
RUN update-locale LC_CTYPE=en_US.UTF-8
RUN update-locale LC_NUMERIC=en_US.UTF-8
RUN update-locale LC_TIME=en_US.UTF-8
RUN update-locale LC_COLLATE=en_US.UTF-8
RUN update-locale LC_MONETARY=en_US.UTF-8
RUN update-locale LC_MESSAGES=en_US.UTF-8
RUN update-locale LC_PAPER=en_US.UTF-8
RUN update-locale LC_NAME=en_US.UTF-8
RUN update-locale LC_ADDRESS=en_US.UTF-8
RUN update-locale LC_TELEPHONE=en_US.UTF-8
RUN update-locale LC_MEASUREMENT=en_US.UTF-8
RUN update-locale LC_IDENTIFICATION=en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8

# Install base Ubuntu packages
RUN apt-get update \
  && apt-get install -qqy --no-install-recommends \
  build-essential \
  bzip2 \
  curl \
  software-properties-common \
  wget \
  && apt-get clean

# Install Julia
ENV JULIA_TARBALL https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
RUN curl -Ls $JULIA_TARBALL | tar xfz - --strip-components=1 --directory=/usr/local

# Create non-root user for day-to-day work
RUN useradd -c "Introduction to Julia" -u 1000 -s /bin/bash -m i2julia

# Install notebook start script
COPY start-notebook.bash /home/i2julia/
RUN chmod +x /home/i2julia/start-notebook.bash
RUN chown -R i2julia:i2julia /home/i2julia

# Drop root
USER i2julia
WORKDIR /home/i2julia

# Install Miniconda
# http://conda.pydata.org/miniconda.html
# https://repo.continuum.io/miniconda
ENV MINICONDA_REPO=https://repo.continuum.io/miniconda
ENV MINICONDA_INSTALLER Miniconda3-latest-Linux-x86_64.sh
ENV MINICONDA_PATH /home/i2julia/miniconda3/bin
RUN wget -q $MINICONDA_REPO/$MINICONDA_INSTALLER \
  && bash $MINICONDA_INSTALLER -b \
  && rm $MINICONDA_INSTALLER
ENV PATH $MINICONDA_PATH:$PATH
RUN conda update --yes --all

# Create environment with Jupyter and notebook presentation editor
RUN conda create --name julia jupyter nbpresent

# Install IJulia in the new environment
ENV JUPYTER $MINICONDA_PATH/../envs/julia/bin/jupyter
RUN source activate julia && julia -e 'Pkg.add("IJulia")'

# Expose notebook port
EXPOSE 8888
