#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

source $VIRTUALENVWRAPPER_SCRIPT \
  && workon julia \
  && ipcluster nbextension enable --user \
  && ipython profile create \
  && ipcluster start --daemonize
