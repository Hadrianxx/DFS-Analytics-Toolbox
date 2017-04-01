#! /bin/bash

export HOST_PROJECT_HOME=~/dfs_project_home
docker-compose -f build.yml up --build
