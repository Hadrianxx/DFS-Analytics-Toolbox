#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

echo "SPORTSDSL_HOME is $SPORTSDSL_HOME"
echo "WORKON_HOME is $WORKON_HOME"
if [ ! -e $WORKON_HOME ]
then
  echo "$WORKON_HOME does not exist - initializing $SPORTSDSL_HOME"
  tar xf $SPORTSDSL_HOME_TARBALL --strip-components=2 --directory=$SPORTSDSL_HOME
  chown -R sportsdsl:sportsdsl $SPORTSDSL_HOME
else
  echo "$WORKON_HOME exists - not modifying $SPORTSDSL_HOME"
fi
ls -Altr $SPORTSDSL_HOME
su sportsdsl -c /usr/local/src/Scripts/sportsdsl-startup.bash
