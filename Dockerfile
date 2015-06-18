FROM debian:8

MAINTAINER Eagle Liut "eagle@dantin.me"

RUN echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib" > /etc/apt/sources.list; \
	echo "deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib" >> /etc/apt/sources.list;

RUN apt-get update ; \
    apt-get -y --no-install-recommends install nginx-light php5-fpm php5-ldap phpldapadmin; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD host.default /etc/nginx/sites-available/default
ADD nginx.conf /etc/nginx/nginx.conf

ADD config.php /etc/phpldapadmin/config.php
ADD customAccount.xml /etc/phpldapadmin/templates/creation/customAccount.xml

ADD container-start.sh /scripts/start.sh
RUN chmod a+x /scripts/start.sh

VOLUME ["/var/log"]

EXPOSE 80

CMD /scripts/start.sh
