FROM php:8.0-apache

COPY httpd.conf /etc/apache2/sites-available/
RUN rm -rf /etc/apache2/sites-available/000-default.conf
RUN a2enmod ssl rewrite headers

RUN a2ensite httpd.conf
COPY index.html /var/www/html/
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

EXPOSE 8080 

CMD ["apache2-foreground"]
