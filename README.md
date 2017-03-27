# DFS Analytics Toolbox - dfstools

## Quick start
1. Install Git and a Docker host. You will need both `docker` and `docker-compose`. I regularly test with Docker for Windows on Windows 10 Pro and on Fedora Linux 25 with the Fedora-provided Docker. This should work with any `docker` 1.12.6 or later and `docker-compose` 1.9.0 or later.
2. Open a terminal / command line window on your Docker host. Type

    ```
    git clone https://github.com/znmeb/DFS-Analytics-Toolbox.git
    cd DFS-Analytics-Toolbox
    docker-compose up
    ```
   `docker-compose` will build the image if it's not on your machine, then bring up the `sportsdsl` service.
3. The image is read-only. You will need to set aside a directory on your Docker host for persistent storage of your work. Do this by setting environment variable `HOST_HOME_DFSTOOLS` to point to a directory on your Docker host.
