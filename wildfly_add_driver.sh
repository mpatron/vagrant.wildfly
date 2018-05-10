#!/bin/bash
# ca fonctionne mais il faut faire attention au sleep car systemd retourne la main sans que wildfly est fini de démarrer.
SLEEP_DUREE=2
set -x
if [ ! -f /opt/wildfly/modules/org/postgresql/main/postgresql-42.2.2.jar ]; then
    curl -o /tmp/postgresql-42.2.2.jar https://jdbc.postgresql.org/download/postgresql-42.2.2.jar
    if [ $? -eq 0 ] ; then
        sudo systemctl restart wildfly
        sleep $SLEEP_DUREE
        sudo -u wildfly /opt/wildfly/bin/jboss-cli.sh --connect --controller=192.168.56.102:9990 --user=admin --password=admin1 --file=/vagrant/wildfly_add_driver.cli
        sleep $SLEEP_DUREE
        sudo systemctl restart wildfly
    fi
fi
sleep $SLEEP_DUREE
RETOUR=$(sudo -u wildfly /opt/wildfly/bin/jboss-cli.sh --connect --controller=192.168.56.102:9990 --user=admin --password=admin1 --command="data-source test-connection-in-pool --name=PostgreLocalPool")
if [ $RETOUR == true ]; then exit 0; else exit 1; fi