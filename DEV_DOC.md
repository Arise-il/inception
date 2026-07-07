# Developer Documentation

## Prerequisites

- A Linux virtual machine (per subject requirements — this cannot run on the host
  directly).
- Docker Engine and the Docker Compose plugin (`docker compose version`).
- `make`.
- A `login.42.fr` DNS entry pointing at the VM's local IP (e.g. via `/etc/hosts`).

## Setting up the environment from scratch

1. Clone the repository.
2. Edit `srcs/.env`:
   - `LOGIN` → your 42 login (used to build the `/home/<login>/data` volume paths).
   - `DOMAIN_NAME` → `<login>.42.fr`.
   - Adjust `MYSQL_DATABASE`, `MYSQL_USER`, `WP_*` values if desired.
3. Edit the four files in `secrets/` and replace every `ChangeMe_*` placeholder with a
   real, private password. **Never commit real secrets** — `secrets/` is git-ignored.

Directory layout:

```
.
├── Makefile
├── secrets/                  # git-ignored, one password per file
├── srcs/
│   ├── .env                  # git-ignored, non-secret config
│   ├── docker-compose.yml
│   └── requirements/
│       ├── mariadb/{Dockerfile, conf/, tools/}
│       ├── nginx/{Dockerfile, conf/, tools/}
│       └── wordpress/{Dockerfile, conf/, tools/}
```

## Building and launching with the Makefile / Docker Compose

```bash
make build   # docker compose build (uses each requirements/<service>/Dockerfile)
make up      # build (if needed) + docker compose up -d
make down    # docker compose down
make re      # fclean + all: full rebuild from a clean slate
```

Under the hood, `make` always targets `srcs/docker-compose.yml` and `srcs/.env`
explicitly, and creates the host data directories (`/home/<login>/data/{mariadb,wordpress}`)
before starting the stack, since Docker will not auto-create bind-backed volume
device paths.

## Managing containers and volumes

```bash
docker compose -f srcs/docker-compose.yml ps                 # container status
docker compose -f srcs/docker-compose.yml logs -f <service>  # follow one service's logs
docker exec -it mariadb   sh                                  # shell into a container
docker exec -it wordpress sh
docker exec -it nginx     sh

docker volume ls                     # mariadb_data, wordpress_data
docker volume inspect mariadb_data   # see the real /home/<login>/data/mariadb path
```

To reset everything (containers, images, volumes, and host data):

```bash
make fclean
```

## Where data lives and how it persists

- `mariadb_data` (named volume) is bind-backed by `driver_opts` to
  `/home/<login>/data/mariadb` on the host, and mounted at `/var/lib/mysql` in the
  `mariadb` container.
- `wordpress_data` (named volume) is bind-backed to `/home/<login>/data/wordpress`, and
  mounted at `/var/www/html` in **both** the `wordpress` and `nginx` containers (nginx
  needs read access to serve static files and PHP handles requests via php-fpm on
  port 9000).
- Because both volumes are declared `external`-style named volumes pinned to a fixed
  host path (not anonymous, not plain bind mounts), data survives `docker compose down`
  and container recreation, and only disappears if you explicitly `make fclean` or
  remove the volume/host directory yourself.
- On first boot, `mariadb`'s entrypoint (`init_db.sh`) initializes the data directory
  only if `/var/lib/mysql/mysql` doesn't already exist; likewise `wordpress`'s entrypoint
  (`setup_wordpress.sh`) only runs `wp core install` if `wp-config.php` isn't already
  present — so re-running `make up` on an existing volume is idempotent and won't
  re-install over existing data.
