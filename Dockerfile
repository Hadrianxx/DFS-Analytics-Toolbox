# DFSTOOLS - Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

FROM docker.io/ubuntu:xenial
MAINTAINER M. Edward (Ed) Borasky <znmeb@znmeb.net>

# Set up locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
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

# Configure repos for R and packages
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Install Ubuntu packages
RUN apt-get update > $LOGFILES/update.log \
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
  && apt-get clean
RUN add-apt-repository -y ppa:marutter/rrutter \
  && add-apt-repository -y ppa:marutter/c2d4u \
  && apt-get update > $LOGFILES/update2.log \
  && apt-get install -qqy --no-install-recommends \
  r-cran-devtools \
  && apt-get clean

# Install R packages
COPY Rprofile.site /etc/R/
RUN R -e "install.packages(c('repr', 'IRdisplay'), quiet = TRUE)"
RUN R -e "devtools::install_github('IRkernel/IRkernel', quiet = TRUE)"

# Install Julia
ENV JULIA_TARBALL https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
RUN curl -Ls $JULIA_TARBALL | tar xfz - --strip-components=1 --directory=/usr/local

# Expose notebook port
EXPOSE 8888

# Create non-root user for day-to-day work
RUN useradd -c "DFS Analytics Toolbox" -u 1000 -s /bin/bash -m dfstools

# Define virtualenvwrapper environment variables
ENV VIRTUALENVWRAPPER_SCRIPT /usr/share/virtualenvwrapper/virtualenvwrapper.sh
ENV VIRTUALENVWRAPPER_PYTHON /usr/bin/python
ENV DFSTOOLS_HOME /home/dfstools
ENV WORKON_HOME $DFSTOOLS_HOME/.virtualenvs

# Install the notebook services
USER dfstools
WORKDIR $DFSTOOLS_HOME
SHELL [ "/bin/bash", "-c" ]
RUN source $VIRTUALENVWRAPPER_SCRIPT \
  && mkvirtualenv --python=/usr/bin/python3 julia \
  && pip3 install jupyter nbpresent ipyparallel \
  && jupyter nbextension install nbpresent --py --overwrite --user \
  && jupyter nbextension enable nbpresent --py --user \
  && jupyter serverextension enable nbpresent --py \
  && jupyter nbextension install ipyparallel --py --overwrite --user \
  && jupyter nbextension enable ipyparallel --py --user \
  && jupyter serverextension enable ipyparallel --py \
  && julia -e 'Pkg.add("IJulia")' \
  && R -e 'IRkernel::installspec()' \
  && ipython profile create \
  && echo "source $VIRTUALENVWRAPPER_SCRIPT" >> ~/.bashrc

# Save user desktop for restore into host home volume
USER root
ENV DFSTOOLS_HOME_TARBALL /usr/local/src/dfstools.tgz
RUN tar czf $DFSTOOLS_HOME_TARBALL $DFSTOOLS_HOME

# Collect scripts
RUN mkdir -p /usr/local/src/Scripts
COPY Scripts/*.bash /usr/local/src/Scripts/
