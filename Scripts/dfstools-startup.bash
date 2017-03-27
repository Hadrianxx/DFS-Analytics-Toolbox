#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

echo "DFSTOOLS_HOME is $DFSTOOLS_HOME"
echo "WORKON_HOME is $WORKON_HOME"
if [ ! -e $WORKON_HOME ]
then
  echo "$WORKON_HOME does not exist - initializing $DFSTOOLS_HOME"
  tar xf $DFSTOOLS_HOME_TARBALL --strip-components=2 --directory=$DFSTOOLS_HOME
else
  echo "$WORKON_HOME exists - not modifying $DFSTOOLS_HOME"
fi
chown -R dfstools:dfstools $DFSTOOLS_HOME
ls -Altr $DFSTOOLS_HOME

source $VIRTUALENVWRAPPER_SCRIPT \
  && workon julia \
  && ipython profile create --parallel \
  && jupyter nbextension install nbpresent --py --overwrite --user \
  && jupyter nbextension enable nbpresent --py --user \
  && jupyter serverextension enable nbpresent --py \
  && jupyter nbextension install ipyparallel --py --overwrite --user \
  && jupyter nbextension enable ipyparallel --py --user \
  && jupyter serverextension enable ipyparallel --py \
  && ipcluster nbextension enable --user \
  && ipcluster start --daemonize \
  && jupyter notebook --no-browser --ip=0.0.0.0
