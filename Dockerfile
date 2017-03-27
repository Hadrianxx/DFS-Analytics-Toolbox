# DFSTOOLS - Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

FROM docker.io/ubuntu:xenial
MAINTAINER M. Edward (Ed) Borasky <znmeb@znmeb.net>

# Global environment variables
ENV \
  JULIA_TARBALL=https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz \
  VIRTUALENVWRAPPER_SCRIPT=/usr/share/virtualenvwrapper/virtualenvwrapper.sh \
  VIRTUALENVWRAPPER_PYTHON=/usr/bin/python \
  DFSTOOLS_HOME=/home/dfstools \
  DFSTOOLS_BACKUP=/usr/local/src/dfstools \
  DFSTOOLS_HOME_TARBALL=/usr/local/src/dfstools/dfstools.tgz \
  WORKON_HOME=/home/dfstools/.virtualenvs \
  JUPYTER=/home/dfstools/.virtualenvs/julia/bin/jupyter

# Expose notebook port
EXPOSE 8888

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
  && apt-get update > $LOGFILES/update.log \
  && apt-get upgrade -y > $LOGFILES/upgrade.log \
  && apt-get install -qqy --no-install-recommends \
  build-essential \
  bzip2 \
  curl \
  git \
  python-virtualenv \
  python3-virtualenv \
  r-base \
  r-base-dev \
  software-properties-common \
  vim-tiny \
  virtualenv \
  virtualenvwrapper \
  wget \
  && add-apt-repository -y ppa:marutter/rrutter \
  && add-apt-repository -y ppa:marutter/c2d4u \
  && apt-get update > $LOGFILES/update2.log \
  && apt-get install -qqy --no-install-recommends \
  r-cran-devtools \
  && apt-get clean

# Install the rest of the system-level components
COPY Rprofile.site /etc/R/
RUN \
  R -e "install.packages(c('repr', 'IRdisplay'), quiet = TRUE)" \
  && R -e "devtools::install_github('IRkernel/IRkernel', quiet = TRUE)" \
  && curl -Ls $JULIA_TARBALL | tar xfz - --strip-components=1 --directory=/usr/local \
  && useradd -c "DFS Analytics Toolbox" -u 1000 -s /bin/bash -m dfstools \
  && mkdir -p $DFSTOOLS_BACKUP \
  && chown -R dfstools:dfstools $DFSTOOLS_BACKUP

# Install user components
USER dfstools
WORKDIR $DFSTOOLS_HOME
SHELL [ "/bin/bash", "-c" ]
RUN \
  source $VIRTUALENVWRAPPER_SCRIPT \
  && mkvirtualenv --python=/usr/bin/python3 julia \
  && pip3 install jupyter nbpresent ipyparallel \
  && jupyter nbextension install nbpresent --py --overwrite --user \
  && jupyter nbextension enable nbpresent --py --user \
  && jupyter serverextension enable nbpresent --py \
  && ipcluster nbextension enable --user \
  && julia -e 'Pkg.add("IJulia")' \
  && R -e 'IRkernel::installspec()' \
  && echo "source $VIRTUALENVWRAPPER_SCRIPT" >> ~/.bashrc \
  && echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python" >> ~/.bashrc \
  && tar czf $DFSTOOLS_HOME_TARBALL $DFSTOOLS_HOME

# Collect scripts
USER root
RUN mkdir -p /usr/local/src/Scripts
COPY Scripts/*.bash /usr/local/src/Scripts/
