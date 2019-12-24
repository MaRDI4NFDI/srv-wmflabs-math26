# srv-mathosphere
wmde mathosphere server config

Config for 
* beta.math.wmflabs.org
* *.beta.math.wmflabs.org
* *.beta.physikerwelt.de

Instance name math19

Installed packages
docker-compose

## Setup mediawiki by script


## Connect to mysql
```bash
physikerwelt@math19:~/srv-mathosphere$ sudo docker exec -it db /bin/bash
root@535c789ac1e0:/# MYSQL_ROOT_PASSWORD=`cat /run/secrets/db_root_password`
root@535c789ac1e0:/# mysql -p$MYSQL_ROOT_PASSWORD
```
```mysql
CREATE USER 'wiki'@'%' IDENTIFIED BY '***REMOVED***';
GRANT ALL PRIVILEGES ON  `wiki\_%` . * TO  'wiki'@'%';

```
