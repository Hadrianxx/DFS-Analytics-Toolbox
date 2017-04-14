#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

source $VIRTUALENVWRAPPER_SCRIPT \
  && workon dfstools \
  && jupyter notebook --no-browser --ip=0.0.0.0
