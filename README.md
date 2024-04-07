# srv-mathosphere
wmde mathosphere server config

Config for 
* beta.math.wmflabs.org
* *.beta.math.wmflabs.org
* *.beta.physikerwelt.de

Instance name math19

Installed packages
docker-compose

This directory is checked out as follows
```
physikerwelt@math19:~$ git clone git@github.com:ag-gipp/srv-math19.git
physikerwelt@math19:~/srv-math19$ sudo docker-compose up -d
```
Updates are handled manually.

Add user to docker group
```
physikerwelt@math24:~/srv-math24$ sudo groupadd docker
groupadd: group 'docker' already exists
physikerwelt@math24:~/srv-math24$ sudo usermod -aG docker $USER
physikerwelt@math24:~/srv-math24$ newgrp docker
physikerwelt@math24:~/srv-math24$ docker run hello-world
YEAH
````


## Connect to mysql
```bash
physikerwelt@math19:~/srv-mathosphere$ docker exec -it db /bin/bash
root@535c789ac1e0:/# MYSQL_ROOT_PASSWORD=`cat /run/secrets/db_root_password`
root@535c789ac1e0:/# mysql -p$MYSQL_ROOT_PASSWORD
```
```mysql
CREATE USER 'wiki'@'%' IDENTIFIED BY '***REMOVED***';
GRANT ALL PRIVILEGES ON  `wiki\_%` . * TO  'wiki'@'%';

```

## Setup mediawiki by script
```
docker exec -it mw /bin/bash
root@c1eabacc8e54:/var/www/html# ./scripts/createAllWikis.sh
root@c1eabacc8e54:/var/www/html# ./scripts/enableWikidata.sh 
