# General informations

## Quickstart

~~~bash
vagrant up --provision
~~~

### Accès to PGAdmin 4 sur

http://192.168.56.102/pgadmin4 avec l'utilisateur : postgres@jobjects.org / admin1

### Accès to PostgreSQL

jdbc:postgresql://192.168.56.102:5432/postgres a pour utilisateur : postgres / postgres

### Accès to Wildlfly

http://192.168.56.102:9990 avec l'utilisateur : admin / admin1

## Miscellaneous

### Command to reload ansible

~~~bash
cd /vagrant && PYTHONUNBUFFERED=1 ANSIBLE_NOCOLOR=true ansible-playbook --limit="all" --inventory-file=inventory.txt -v provision.yml
~~~

### Command to change postgres password

~~~bash
sudo -u postgres /usr/pgsql-10/bin/psql -c "ALTER USER \"postgres\" WITH PASSWORD 'postgres'"
sudo -u postgres /usr/pgsql-10/bin/psql -c "ALTER USER \"postgres\" WITH ENCRYPTED PASSWORD '6edef2d746f2274cab951a452d5fc13d'"
echo "postgres" | md5sum

curl -O https://jdbc.postgresql.org/download/postgresql-42.2.2.jar

sudo -u wildfly /opt/wildfly/bin/jboss-cli.sh --connect --controller=192.168.56.102:9990 --user=admin --password=admin1
module add --name=org.postgresql --slot=main --resources=/vagrant/postgresql-42.2.2.jar --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=postgres:add(driver-name="postgres",driver-module-name="org.postgresql",driver-class-name=org.postgresql.Driver)
data-source add --jndi-name=java:/jdbc/localpostgresql --name=PostgreLocalPool --connection-url=jdbc:postgresql://localhost:5432/postgres --driver-name=postgres --user-name=postgres --password=postgres
/subsystem=datasources/data-source=PostgreLocalPool:test-connection-in-pool(user-name=postgres,password=postgres)
~~~

