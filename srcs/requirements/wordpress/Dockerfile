FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    unzip

RUN mkdir -p /run/php/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY tools/wordpress_init.sh /usr/local/bin/wordpress_init.sh
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/wordpress_init.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress_init.sh"]
CMD ["php-fpm7.4","-F"]