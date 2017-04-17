# DFS Analytics Toolbox - dfstools

## Linux hosting
1. Install a Linux workstation from one of the following that I support:

    * CentOS 7,
    * Fedora 25,
    * Debian "jessie", or
    * Ubuntu "Xenial Xerus".

    Make sure you've made yourself an administrator on Fedora and CentOS during the install. You'll be an administrator by default on Ubuntu. 

    On Debian, you will be asked if you want to allow `root` logins. At this point, say `No` and you'll be set up as an administrator.

2. When the install is done, update all the software to the latest packages and then reboot. All four have a "Software" application that you can use for this rather than doing it on the command line.

3. After the reboot, install both "git" and "sudo" if they aren't installed already. Then make sure you're in the systemm administration group. On CentOS and Fedora this is "wheel" and on Debian and Ubuntu it's "sudo". You should be in the group already, but you should check it.

4. If you had to add yourself to the administration group, log out and back in again. Just opening a new terminal won't work; you'll need to log out to the display manager and back in again.

5. Open a terminal window and type

    ```
    git clone https://github.com/znmeb/DFS-Analytics-Toolbox
    cd DFS-Analytics-Toolbox/Docker
    ./<OS>-docker-hosting
    ```

    where <OS> is `centos7`, `fedora25`, `debian` or `ubuntu`.

## Windows 10 Pro / Docker for Windows hosting
TBD

## Windows 7+ Docker Toolbox hosting
TBD

## The persistent workspace mechanism
The Docker image contains the platform software and a user home directory. You can run the service and upload and download notebooks while the service is running, but `docker-compose` doesn't retain data after it shuts the service down. I've found that a persistent workspace shared with the host is more convenient.

    During the image build, `docker` creates a full Jupyter notebook server virtual environment in the `dfstools` user's home directory. `docker` also creates a `VOLUME` - a mount point in Linux terminology - which the notebook user will see as the `Projects` directory on the Jupyter home tab.

    At run time, `docker-compose` mounts a host directory onto this `Projects` directory. This is a `bind-mount`. As a result, both the software running in the container and any software running on the host see the same contents in this directory.

    When `docker-compose` brings up the service, it looks at the environment variable `HOST_PROJECT_HOME` to get the host directory name. For example, on my test runs I use `export HOST_PROJECT_HOME="~/dfs_project_home"`. If the host directory does not exist, `docker-compose` will create a new empty one.

## Usage
1. Open a terminal / command line window on your Docker host. Type

    ```
    cd DFS-Analytics-Toolbox
    export HOST_PROJECT_HOME="your host projects directory"
    sudo docker-compose up
    ```

   `docker-compose` will pull the image from the Docker Hub repository <https://hub.docker.com/r/znmeb/dfstools/> if it's not on your machine, then bring up the `dfstools` service. The current image is about 1.1 GB.

2. When the notebook server is ready, you'll see a line like

    ```
    dfstools_1  |     Copy/paste this URL into your browser when you connect for the first time,
    dfstools_1  |     to login with a token:
    dfstools_1  |         http://0.0.0.0:8888/?token=60cf8c8638b19454b02f603f3b7ea8420ee1eb7c5841a381
    ```

    Open the URL in your browser and you'll be using the notebook server. On my GNOME terminal, you can right-click on the lick and select "Open Link"!

3. Verifying that everything works

    * Press the "New" button and verify that you can start a new Julia, Python 3 and R notebook.
    * Press the "New" button and verify that you can start a new Terminal session.
    * Create and edit a file in the "Projects" folder and verify that the file is mirrored in the host directory that's mounted on "Projects" in the container.
    * Go to the `IPython Clusters` tab and verify that you can start and stop the cluster engines.

3. When you're done, log out of all your notebook browser windows / tabs and press `CTRL-C` in the terminal. The notebook server will shut down. Your workspace will be saved to the host directory specified by `HOST_PROJECT_HOME`. To restart the notebook server, just make sure the `HOST_PROJECT_HOME` environment variable is set and type `docker-compose up`.

## What's in the box?
* Licensing: this repository is MIT licensed. However, many of the components have other licenses.
* [Ubuntu 16.04.x LTS "Xenial Xerus"](https://store.docker.com/images/414e13de-f1ba-40d0-9867-08f2e5884b3f?tab=description)
* [Python `virtualenvwrapper`](https://virtualenvwrapper.readthedocs.io/en/latest/)
* [R repositories from CRAN's Ubuntu page](https://cran.r-project.org/bin/linux/ubuntu/)
* R, [devtools](https://github.com/hadley/devtools), and the [R kernel for Jupyter notebooks](https://irkernel.github.io/)
* Julia from the [Julia binary download page](http://julialang.org/downloads/) and [the `IJulia` kernel Julia package](https://github.com/JuliaLang/IJulia.jl)
* A `dfstools` virtual environment in the `dfstools` home directory containing
    * [Jupyter notebook server](https://jupyter.org/) with Python 3, R and Julia kernels
    * A working [IPython Clusters](https://ipyparallel.readthedocs.io/en/latest/) tab!

Note that the only TeXLive / LaTeX installed is those pieces that come in as dependencies of `R`. So there will be some PDFs you can't generate via R, and the notebook download-as-pdf won't work. But all the HTML documents you can make with the notebooks should work; if they don't, file an issue. And it's a one-line command to install TeXLive if you need it.

## Building the image locally
If you want to build the image locally instead of pulling it from Docker Hub, open a terminal on the Docker host and enter

    ```
    cd DFS-Analytics-Toolbox
    export HOST_PROJECT_HOME="your host projects directory"
    sudo docker-compose -f build.yml up --build
    ```

## TBD (sort of prioritized)
1. Docker for Windows (Windows 10 Pro Hyper-V) hosting test / documentation
1. Docker via VirtualBox hosting test / documentation
1. Your feature here! <https://github.com/znmeb/DFS-Analytics-Toolbox/issues/new>
1. [PostgreSQL](https://store.docker.com/images/022689bf-dfd8-408f-9e1c-19acac32e57b?tab=description) back end
1. [Redis](https://store.docker.com/images/1f6ef28b-3e48-4da1-b838-5bd8710a2053?tab=description) back end
1. And, of course, actual DFS analytics content!

## Patreon link
I'm on Patreon now - link is <https://www.patreon.com/znmeb>
