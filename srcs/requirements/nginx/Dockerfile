FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx-selfsigned.key \
    -out /etc/nginx/certs/nginx-selfsigned.crt \
    -subj "/C=MA/ST=Bengeruir/L=Bengeruir/O=42/OU=1337/CN=iel-ghou.42.fr/UID=iel-ghou"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]