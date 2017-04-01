#! /bin/bash

export HOST_PROJECT_HOME=~/snarfblatt
docker-compose -f build.yml up --build
