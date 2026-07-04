# DEV_DOC.md

# Developer Documentation

## Environment Setup

### Prerequisites

Before building the project, install:

* Docker Engine
* Docker Compose
* Git
* A Linux virtual machine (required by the subject)

### Configuration

Create the required data directories:

```bash
mkdir -p /home/iel-ghou/data/mariadb
mkdir -p /home/iel-ghou/data/wordpress
```

Add this line to your `/etc/hosts` file so the domain points to your local machine:

```text
127.0.0.1    iel-ghou.42.fr
```

Create a `.env` file inside `srcs/` containing the required variables, such as:

* Domain name
* MariaDB credentials
* WordPress administrator credentials
* WordPress user credentials

No passwords should be hardcoded inside the Dockerfiles or configuration files.

---

## Building and Running

From the project root:

```bash
make rebuild
```

To stop the project:

```bash
make down
```

To rebuild everything:

```bash
make re
```

---

## Useful Docker Commands

List running containers:

```bash
docker ps
```

View container logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Open a shell inside a container:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

Stop all services:

```bash
make down
```

---

## Persistent Data

The project uses two Docker named volumes:

| Volume     | Host Location                   |
| ---------- | ------------------------------- |
| `db_data`  | `/home/iel-ghou/data/mariadb`   |
| `wp_files` | `/home/iel-ghou/data/wordpress` |

The MariaDB database is stored inside `db_data`, while the WordPress files are stored inside `wp_files`.

Because these are persistent Docker volumes, removing or recreating containers does not delete the stored data. The website and database remain available after restarting the project unless the volumes are explicitly removed.
