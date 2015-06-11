# docker-ldap-staff

    docker run -e LDAP_HOST=slapd --link slapd:slapd -d -P --name ldap-admin liut/phpldapadmin
