FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY tools/mariadb_init.sh /usr/local/bin/mariadb_init.sh

RUN chmod +x /usr/local/bin/mariadb_init.sh

ENTRYPOINT ["/usr/local/bin/mariadb_init.sh"]
