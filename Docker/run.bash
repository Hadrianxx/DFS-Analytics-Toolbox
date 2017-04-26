#! /bin/bash -v

export HOST_PROJECT_HOME=~/dfs_project_home
docker run -it --rm \
  -u dfstools \
  -p 8888:8888 \
  -v $HOST_PROJECT_HOME:/home/dfstools/Projects \
  docker.io/znmeb/dfstools:latest \
  /Scripts/dfstools-startup.bash
