# DFS Analytics Toolbox - dfstools

## Linux hosting
1. Install Git and a Docker host. You will need both `docker` and `docker-compose`. I develop/test on Fedora Linux 25 with the Fedora-provided `docker` and `docker-compose`. This should work with any `docker` 1.12.6 or later and `docker-compose` 1.9.0 or later.

2. The Docker image is "read-only" - it contains the platform software and a user home workspace, but doesn't retain data after the container shuts down. You can upload and download notebooks, but a persistent workspace shared with the host is more convenient.

    The DFS Analytics Toolbox mounts a host directory onto the home directory of the container user `dfstools` user ID 1000. The `docker-compose` step looks at the environment variable `HOST_HOME_DFSTOOLS` to get the directory name. For example, on my test runs I use `export HOST_HOME_DFSTOOLS="~/snarfblatt".

    If the directory does not exist, `docker-compose` will create a new empty one. If it is empty when the service starts, the script `/usr/local/src/Scripts/root-startup.bash` will initialize it with the required software before starting the notebook server. Otherwise, the notebook server will use whatever's there.

3. Open a terminal / command line window on your Docker host. Type

    ```
    git clone https://github.com/znmeb/DFS-Analytics-Toolbox.git
    cd DFS-Analytics-Toolbox
    export HOST_HOME_DFSTOOLS="your workspace directory"
    docker-compose up --build
    ```

   `docker-compose` will build the image if it's not on your machine, then bring up the `dfstools` service. The current image is about 1.2 GB.

4. When the notebook server is ready, you'll see a line like

    ```
    dfstools_1  |     Copy/paste this URL into your browser when you connect for the first time,
    dfstools_1  |     to login with a token:
    dfstools_1  |         http://0.0.0.0:8888/?token=60cf8c8638b19454b02f603f3b7ea8420ee1eb7c5841a381
    ```

    Open the URL in your browser and you'll be using the notebook server. On my GNOME terminal, you can right-click on the lick and select "Open Link"!

5. When you're done, log out of all your notebook browser windows / tab and press `CTRL-C` in the terminal. The notebook server will shut down. To restart it, just make sure the `HOST_HOME_DFSTOOLS` environment variable is set and type `docker-compose up`.

## What's in the box?
* [Ubuntu 16.04.x LTS "Xenial Xerus"](https://store.docker.com/images/414e13de-f1ba-40d0-9867-08f2e5884b3f?tab=description)
* [Python `virtualenvwrapper`](https://virtualenvwrapper.readthedocs.io/en/latest/)
* [R repositories from CRAN's Ubuntu page](https://cran.rstudio.com/bin/linux/ubuntu/)
* R, devtools and the R notebook kernel packages. It does ***not*** have the `tidyverse` yet!
* Julia from the [Julia binary download page](http://julialang.org/downloads/) and [the `IJulia` kernel Julia package](https://github.com/JuliaLang/IJulia.jl)
* A `julia` virtual environment containing
    * [Jupyter notebook server](https://jupyter.org/) with Python 3, R and Julia kernels
    * A working [IPython Clusters](https://ipyparallel.readthedocs.io/en/latest/) tab!
    * The [RISE](https://github.com/damianavila/RISE) and [nbpresent](https://github.com/Anaconda-Platform/nbpresent) slideshow tools

## TBD
1. Docker for Windows hosting test / documentation
2. Add the R tidyverse
3. Tutorial for `nbpresent`
4. PostgreSQL interface
5. Your feature here! <https://github.com/znmeb/DFS-Analytics-Toolbox/issues/new>
6. And, of course, actual DFS analytics content!
