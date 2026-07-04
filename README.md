*This project has been created as part of the 42 curriculum by iel-ghou.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to build a small web infrastructure using Docker Compose. Each service runs inside its own Docker container and communicates through a dedicated Docker network. The project demonstrates containerization, networking, persistent storage, TLS configuration, and service orchestration.

---

## Project Description

### Services

The infrastructure contains three services:

* **NGINX** – Receives HTTPS requests (port 443) and forwards PHP requests to WordPress.
* **WordPress + PHP-FPM** – Executes PHP code and serves the WordPress application.
* **MariaDB** – Stores the WordPress database (users, posts, pages, settings, etc.).

### Design Choices

* One service per container.
* Docker Compose to orchestrate all services.
* Docker named volumes for persistent data.
* A dedicated bridge network for communication.
* NGINX is the only service exposed to the host.

### Comparisons

**Virtual Machines vs Docker**

* Virtual machines run a complete operating system.
* Docker containers share the host kernel, making them lighter and faster to start.

**Secrets vs Environment Variables**

* Environment variables are easy to configure and are used in this project.
* Docker Secrets provide better protection for sensitive information and are recommended for production deployments.

**Docker Network vs Host Network**

* A bridge network isolates containers while allowing them to communicate using service names.
* Host networking removes this isolation and is forbidden for this project.

**Docker Volumes vs Bind Mounts**

* Docker named volumes provide persistent storage managed by Docker.
* Bind mounts directly map host directories.
* This project uses named volumes stored under `/home/iel-ghou/data`.

---

## Instructions

### Prerequisites

* Docker Engine
* Docker Compose
* Linux virtual machine

### Setup

```bash
git clone <repository-url>
cd inception

echo "127.0.0.1 iel-ghou.42.fr" | sudo tee -a /etc/hosts

mkdir -p /home/iel-ghou/data/{mariadb,wordpress}

make
```

Open:

```
https://iel-ghou.42.fr
```

Accept the browser warning for the self-signed certificate.

### Useful Commands

```bash
make          # Build and start the project
make down     # Stop all containers
make re       # Rebuild and restart
make clean    # Remove containers and images
```

### WordPress Administration

```
https://iel-ghou.42.fr/wp-admin
```

Credentials are configured in `srcs/.env`.

---

## Resources

### Documentation

* Docker: https://docs.docker.com/
* Docker Compose: https://docs.docker.com/compose/
* NGINX: https://nginx.org/en/docs/
* MariaDB: https://mariadb.com/kb/en/documentation/
* WordPress: https://developer.wordpress.org/

### AI Usage

ChatGPT was used as a learning assistant throughout the project. It was used to explain Docker concepts, review configuration files, clarify NGINX, PHP-FPM, and MariaDB behavior, and suggest improvements to the documentation. All implementation, testing, debugging, and final validation were completed manually.
