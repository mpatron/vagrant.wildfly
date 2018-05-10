#!/bin/bash
set -x
if [ -f /var/lib/pgadmin/pgadmin4.db ]; then
    rm -f /var/lib/pgadmin/pgadmin4.db
fi
systemctl stop httpd.service
cp run_pgadmin.py  /usr/lib/python2.7/site-packages/pgadmin4-web/
cp -f /etc/httpd/conf.d/pgadmin4.conf.sample /etc/httpd/conf.d/pgadmin4.conf

SERVER_MODE=True PGADMIN_SETUP_EMAIL=postgres@jobjects.org PGADMIN_SETUP_PASSWORD=admin1 python /usr/lib/python2.7/site-packages/pgadmin4-web/setup.py
python /usr/lib/python2.7/site-packages/pgadmin4-web/setup.py
chown apache:apache /var/lib/pgadmin/pgadmin4.db
chown apache:apache /var/log/pgadmin/pgadmin4.log
chown -R apache:apache /var/lib/pgadmin
chown -R apache:apache /var/log/pgadmin
chcon -R -t httpd_sys_content_rw_t "/var/log/pgadmin/"
chcon -R -t httpd_sys_content_rw_t "/var/lib/pgadmin/"
systemctl start httpd.service
/usr/sbin/setsebool -P httpd_can_network_connect on
echo "Connect to site : http://<serverip>/pgadmin4 postgres@jobjects.org/admin1"