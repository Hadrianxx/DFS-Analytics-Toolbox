#! /bin/bash -v

export JULIA_TARBALL=https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz \
  && curl -Ls $JULIA_TARBALL | sudo tar xfz - --strip-components=1 --directory=/usr/local \
  && julia -e 'Pkg.update(); Pkg.add("IJulia")'
~/.julia/v0.5/Conda/deps/usr/bin/conda create --name jupyter python=3 --yes jupyter r-irkernel
cat jupyter-aliases >> ~/.bashrc
