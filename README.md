# DFS Analytics Toolbox - dfstools

## Linux hosting
Install Git and a Docker host. You will need both `docker` and `docker-compose`. I develop/test on Fedora Linux 25 with the Fedora-provided `docker` and `docker-compose`. This should work with any `docker` 1.12.6 or later and `docker-compose` 1.9.0 or later.

## The persistent workspace mechanism
The Docker image contains the platform software and a user home workspace. You can run the service and upload and download notebooks while the service is running, but `docker-compose` doesn't retain data after it shuts the container down. I've found that a persistent workspace shared with the host is more convenient.

    During the image build, `docker` creates a full Jupyter notebook server virtual environment in the `dfstools` user's home directory. As the last step of this install, `docker` creates a tarball of the `dfstools` user home directory and saves it in the image.

    At run time, `docker-compose` mounts a host directory onto the home directory of the container user `dfstools` user - user ID 1000. This is a `bind-mount`. It doesn't change the files on the image but the software running in the container doesn't see the files on the image. Instead, the software sees the contents of the host directory!

    When `docker-compose` brings up the service, it looks at the environment variable `HOST_HOME_DFSTOOLS` to get the host directory name. For example, on my test runs I use `export HOST_HOME_DFSTOOLS="~/snarfblatt"`. If the host directory does not exist, `docker-compose` will create a new empty one.

    If the host directory is empty when the `dfstools` service starts, the script `/usr/local/src/Scripts/root-startup.bash` will restore it from the tarball before starting the notebook server. Otherwise, the notebook server will use whatever's in the host directory without any changes.

## Usage
1. Open a terminal / command line window on your Docker host. Type

    ```
    git clone https://github.com/znmeb/DFS-Analytics-Toolbox.git
    cd DFS-Analytics-Toolbox
    export HOST_HOME_DFSTOOLS="your workspace directory"
    docker-compose up --build
    ```

   `docker-compose` will build the image if it's not on your machine, then bring up the `dfstools` service. The current image is about 1.2 GB.

2. When the notebook server is ready, you'll see a line like

    ```
    dfstools_1  |     Copy/paste this URL into your browser when you connect for the first time,
    dfstools_1  |     to login with a token:
    dfstools_1  |         http://0.0.0.0:8888/?token=60cf8c8638b19454b02f603f3b7ea8420ee1eb7c5841a381
    ```

    Open the URL in your browser and you'll be using the notebook server. On my GNOME terminal, you can right-click on the lick and select "Open Link"!

3. When you're done, log out of all your notebook browser windows / tabs and press `CTRL-C` in the terminal. The notebook server will shut down. Your workspace will be saved to the host directory specified by `HOST_HOME_DFSTOOLS`. To restart the notebook server, just make sure the `HOST_HOME_DFSTOOLS` environment variable is set and type `docker-compose up`.

## What's in the box?
* Licensing: this repository is MIT licensed. However, many of the components have other licenses.
* [Ubuntu 16.04.x LTS "Xenial Xerus"](https://store.docker.com/images/414e13de-f1ba-40d0-9867-08f2e5884b3f?tab=description)
* [Python `virtualenvwrapper`](https://virtualenvwrapper.readthedocs.io/en/latest/)
* [R repositories from CRAN's Ubuntu page](https://cran.r-project.org/bin/linux/ubuntu/)
* R, [devtools](https://github.com/hadley/devtools), [the `tidyverse`](http://tidyverse.org/) and the R notebook kernel packages
* Julia from the [Julia binary download page](http://julialang.org/downloads/) and [the `IJulia` kernel Julia package](https://github.com/JuliaLang/IJulia.jl)
* A `julia` virtual environment in the `dfstools` home directory containing
    * [Jupyter notebook server](https://jupyter.org/) with Python 3, R and Julia kernels
    * A working [IPython Clusters](https://ipyparallel.readthedocs.io/en/latest/) tab!
    * The [RISE](https://github.com/damianavila/RISE) and [nbpresent](https://github.com/Anaconda-Platform/nbpresent) slideshow tools

## TBD (sort of prioritized)
1. Docker for Windows (Windows 10 Pro Hyper-V) hosting test / documentation
1. Docker Hub autobuild for the image
1. Tutorial for `nbpresent`
1. Docker via VirtualBox hosting test / documentation
1. Your feature here! <https://github.com/znmeb/DFS-Analytics-Toolbox/issues/new>
1. [PostgreSQL](https://store.docker.com/images/022689bf-dfd8-408f-9e1c-19acac32e57b?tab=description) back end
1. [Redis](https://store.docker.com/images/1f6ef28b-3e48-4da1-b838-5bd8710a2053?tab=description) back end
1. Miniconda "port" ... I won't do Miniconda in a Docker image because it's too big, but it makes sense on the desktop.
1. And, of course, actual DFS analytics content!
