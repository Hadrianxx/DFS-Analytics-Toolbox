# DFS Analytics Toolbox - dfstools

## Windows 7 or later

### Installation
1. Download and install the latest Julia for Windows from <https://julialang.org/downloads/>
2. Start Julia from the `Start` menu.
3. Type `Pkg.update(); Pkg.add("IJulia")`. This will take some time.
4. Close the Julia window.
5. The `IJulia` install adds an Anaconda command window to the `Start` menu. Open the Anaconda prompt from the `Start` menu.
6. Type `conda create --yes --name jupyter python=3 jupyter r-devtools r-irkernel r-roxygen2 r-tidyverse`. This will also take some time.
7. Close the Anaconda prompt window.

Note that neither the "Clusters" feature nor the "Terminal" feature work on Windows.

### Usage
1. Open the Anaconda prompt and type `activate jupyter`.
2. Type `jupyter notebook`. The default browser will open a notebook.
3. When you're done, press the `Logout` button on any Jupyter tab. Then type `CTRL-C` in the Anaconda prompt window.
4. Close the Anaconda window after the server has shut down.

## Linux desktops

### Installation
1. Install `git` and `sudo` if necessary. Add yourself to the system administrators' group if necessary.
2. Open a terminal and type `git clone https://github.com/znmeb/DFS-Analytics-Toolbox`.
3. Type `cd DFS-Analytics-Toolbox`.
4. Type `./notebook-lite.bash`.

### Usage
1. Open a terminal and type `activate-jupyter; jupyter notebook`. The default browser will open a notebook.
2. When you're done, press the `Logout` button on any Jupyter tab. Then type `CTRL-C` in the terminal window.
4. Close the terminal window after the server has shut down.

## What's in the box?
* Licensing: this repository is MIT licensed. However, many of the components have other licenses.
* Julia from the [Julia binary download page](http://julialang.org/downloads/),
* Miniconda2 (the Python 2.7 one that Julia installs), and
* A `jupyter` Conda environment containing the [Jupyter notebook server](https://jupyter.org/) with Python 3, R and Julia kernels.

## Patreon link
I'm on Patreon now - link is <https://www.patreon.com/znmeb>

## Road map
If you've been here before, you may be wondering what happened to all the grand plans about Docker images. Briefly, it works fine on Linux hosts and that code is still here in the Docker directory. I'm still maintaining it and it's close to what I use on a daily basis.

However, it turns out to be a gigantic hassle to install Docker hosting on Windows. For openers, there are two versions:
1. The new Docker Community Edition, which only works on Windows 10 Pro with Hyper-V, and
2. The old Docker Toolbox, which runs on Windows 7 or later and carries VirtualBox and Git for Windows.

I've gotten the Docker image to work a few times with the Windows 10 Pro / Docker Community Edition setup, but I had so many mysterious hangs that I gave up on troubleshooting it and dropped back to the Julia / Anaconda solution you see here. When I get some free time I'll dig into what's happening on Windows; it may just be that my laptop is under-powered for this image.

So what's next?

1. Notebooks! I'm going to be porting my RStudio-based operations to the Jupyter environment.
2. There will be an R package coming out of this. Jupyter's not the best tooling for package development, but it can be done. The package will live in this repository.
3. New code in Julia - some of the things I want to do don't really make sense in R. Julia has some simple and elegant constructs that are hard to find in R. And of course, there's the "if you're careful about types, Julia code is as fast as Fortran or C" bit.
4. Speaking of RStudio, there's no reason you can't have both Jupyter and RStudio using the same version of R. It's just a matter of pointing RStudio to Jupyter's R executable and setting up all the library paths right. 

    If there's interest I'll add the directions; the tricky part is making sure the R library pointers work the same way for Jupyter and RStudio. However, I will not be publishing any more RStudio-based Docker images. There are enough good ones out there now that it's a waste of effort.
