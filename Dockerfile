FROM alpine:3.2
MAINTAINER Eagle Liut <eagle@dantin.me>

RUN apk add --update nginx php-fpm php-ldap phpldapadmin && rm -rf /var/cache/apk/*

RUN sed -i "s|listen = .*|listen = /var/run/php5-fpm.sock|g" /etc/php/php-fpm.conf \
 && sed -i "s|;listen.owner = .*|listen.owner = nobody|g" /etc/php/php-fpm.conf \
 && sed -i "s|;listen.group = .*|listen.group = nobody|g" /etc/php/php-fpm.conf

ADD etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD etc/nginx/host.default /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/sites-enabled \
 && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

ADD config.php /etc/phpldapadmin/config.php
ADD customAccount.xml /usr/share/webapps/phpldapadmin/templates/creation/customAccount.xml

ADD container-start.sh /start.sh
RUN chmod a+x /start.sh

ENTRYPOINT ["/start.sh"]

VOLUME ["/var/log"]

EXPOSE 80

# CMD ["-h"]
