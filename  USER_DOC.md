# USER_DOC.md

# Inception - User Documentation

## Overview

This project deploys a small web infrastructure using Docker Compose. The stack consists of three services:

* **NGINX** – Receives all HTTPS requests on port **443** and forwards PHP requests to WordPress.
* **WordPress (PHP-FPM)** – Hosts the website and executes PHP code.
* **MariaDB** – Stores the WordPress database, including users, posts, pages, and settings.

The services communicate through a private Docker network and use Docker named volumes to persist data.

---

# Starting the Project

From the project root, run:

```bash
make rebuild
```


This command:

* Builds all Docker images.
* Creates the containers.
* Creates the Docker network.
* Creates the persistent volumes.
* Starts all services.

---

# Stopping the Project

To stop all containers:

```bash
make down
```

To remove containers, images, networks:

```bash
make clean
```

---

# Accessing the Website

Add the following entry to `/etc/hosts` if it is not already present:

```
127.0.0.1    iel-ghou.42.fr
```

If you are using a virtual machine, replace `127.0.0.1` with the VM's IP address.

Open a web browser and visit:

```
https://iel-ghou.42.fr
```

Because the project uses a self-signed TLS certificate, your browser will display a security warning. Accept the warning to continue.

---

# Accessing the WordPress Administration Panel

Open:

```
https://iel-ghou.42.fr/wp-admin
```

Log in using the administrator username and password defined in the `.env` file.

---

# Credentials

All configuration values and credentials are stored in the project's `.env` file.

Examples include:
```
DOMAIN_NAME=iel-ghou.42.fr

MARIADB_HOST=mariadb
MARIADB_DATABASE=wordpress
MARIADB_USER=wpuser
MARIADB_PASSWORD=mariadbpassword
MARIADB_ROOT_PASSWORD=rootmariadbpassword

WP_TITLE="Inception Blog"
WP_ADMIN_USER=adm
WP_ADMIN_PASSWORD=wpadminpassword
WP_ADMIN_EMAIL=admin@mail.com
WP_USER=test_author
WP_USER_EMAIL=author@mail.com
WP_USER_PASSWORD=wpuserpassword
```

Do not hardcode passwords inside Dockerfiles or configuration files.

---

# Checking That the Services Are Running

List all running containers:

```bash
docker ps
```

You should see the following containers running:

* nginx
* wordpress
* mariadb

To inspect the logs of a service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

To verify that the website is available, open:

```
https://iel-ghou.42.fr
```

If the WordPress home page is displayed, the infrastructure is running correctly.

To inspect the running services managed by Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml ps
```

All services should have the status **Up**.
