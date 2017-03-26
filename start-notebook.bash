#! /bin/bash

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh \
  && workon julia \
  && jupyter notebook --no-browser --ip=0.0.0.0
