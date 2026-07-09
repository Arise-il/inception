*This project has been created as part of the 42 curriculum by iel-ghou.*

## Description

**Inception** is a system-administration project: a small self-hosted web infrastructure
built entirely with Docker, composed of three custom-built, single-service containers:

- **NGINX** — the single entrypoint of the whole stack, exposing port `443` with TLSv1.2/TLSv1.3 only.
- **WordPress + php-fpm** — the site logic, with no web server bundled in.
- **MariaDB** — the database, with no web server bundled in.

Each service is built from its own `Dockerfile` (Alpine `3.20` base, penultimate stable
release), started by `docker compose`, wired together on a dedicated bridge network, and
backed by two named volumes (`mariadb_data`, `wordpress_data`) physically stored under
`/home/<login>/data`.

## Instructions

1. Add a `127.0.0.1 login.42.fr` entry to your VM's `/etc/hosts` (replace `login`).
   `echo "127.0.0.1 iel-ghou.42.fr" | sudo tee -a /etc/hosts`
2. Fill in real secrets in `secrets/*.txt` (replace the `ChangeMe_*` placeholders). These
   files are git-ignored and never committed.
3. Adjust `LOGIN` and `DOMAIN_NAME` in `srcs/.env` to match your 42 login.
4. From the project root: `make` (alias for `make up`).
5. Visit `https://login.42.fr` in your browser (accept the self-signed certificate).

See `USER_DOC.md` and `DEV_DOC.md` for details.

## Resources

- Docker docs — https://docs.docker.com/
- Docker Compose file reference — https://docs.docker.com/compose/compose-file/
- WP-CLI — https://wp-cli.org/
- NGINX docs — https://nginx.org/en/docs/
- MariaDB docs — https://mariadb.com/kb/en/
- 42 Inception subject (v5.3, 2026 curriculum)

**AI usage:** AI was used as a learning assistant throughout the project.
It was used to explain Docker concepts, review configuration files,
clarify NGINX, PHP-FPM, and MariaDB behavior, and suggest improvements to the documentation.
All implementation, testing, debugging, and final validation were completed manually.

## Project description — design choices

**Virtual Machines vs Docker**
A VM virtualizes an entire OS (kernel, drivers, init system) on top of a hypervisor,
giving full isolation at the cost of heavier resource use and slower startup. Docker
containers share the host kernel and only isolate the process/filesystem/network
namespace, which makes them lightweight and fast to (re)build — ideal here, where we
need three independent, disposable, easily-reproducible services rather than three
full operating systems.

**Secrets vs Environment Variables**
Plain environment variables (including those in `.env`) are visible in `docker inspect`,
process listings, and image history if baked in — unsuitable for passwords. Docker
**secrets** are mounted as files under `/run/secrets/` inside the container, are not
recorded in the image layers or `docker inspect` env output, and can be swapped without
rebuilding. This project therefore keeps non-sensitive config (domain, DB name, WP
titles/emails) in `.env`, and every password in `secrets/*.txt`, read at container
start by the entrypoint scripts.

**Docker Network vs Host Network**
`network: host` would remove all network isolation and let every container bind
directly to the host's ports/interfaces — forbidden by the subject and unnecessary here.
A dedicated **bridge network** (`inception`) lets the three containers resolve each
other by service name (`mariadb`, `wordpress`) while staying isolated from the host and
from other Docker networks; only NGINX publishes a port (`443`) to the outside.

**Docker Volumes vs Bind Mounts**
A bind mount ties a container path directly to an arbitrary host path, with no lifecycle
management from Docker and inconsistent permissions across hosts. A **named volume** is
managed by the Docker engine, has a stable name, and is trivial to back up, inspect, or
migrate. The subject also explicitly requires named volumes for persistence, so
`mariadb_data` and `wordpress_data` are named volumes whose underlying storage is pinned
(via `driver_opts`) to `/home/<login>/data`, satisfying both the "named volume" and the
"stored under /home/login/data" requirements at once.
