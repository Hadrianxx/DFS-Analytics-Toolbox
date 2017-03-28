# DFS Analytics Toolbox - dfstools

## Preparation
1. Install Git and a Docker host. You will need both `docker` and `docker-compose`. I regularly test with Docker for Windows on Windows 10 Pro and on Fedora Linux 25 with the Fedora-provided `docker` and `docker-compose`. This should work with any `docker` 1.12.6 or later and `docker-compose` 1.9.0 or later.
2. The Docker image is "read-only" - it contains the platform software and a user home workspace, but it does not retain data after the container running it shuts down. You can always upload and download notebooks, but a persistent workspace shared with the host is more convenient.

    The DFS Analytics Toolbox mounts a host directory onto the home directory of the container user `dfstools` user ID 1000. On a Linux host, type `export HOST_HOME_DFSTOOLS="your workspace directory"` before bringing up the service. For example, on my test runs I use `export HOST_HOME_DFSTOOLS="~/snarfblatt".

    If the directory does not exist, `docker-compose` will create a new empty one. If it is empty when the service starts, a script will initialize it with the required software before starting the notebook server. Otherwise, the notebook server will use whatever's there.

## Running
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

3. When you're done, log out of all your notebook browser windows / tab and press `CTRL-C` in the terminal. The notebook server will shut down. To restart it, just make sure the `HOST_HOME_DFSTOOLS` environment variable is set and type `docker-compose up`.
