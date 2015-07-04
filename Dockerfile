FROM alpine:3.2
MAINTAINER Eagle Liut <eagle@dantin.me>

RUN apk add --update nginx php-fpm php-ldap phpldapadmin && rm -rf /var/cache/apk/*

ADD nginx.conf /etc/nginx/nginx.conf
ADD host.default /etc/nginx/sites-available/default

ADD config.php /etc/phpldapadmin/config.php
ADD customAccount.xml /usr/share/webapps/phpldapadmin/templates/creation/customAccount.xml

ADD container-start.sh /start.sh
RUN chmod a+x /start.sh

ENTRYPOINT ["/start.sh"]

VOLUME ["/var/log"]

EXPOSE 80

# CMD ["-h"]
