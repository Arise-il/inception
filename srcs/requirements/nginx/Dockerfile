# Penultimate stable Alpine release
FROM alpine:3.20

ARG DOMAIN_NAME=login.42.fr

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42Network/CN=${DOMAIN_NAME}"

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN sed -i "s/login.42.fr/${DOMAIN_NAME}/" /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
