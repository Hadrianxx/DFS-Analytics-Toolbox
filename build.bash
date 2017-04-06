#! /bin/bash

export HOST_PROJECT_HOME=~/dfs_project_home
sudo docker-compose -f build.yml up --build
