# DFSTOOLS - Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

FROM docker.io/ubuntu:xenial
MAINTAINER M. Edward (Ed) Borasky <znmeb@znmeb.net>

# Set up locales
RUN \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8 \
  && update-locale LC_CTYPE=en_US.UTF-8 \
  && update-locale LC_NUMERIC=en_US.UTF-8 \
  && update-locale LC_TIME=en_US.UTF-8 \
  && update-locale LC_COLLATE=en_US.UTF-8 \
  && update-locale LC_MONETARY=en_US.UTF-8 \
  && update-locale LC_MESSAGES=en_US.UTF-8 \
  && update-locale LC_PAPER=en_US.UTF-8 \
  && update-locale LC_NAME=en_US.UTF-8 \
  && update-locale LC_ADDRESS=en_US.UTF-8 \
  && update-locale LC_TELEPHONE=en_US.UTF-8 \
  && update-locale LC_MEASUREMENT=en_US.UTF-8 \
  && update-locale LC_IDENTIFICATION=en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8

# Install base Ubuntu packages
RUN \
  echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -qqy --no-install-recommends \
  build-essential \
  bzip2 \
  curl \
  git \
  python-dev \
  python3-dev \
  python-pip \
  python3-pip \
  python-setuptools \
  python3-setuptools \
  r-base \
  r-base-dev \
  software-properties-common \
  vim-tiny \
  wget \
  && add-apt-repository -y ppa:marutter/rrutter \
  && add-apt-repository -y ppa:marutter/c2d4u \
  && apt-get update \
  && apt-get install -qqy --no-install-recommends \
  r-cran-broom \
  r-cran-devtools \
  r-cran-dplyr \
  r-cran-forcats \
  r-cran-ggplot2 \
  r-cran-haven \
  r-cran-httr \
  r-cran-hms \
  r-cran-jsonlite \
  r-cran-lubridate \
  r-cran-magrittr \
  r-cran-modelr \
  r-cran-purrr \
  r-cran-readr \
  r-cran-readxl \
  r-cran-stringr \
  r-cran-tibble \
  r-cran-rvest \
  r-cran-tidyr \
  r-cran-xml2 \
  && apt-get clean

# Python virtual environment / project manager
RUN \
  pip install --upgrade pip \
  && pip install virtualenvwrapper

# Install the rest of the system-level components
COPY Rprofile.site /etc/R/
ENV JULIA_TARBALL=https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
RUN \
  R -e "install.packages(c('tidyverse', 'repr', 'IRdisplay'), quiet = TRUE)" \
  && R -e "devtools::install_github('IRkernel/IRkernel', quiet = TRUE)" \
  && curl -Ls $JULIA_TARBALL | tar xfz - --strip-components=1 --directory=/usr/local \
  && useradd -c "DFS Analytics Toolbox" -u 1000 -s /bin/bash -m dfstools

# Install user components
ENV \
  DFSTOOLS_HOME=/home/dfstools \
  VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh \
  PROJECT_HOME=home/dfstools/Projects \
  WORKON_HOME=/home/dfstools/.virtualenvs \
  JUPYTER=/home/dfstools/.virtualenvs/dfstools/bin/jupyter
USER dfstools
WORKDIR $DFSTOOLS_HOME
RUN mkdir -p $PROJECT_HOME
SHELL [ "/bin/bash", "-c" ]
RUN \
  source $VIRTUALENVWRAPPER_SCRIPT \
  && mkvirtualenv --python=/usr/bin/python3 dfstools \
  && pip3 install jupyter nbpresent ipyparallel RISE virtualenvwrapper \
  && jupyter nbextension install nbpresent --py --overwrite --user \
  && jupyter nbextension enable nbpresent --py --user \
  && jupyter serverextension enable nbpresent --py \
  && ipcluster nbextension enable --user \
  && jupyter nbextension install rise --py --overwrite --user \
  && jupyter nbextension enable rise --py --user \
  && julia -e 'Pkg.add("IJulia")' \
  && R -e 'IRkernel::installspec()' \
  && echo "source $VIRTUALENVWRAPPER_SCRIPT" >> ~/.bashrc

# Collect scripts
USER root
RUN mkdir -p /Scripts
COPY Scripts/*.bash /Scripts/

# Expose notebook port and declare volume
ENV NOTEBOOK_PORT=8888
EXPOSE $NOTEBOOK_PORT
VOLUME $PROJECT_HOME
