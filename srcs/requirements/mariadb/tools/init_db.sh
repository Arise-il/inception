#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# /var/lib/mysql is backed by a host-bound named volume. The chown baked into the
# image at build time does NOT survive that mount, since the host directory's own
# ownership takes over at runtime. Re-assert it here, every start, while we're still
# root (before mysqld drops to --user=mysql).
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "==> [mariadb] first run: initializing data directory"
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null

    # temporary server, no external networking, just to run the bootstrap SQL
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done

    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    mysqladmin --user=root --password="${DB_ROOT_PASSWORD}" shutdown
    wait "$pid"
    echo "==> [mariadb] initialization complete"
fi

echo "==> [mariadb] starting server"
exec mysqld --user=mysql --datadir=/var/lib/mysql
