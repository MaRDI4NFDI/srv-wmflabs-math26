# math24

State of math24 on 2026-09-26, before it is replaced by math26
([T439313](https://phabricator.wikimedia.org/T439313)).

## Instance

* Debian 12, 8 cores, 16 GB RAM, Docker 20.10
* 20 GB root disk, 90 GB volume on `/srv` (72 GB used), Docker data in `/srv/docker`
* Holds the project's only floating IP.
  `beta.math.wmflabs.org`, `*.beta.math.wmflabs.org`, `*.math.wmflabs.org` and
  `mardi.math.wmflabs.org` point to it.
* Runs this repository at `7d37804`, without local changes.

Containers: `reverse-proxy` (traefik), `mw`, `mediawiki-fpm`, `db` (mariadb 11.6), `mathoid`, `whoami`.
Most of the load comes from bots crawling the wikis (mariadb and traefik).

## Data that is lost with the instance

* Docker volume `mw-database` (60 GB on disk): 651 wiki databases with a `mathlog` table,
  38 GB of table data. Largest: enwiki 3.4 GB, dewiki 2.6 GB, ruwiki 2.3 GB.
  They are rebuilt from the dumps on math26.
* The Let's Encrypt certificates. They are issued again on math26.

There are no cron jobs.

## Data on the project NFS share

`/data/project` is served by math-nfs-2 and stays (137 GB, 40 GB free).

| Path | Content |
|------|---------|
| `wdump/math` | 657 filtered dumps, 1.6 GB, Dec 2025 ([10.5281/zenodo.17898175](https://doi.org/10.5281/zenodo.17898175)) |
| `wdump/math25-03` | 652 filtered dumps, 1.5 GB, Mar 2025 ([10.5281/zenodo.15107679](https://doi.org/10.5281/zenodo.15107679)) |
| `wdump/math19`, `wdump/math-qid` | older dumps |
| `wdump/links/latest` | links to the latest dumps, written by `updateLinks.sh` |

The Wikimedia dumps themselves are mounted by Puppet (hiera `mount_nfs: true`) under `/public/dumps/public`.

## Notes for the pipeline

The tables `math_input` and `mathstat` no longer exist.
`allFormulae.sql` and `stats.sql` in wikiFilter create them again.
