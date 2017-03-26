# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

FROM docker.io/ubuntu:xenial
MAINTAINER M. Edward (Ed) Borasky <znmeb@znmeb.net>

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
  virtualenvwrapper \
  wget \
  && apt-get clean

# Install R
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' \
  >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN add-apt-repository -y ppa:marutter/rrutter \
  && add-apt-repository -y ppa:marutter/c2d4u \
  && apt-get update \
  && apt-get install -qqy --no-install-recommends \
  r-base \
  r-base-dev \
  r-cran-devtools \
  && apt-get clean
COPY Rprofile.site /etc/R/
RUN R -e \
  "install.packages(c('repr', 'IRdisplay'), quiet = TRUE)"
RUN R -e \
  "devtools::install_github('IRkernel/IRkernel', quiet = TRUE)"

# Install Julia
ENV JULIA_TARBALL https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
RUN curl -Ls $JULIA_TARBALL | tar xfz - --strip-components=1 --directory=/usr/local

# Expose notebook port
EXPOSE 8888

# Create non-root user for day-to-day work
RUN useradd -c "Sports Data Science Lab" -u 1000 -s /bin/bash -m sportsdsl

# Define virtualenvwrapper environment variables
ENV SPORTSDSL_HOME /home/sportsdsl
ENV WORKON_HOME $SPORTSDSL_HOME/Environments
ENV PROJECT_HOME $SPORTSDSL_HOME/Projects
ENV NOTEBOOK_HOME $SPORTSDSL_HOME/Notebooks

# Collect scripts
RUN mkdir -p /usr/local/src/Scripts
COPY Scripts/*.bash /usr/local/src/Scripts/
