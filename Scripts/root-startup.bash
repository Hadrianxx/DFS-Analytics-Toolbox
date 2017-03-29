#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

echo "DFSTOOLS_HOME is $DFSTOOLS_HOME"
chown -R dfstools:dfstools $DFSTOOLS_HOME
ls -Altr $DFSTOOLS_HOME
su dfstools -c '/usr/local/src/Scripts/dfstools-startup.bash'
