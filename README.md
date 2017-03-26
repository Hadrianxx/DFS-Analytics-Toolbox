# Sports Data Science Lab - Docker image

## Quick start
1. Install Git and a Docker host. You will need both `docker` and `docker-compose`. I regularly test with Docker for Windows on Windows 10 Pro and on Fedora Linux 25 with the Fedora-provided Docker. This should work with any Docker host at release 1.12 or later.
2. Open a terminal / command line window on your Docker host. Type

    ```
    git clone https://github.com/znmeb/sports-data-science-lab.git
    cd sports-data-science-lab
    docker-compose up
    ```
   `docker-compose` will build the image if it's not on your machine, then bring up the `i2julia` service.
