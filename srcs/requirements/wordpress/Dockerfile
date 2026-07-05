# Penultimate stable Alpine release
FROM alpine:3.20

RUN apk update && apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-phar \
    php83-session \
    php83-xml \
    php83-zip \
    php83-gd \
    php83-opcache \
    php83-ctype \
    php83-tokenizer \
    php83-simplexml \
    curl \
    tar \
    bash \
    mariadb-client \
    && ln -sf /usr/bin/php83 /usr/bin/php

RUN echo "memory_limit = 512M" > /etc/php83/conf.d/99-wp-cli.ini

RUN curl -fsSL -o /usr/local/bin/wp \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN chmod +x /usr/local/bin/setup_wordpress.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]
