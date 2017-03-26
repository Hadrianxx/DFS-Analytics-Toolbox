#! /bin/bash

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh \
  && workon julia \
  && ipcluster nbextension enable --user \
  && ipcluster start