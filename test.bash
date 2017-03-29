#! /bin/bash

export HOST_PROJECT_HOME=~/snarfblatt
docker-compose down
rm -fr $HOST_PROJECT_HOME
docker-compose up --build
