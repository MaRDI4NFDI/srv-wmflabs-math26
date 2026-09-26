# srv-wmflabs-math26

Docker Compose setup for the math server in the WMCloud project
[Math](https://wikitech.wikimedia.org/wiki/Nova_Resource:Math).
It currently runs on the instance math24 and moves to math26.

Serves:
* `<lang>.<site>.beta.math.wmflabs.org` – one MediaWiki per imported Wikimedia dump
* `mardi.beta.math.wmflabs.org` – Wikibase repository for the wikis above
* `mathoid.beta.math.wmflabs.org`
* `traefik.beta.math.wmflabs.org` – Traefik dashboard (basic auth)

## Services

| Service | Image |
|---------|-------|
| `reverse-proxy` | traefik, TLS via Let's Encrypt |
| `mathoid` | docker-registry.wikimedia.org/repos/mediawiki/services/mathoid |
| `database` (`db`) | mariadb |
| `mediawiki` (`mw`) | ghcr.io/mardi4nfdi/apache-assets |
| `mediawiki-fpm` | ghcr.io/mardi4nfdi/wikibase |

`LocalSettings.php` and `LocalSettings.d/` are mounted read-only into both MediaWiki containers.
The filtered dumps are expected in `/data/project/wdump/math`.

## Secrets

Secrets are not part of this repository.
Before the first start:
* Create `secret/db_root_password.txt` (ignored by git).
* Replace every `***REMOVED***` placeholder in `LocalSettings.php`,
  `traefik-conf/dynamic.yml` and `container-scripts/mw/createWiki`.

The history was imported from the private repository gipplab/srv-math24
with all secrets removed.

## Setup

```bash
git clone https://github.com/MaRDI4NFDI/srv-wmflabs-math26.git
cd srv-wmflabs-math26
docker compose up -d
```

Updates are handled manually.

To run docker without sudo:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Database

```bash
docker exec -it db /bin/bash
mysql -p"$(cat /run/secrets/db_root_password)"
```
```mysql
CREATE USER 'wiki'@'%' IDENTIFIED BY '***REMOVED***';
GRANT ALL PRIVILEGES ON `wiki\_%`.* TO 'wiki'@'%';
```

`scripts/backup-db` dumps all databases to `/data/project/backup/mathqid`.

## Create the wikis

The scripts in `container-scripts/mw` are mounted to `/var/www/html/scripts` in `mediawiki-fpm`.

```bash
docker exec -it mediawiki-fpm /bin/bash
cd /var/www/html/scripts
./createAllWikis.sh    # FIXME: createWiki stops after checking the dump name (exit 0)
./update.sh            # run update.php for every wiki
./enableWikidata.sh
```

The dumps are created with [wikiFilter](https://github.com/MaRDI4NFDI/wikiFilter).
