# Penultimate stable Alpine release
FROM alpine:3.20

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

COPY conf/my.cnf /etc/my.cnf.d/my.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh && \
    mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init_db.sh"]
