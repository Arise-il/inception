# User Documentation

## What the stack provides

Three services work together to serve one WordPress website over HTTPS:

| Service   | Role                                             |
|-----------|--------------------------------------------------|
| nginx     | Public entrypoint, HTTPS (TLSv1.2/1.3) on 443    |
| wordpress | Runs the WordPress site logic via php-fpm        |
| mariadb   | Stores all WordPress data (posts, users, config) |

## Starting and stopping the project

From the project root (where the `Makefile` lives):

```bash
make        # build images (if needed) and start everything
make down   # stop and remove the containers
make stop   # stop containers without removing them
make start  # restart previously stopped containers
make re     # full reset: destroy everything, including volumes, and restart clean
```

## Accessing the website and admin panel

1. Make sure `login.42.fr` resolves to your VM's IP (e.g. an `/etc/hosts` entry, or your
   `LOGIN`/`DOMAIN_NAME` values in `srcs/.env`).
2. Open `https://login.42.fr` — your browser will warn about the self-signed
   certificate; accept it to proceed (this is expected in a local/school setup).
3. The WordPress admin panel is at `https://login.42.fr/wp-admin`.

## Locating and managing credentials

- All passwords live as plain-text files in the `secrets/` folder at the project root:
  - `db_root_password.txt` — MariaDB root password
  - `db_password.txt` — MariaDB application user password
  - `credentials.txt` — WordPress administrator password
  - `wp_user_password.txt` — WordPress regular (author) user password
- The corresponding usernames/emails/domain are set in `srcs/.env`
  (`WP_ADMIN_USER`, `WP_USER`, `DOMAIN_NAME`, etc.).
- `secrets/` and `srcs/.env` are git-ignored — they never get pushed to the repository.
- To change a password: edit the relevant file in `secrets/`, then `make re` (or at
  minimum rebuild/recreate the affected container) so it is picked up.

## Checking the services are running correctly

```bash
make ps
# or
docker compose -f srcs/docker-compose.yml ps
```

All three containers (`nginx`, `wordpress`, `mariadb`) should show as `running`. You can
also tail logs with:

```bash
make logs
```

If a container crashed, `restart: on-failure` will bring it back up automatically; check
`make logs` for the root cause.
