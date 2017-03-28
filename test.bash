#! /bin/bash

source $VIRTUALENVWRAPPER_SCRIPT \
  && workon julia \
  && export HOST_HOME_DFSTOOLS=~/snarfblatt \
  && docker-compose down \
  && rm -fr $HOST_HOME_DFSTOOLS \
  && docker-compose up --build
