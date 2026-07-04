#!/bin/sh
set -e

cd /var/www/html

case "$WP_ADMIN_USER" in
    *admin*|*Admin*|*administrator*|*Administrator*)
        echo "Error: WP_ADMIN_USER cannot contain 'admin' or 'administrator'."
        exit 1
        ;;
esac

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress not installed, setting up..."
    wp core download --allow-root --force
    wp config create --force \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="${MARIADB_HOST}:3306" \
        --allow-root
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root || echo "User ${WP_USER} already exists, skipping."
fi

chown -R www-data:www-data /var/www/html

exec "$@"