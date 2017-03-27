#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

source $VIRTUALENVWRAPPER_SCRIPT \
  && mkvirtualenv --python=/usr/bin/python3 julia \
  && pip3 install --upgrade pip \
  && pip install jupyter nbpresent ipyparallel \
  && jupyter nbextension install nbpresent --py --overwrite --user \
  && jupyter nbextension enable nbpresent --py --user \
  && jupyter serverextension enable nbpresent --py \
  && jupyter nbextension install ipyparallel --py --overwrite --user \
  && jupyter nbextension enable ipyparallel --py --user \
  && jupyter serverextension enable ipyparallel --py \
  && julia -e 'Pkg.add("IJulia")' \
  && R -e 'IRkernel::installspec()'
