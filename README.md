# wordpress-docker-compose
Wordpress configured in docker-compose

## How to use this repo

### Setup

**Basic steps:**

- [1] Open up `docker-compose.yml`
  - [1.1] Change those fields filled with `<CHANGE_ME>` and save it.
  - [1.2] Change `DOMAIN.tld` to the exact domain and remove redundancy, save it.
- [2] Run `sudo docker-compose up -d` to get the whole server up and running.

**Notes:**

- [1.1] Copy `.env.sample` to `.env`, then edit it to specify a NGINX profile location, you can also leave it blank.


**Optional processes:**

- [2.3] In the app root, run the command from `nginx-gen` service in the compose file. This is useful if you want to update the `nginx.tmpl` file.

### Let's Encrypted integrated

**HTTPS Enabled**

When you done all steps above, your website will have HTTPS enabled already.

**Integrate with other apps on the same server**

If you are running other apps on the same server, the nginx inside this docker-compose must be able to talk to that app. So you need to have an external network.

In each `docker-compose.yml`, add an external network:

```
networks:
  proxy-tier:
    external:
      name: nginx-proxy
```

Then in your apps, hook this `proxy-tier` up like this (within an service):

```
networks:
  - proxy-tier
```

Then setup those apps just like this docker-compose/wp, add envs such as `VIRTUAL_HOST`, `LETSENCRYPT_HOST`. Then you can recreate your app to make it work.

## How the built environment is structured?

**The data:**

Key information: data volumes are specified in `docker-compose.yml` > `volumes` section.

```
$ sudo docker volume ls

DRIVER              VOLUME NAME
local               wordpressdockercompose_db_data
local               wordpressdockercompose_db_etc_mysql
local               wordpressdockercompose_wp_data
```

## Backup and restore

### Docker setup

Create the apps (empty)

```bash
# Install Docker
curl -sSL https://get.docker.com/ | sudo sh

# Install Docker Compose
sudo su # Enter su mode
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
exit # Exit from su

# Create app (empty)
sudo docker-compose up

# After it's initialized, stop it with Ctrl + C, ready for restoring.
^C
```

### Restore from volume backup files

```bash
# Restore
sudo ./_be_careful_restore.sh <BACKUP_PATH>/20XX-XX-XX-XX-XX-XX

# To print restore commands only
sudo ./_be_careful_restore.sh <BACKUP_PATH>/20XX-XX-XX-XX-XX-XX --print
```

### Backup

```bash
# Backup
sudo ./backup.sh

# Rackspace Cloud Files
# sudo su
curl -L https://ec4a542dbf90c03b9f75-b342aba65414ad802720b41e8159cf45.ssl.cf5.rackcdn.com/1.2/Linux/amd64/rack > /usr/local/bin/rack && chmod +x /usr/local/bin/rack
rack configure
rack files object upload --container DO_NOT_DELETE_LS_BACKUP --region HKG --name <PROJ_NAME>/<TAR_FILE_NAME>-backup.`date +"%Y-%m-%d-%H-%M-%S"`.tar.gz --file <TAR_PATH>
```

You are free to use any cloud file storages, just backup that `<TAR_PATH>` thing.

## Migration

### References

- https://codex.wordpress.org/Changing_The_Site_URL
