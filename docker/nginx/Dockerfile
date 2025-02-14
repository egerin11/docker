FROM nginx:1.22 AS built

RUN apt update && \
    apt install -y nginx-extras


RUN rm -rf /var/www/html/* && \
    rm -rf /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/conf.d/* && \
    rm -rf /etc/nginx/sites-available/*  && \
    rm -rf /etc/nginx/sites-enabled/*

RUN mkdir -p /etc/letsencrypt/ && mkdir -p /etc/letsencrypt/apache_proxy
COPY ./ssl/ /etc/letsencrypt/


WORKDIR /etc/nginx

COPY nginx.conf .

COPY ./sites-available/ ./sites-available/
COPY media/ /var/www/html/
COPY load.sh /etc/nginx/

RUN addgroup --gid 1000 nonroot && \
    adduser --uid 1000 --gid 1000 --disabled-password --gecos "" nonroot && \
    chown -R nonroot:nonroot /etc/nginx /var/www/html /etc/letsencrypt /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    mkdir -p /var/lib/nginx/body && \
    chown -R nonroot:nonroot /var/lib/nginx /var/log/nginx && \
    mkdir -p /run && \
    chown -R nonroot:nonroot /run

USER nonroot

FROM built AS prod

RUN chmod +x /etc/nginx/load.sh 
RUN  mkdir -p /etc/nginx/sites-enabled/ &&\
    cd /etc/nginx/sites-available/ && \ 
    for file in *; do \
    ln -s /etc/nginx/sites-available/$file /etc/nginx/sites-enabled/$file; \
    done


EXPOSE 80 443

CMD ["/bin/sh", "-c", "/etc/nginx/load.sh & nginx -g 'daemon off;'"]
