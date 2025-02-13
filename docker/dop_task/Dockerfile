FROM alpine:3.14
RUN apk update && apk add --no-cache nginx &&  apk add  curl
RUN rm -rf /etc/nginx/http.d/*
WORKDIR /etc/nginx
COPY test.sh /etc/nginx/test.sh
VOLUME ["/etc/nginx/test.log"]
RUN chmod +x /etc/nginx/test.sh

COPY index.html /var/www/html/
COPY default.conf /etc/nginx/http.d/

EXPOSE 80

CMD ["/bin/sh", "-c", "/etc/nginx/test.sh & nginx -g 'daemon off;'"]