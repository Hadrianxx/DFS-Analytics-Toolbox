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
The Docker image contains the platform software and a user home directory. You can run the service and upload and download notebooks while the service is running, but Docker doesn't retain data after the container exits. So I've found that a persistent workspace shared with the host is convenient.

    During the image build, Docker creates a full Jupyter notebook server virtual environment in the `dfstools` user's home directory `/home/dfstools`. Docker also creates a directory `/home/dfstools/Projects` and defines it as a `VOLUME` - a mount point in Linux terminology.

    At run time, Docker can mount a host directory onto this `Projects` directory; this is a `bind-mount`. As a result, both the software running in the container and any software running on the host see the same contents in this directory. A notebook user will see it as the `Projects` directory on the Jupyter home tab.

## Usage
1. Open a terminal / command line window on your Docker host. Edit the file `DFS-Analytics-Toolbox/Docker/run.bash`; change the directory in the `export` statement to the directory you want to use for your persistent `Projects` workspace.

2. `cd DFS-Analytics-Toolbox/Docker; ./run.bash`. Docker will pull the image from the Docker Hub repository <https://hub.docker.com/r/znmeb/dfstools/> if it's not on your machine, then run it in the `dfstools` container. The current image is about 1.1 GB.

3. When the notebook server is ready, you'll see a line like

    ```
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=22e42a31c96fed8371b416301fce2f1facf68698c9196032
    ```

    Open the URL in your browser and you'll be using the notebook server. On my GNOME terminal, you can right-click on the lick and select "Open Link"!

4. Verifying that everything works:

    * Press the "New" button and verify that you can start a new Julia, Python 3 and R notebook.
    * Press the "New" button and verify that you can start a new Terminal session.
    * Create and edit a file in the "Projects" folder and verify that the file is mirrored in the host directory that's mounted on "Projects" in the container.
    * Go to the `IPython Clusters` tab and verify that you can start and stop the cluster engines.

5. When you're done, log out of all your notebook browser windows / tabs and press `CTRL-C` in the terminal. The notebook server will shut down. Your workspace will be saved to the host directory specified by `HOST_PROJECT_HOME`. To restart the notebook server, just `cd DFS-Analytics-Toolbox/Docker; ./run.bash` again.

## What's in the box?
* Licensing: this repository is MIT licensed. However, many of the components have other licenses.
* [Ubuntu 16.04.x LTS "Xenial Xerus"](https://store.docker.com/images/414e13de-f1ba-40d0-9867-08f2e5884b3f?tab=description)
* [Python `virtualenvwrapper`](https://virtualenvwrapper.readthedocs.io/en/latest/)
* [R repositories from CRAN's Ubuntu page](https://cran.r-project.org/bin/linux/ubuntu/)
* R, [devtools](https://github.com/hadley/devtools), and the [R kernel for Jupyter notebooks](https://irkernel.github.io/)
* Julia from the [Julia binary download page](http://julialang.org/downloads/) and [the `IJulia` kernel Julia package](https://github.com/JuliaLang/IJulia.jl)
* A `dfstools` virtual environment in the `dfstools` home directory containing
    * [Jupyter notebook server](https://jupyter.org/) with Python 3, R and Julia kernels, and
    * [ipyparallel](http://ipyparallel.readthedocs.io/en/latest/).

Note that the only TeXLive / LaTeX installed is those pieces that come in as dependencies of `R`. So there will be some PDFs you can't generate via R, and the notebook download-as-pdf won't work. But all the HTML documents you can make with the notebooks should work; if they don't, file an issue.

## Building the image locally
If you want to build the image locally instead of pulling it from Docker Hub, open a terminal on the Docker host and enter `cd DFS-Analytics-Toolbox/Docker; ./build.bash`.

## TBD (sort of prioritized)
1. Docker for Windows (Windows 10 Pro Hyper-V) hosting test / documentation
1. Docker via VirtualBox hosting test / documentation
1. Your feature here! <https://github.com/znmeb/DFS-Analytics-Toolbox/issues/new>
1. [PostgreSQL](https://store.docker.com/images/022689bf-dfd8-408f-9e1c-19acac32e57b?tab=description) back end
1. [Redis](https://store.docker.com/images/1f6ef28b-3e48-4da1-b838-5bd8710a2053?tab=description) back end
1. And, of course, actual DFS analytics content!

## Patreon link
I'm on Patreon now - link is <https://www.patreon.com/znmeb>
