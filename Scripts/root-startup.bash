#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

echo "SDSLAB_HOME is $SDSLAB_HOME"
echo "WORKON_HOME is $WORKON_HOME"
if [ ! -e $WORKON_HOME ]
then
  echo "$WORKON_HOME does not exist - initializing $SDSLAB_HOME"
  tar xf $SDSLAB_HOME_TARBALL --strip-components=2 --directory=$SDSLAB_HOME
else
  echo "$WORKON_HOME exists - not modifying $SDSLAB_HOME"
fi
chown -R sdslab:sdslab $SDSLAB_HOME
ls -Altr $SDSLAB_HOME
su sdslab -c /usr/local/src/Scripts/sdslab-startup.bash
