# srv-wmflabs-math26

Docker Compose setup for the math server in the WMCloud project
[Math](https://wikitech.wikimedia.org/wiki/Nova_Resource:Math).
It runs on the instance math26, which `infra/deploy` creates.

Serves:
* `<lang>.<site>.beta.math.wmflabs.org` – one MediaWiki per imported Wikimedia dump
* `mardi.beta.math.wmflabs.org` – Wikibase repository for the wikis above
* `mathoid.beta.math.wmflabs.org`
* `traefik.beta.math.wmflabs.org` and `math-traefik-dashboard.wmcloud.org` – Traefik dashboard (basic auth);
  the second goes through the Cloud VPS web proxy and works even if the TLS setup of math26 fails

## Services

| Service | Image |
|---------|-------|
| `reverse-proxy` | traefik, TLS via Let's Encrypt |
| `mathoid` | docker-registry.wikimedia.org/repos/mediawiki/services/mathoid |
| `database` (`db`) | mariadb |
| `mediawiki` (`mw`) | ghcr.io/mardi4nfdi/apache-assets |
| `mediawiki-fpm` | ghcr.io/mardi4nfdi/wikibase |
| `watchtower` | nickfedor/watchtower, updates the images within their pinned versions |

`LocalSettings.php` and `LocalSettings.d/` are mounted read-only into both MediaWiki containers.
The filtered dumps are expected in `/data/project/wdump/math`.

## Secrets

Secrets are not part of this repository.
`infra/deploy` generates them in `/srv/srv-wmflabs-math26/secret` on the server,
and the containers read them from `/run/secrets`.
The Traefik dashboard user is `math`; its password is in `secret/traefik_dashboard_password`.

## Setup

1. In [Horizon](https://horizon.wikimedia.org/identity/application_credentials/), select the project `math`,
   create an application credential and download its `clouds.yaml`.
   Save it as `~/.config/openstack/clouds.yaml` and rename its entry `openstack` to `math`.
2. Install Docker and the OpenStack CLI (`python-openstackclient`).
   OpenTofu runs in a container, because the Cloud VPS provider only exists for linux/amd64.
3. Make `ssh math26` work, e.g. with this entry in `~/.ssh/config`:
   ```
   Host math26
       Hostname math26.math.eqiad1.wikimedia.cloud
       ProxyJump primary.bastion.wmflabs.org
   ```
4. Clone this repository and run the script:
   ```bash
   git clone https://github.com/MaRDI4NFDI/srv-wmflabs-math26.git
   srv-wmflabs-math26/infra/deploy
   ```
   It shows the OpenTofu plan and asks before applying it, then runs Puppet on math26 and starts the services.
   See [a sample run](infra/sample-deploy.log).

The instance has no `user_data`, because it would override the WMCS cloud-init and break Puppet.

Updates are handled manually.

To run docker without sudo:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Database

The database user `wiki` is created when the database volume is initialized (see `initdb/`).

```bash
docker exec -it db bash -c 'mariadb -p"$(cat /run/secrets/db_root_password)"'
```

`scripts/backup-db` dumps all databases to `/data/project/backup/mathqid`.

## Create the wikis

The scripts in `container-scripts/mw` are mounted to `/var/www/html/scripts` in `mediawiki-fpm`.

```bash
docker exec -it mediawiki-fpm /bin/bash
cd /var/www/html/scripts
./createAllWikis.sh    # one wiki per dump in /data/project/wdump/math, logs in its log/
./foreachwiki update --quick    # run a maintenance script on every wiki
./enableWikidata.sh
```

The dumps are created with [wikiFilter](https://github.com/MaRDI4NFDI/wikiFilter).
