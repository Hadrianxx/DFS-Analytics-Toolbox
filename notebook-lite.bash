#! /bin/bash -v

export JULIA_TARBALL=https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz \
  && curl -Ls $JULIA_TARBALL | sudo tar xfz - --strip-components=1 --directory=/usr/local \
  && julia -e 'Pkg.update(); Pkg.add("IJulia")'
export CONDA_BINARIES=$HOME/.julia/v0.5/Conda/deps/usr/bin
export PATH=$CONDA_BINARIES:$PATH
conda create --name jupyter --yes python=3 \
  jupyter \
  r-devtools \
  r-irkernel \
  r-roxygen2 \
  r-tidyverse
source activate jupyter > /dev/null 2>&1
cat jupyter-aliases >> ~/.bashrc
