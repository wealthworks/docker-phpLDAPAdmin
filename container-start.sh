#!/bin/sh -e

FIRST_START_DONE="/etc/docker-first-start-done"

# /usr/share/phpldapadmin/config/config.php -> /etc/phpldapadmin/config.php

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

    mkdir -p /var/log/php
    chown nobody /var/log/php
    sed -i "s|;error_log = php_errors.log|error_log = /var/log/php/errors.log|g" /etc/php/php.ini

    mkdir -p /var/lib/nginx/tmp
    chown -R nobody:nobody /var/lib/nginx/tmp
    chmod 775 /var/lib/nginx/tmp

    CONFIG="/etc/phpldapadmin/config.php"

# $servers->newServer('ldap_pla');
# $servers->setValue('server','name','My LDAP Server');
# $servers->setValue('server','host','localhost');
# $servers->setValue('server','port',389);
# $servers->setValue('server','base',array('dc=example,dc=net'));
# $servers->setValue('login','auth_type','session');

	if [ ! -e $CONFIG ]; then
		echo "<?PHP" > $CONFIG
		echo "" >> $CONFIG
		echo "\$config->custom->session['blowfish'] = '';" >> $CONFIG
		echo "" >> $CONFIG
		echo "\$servers = new Datastore();" >> $CONFIG
		echo "" >> $CONFIG
	fi

    get_salt() {
      salt=$(</dev/urandom tr -dc '1324567890#<>,()*.^@$% =-_~;:|{}[]+!`azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN' | head -c64 | tr -d '\\')
    }

    # phpLDAPadmin cookie secret
    get_salt
    sed -i "s/blowfish'] = '/blowfish'] = '${salt}/g" $CONFIG

    echo "\$servers->newServer('ldap_pla');" >> $CONFIG
    echo "\$servers->setValue('login','auth_type','${LDAP_AUTH_TYPE:-session}');" >> $CONFIG
    echo "\$servers->setValue('server','name','${LDAP_NAME:-My LDAP Server}');" >> $CONFIG
    echo "\$servers->setValue('server','host','${LDAP_HOST:-localhost}');" >> $CONFIG
    echo "\$servers->setValue('server','port', ${LDAP_PORT:-389} );" >> $CONFIG
    [ ! -z $LDAP_BASE_DN] && echo "\$servers->setValue('server','base',array('${LDAP_BASE_DN}'));" >> $CONFIG
    echo "" >> $CONFIG

    if [ -n "$MAIL_DOMAIN" ]; then
        sed -i "s|@example.org|@$MAIL_DOMAIN|g" /usr/share/webapps/phpldapadmin/templates/creation/customAccount.xml
    fi

    [ -d /var/lib/php5/sessions ] && chown nobody:nobody /var/lib/php5/sessions

    touch $FIRST_START_DONE
fi

php-fpm && nginx


