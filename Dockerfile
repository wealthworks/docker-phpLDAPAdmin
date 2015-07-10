FROM lcgc/php-fpm:5.6.10
MAINTAINER Eagle Liut <eagle@dantin.me>

RUN apk --update add \
  phpldapadmin \
  php-mcrypt \
  php-openssl \
  openssl \
  && rm -rf /var/cache/apk/*

ADD etc/nginx/host.default /etc/nginx/sites-available/default

ADD config.php /etc/phpldapadmin/config.php
ADD customAccount.xml /usr/share/webapps/phpldapadmin/templates/creation/customAccount.xml

ADD container-start.sh /start.sh
RUN chmod a+x /start.sh

ENTRYPOINT ["/start.sh"]

VOLUME ["/var/log"]

EXPOSE 80

# CMD ["-h"]
