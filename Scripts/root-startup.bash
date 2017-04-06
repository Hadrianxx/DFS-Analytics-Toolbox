#! /bin/bash
# Copyright (C) 2017 M. Edward (Ed) Borasky <znmeb@znmeb.net>
# License: MIT

chown -R dfstools:dfstools /home/dfstools
su dfstools -c /Scripts/dfstools-startup.bash
