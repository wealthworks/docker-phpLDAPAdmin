#!/bin/bash -e

FIRST_START_DONE="/etc/docker-first-start-done"

# /usr/share/phpldapadmin/config/config.php -> /etc/phpldapadmin/config.php
CONFIG="/etc/phpldapadmin/config.php"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

# $servers->newServer('ldap_pla');
# $servers->setValue('server','name','My LDAP Server');
# $servers->setValue('server','host','localhost');
# $servers->setValue('server','port',389);
# $servers->setValue('server','base',array('dc=example,dc=net'));
# $servers->setValue('login','auth_type','cookie');

	if [ ! -e $CONFIG ]; then
		echo "<?PHP" > $CONFIG
		echo "" >> $CONFIG
		echo "\$servers = new Datastore();" >> $CONFIG
		echo "" >> $CONFIG
	fi

    echo "\$servers->newServer('ldap_pla');" >> $CONFIG
    echo "\$servers->setValue('login','auth_type','${LDAP_AUTH_TYPE:-cookie}');" >> $CONFIG
    echo "\$servers->setValue('server','name','${LDAP_NAME:-My LDAP Server}');" >> $CONFIG
    echo "\$servers->setValue('server','host','${LDAP_HOST:-localhost}');" >> $CONFIG
    echo "\$servers->setValue('server','port', ${LDAP_PORT:-389} );" >> $CONFIG
    [ ! -z $LDAP_BASE_DN] && echo "\$servers->setValue('server','base',array('${LDAP_BASE_DN}'));" >> $CONFIG
    echo "" >> $CONFIG

    touch $FIRST_START_DONE
fi

/etc/init.d/php5-fpm start && nginx

exit 0
