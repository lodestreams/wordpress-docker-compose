# wordpress-docker-compose
Wordpress configured in docker-compose

## How to use this repo

**Basic steps:**

- [1] Copy and paste this `docker-compose.yml` to your app root.
- [2] Open up `docker-compose.yml`
  - [2.1] Change those fields filled with `<CHANGE_ME>` and save it.
  - [2.2] Change the `DOMAIN.tld` to the exact domain and remove redundancy, save it.
- [3] Run `sudo docker-compose up -d` to get the whole server up and running.

**Optional processes:**

- [2.3] In the app root, run the command from `nginx-gen` service in the compose file. This is useful if you want to update the `nginx.tmpl` file.

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

## How to backup the website?

The command:

```
sudo ./backup.sh
```

Where to find the backed up files?

```
cd backups
```

How to backup them into a cloud service such as Rackspace Cloud Files?

```
# Optional, only do once
# Prepare the Rackspace API key and secret 
# Do this as a root user
# All regions: Northern Virginia (IAD), Chicago (ORD), Dallas (DFW), Hong Kong (HKG), Sydney (SYD)
curl -L https://ec4a542dbf90c03b9f75-b342aba65414ad802720b41e8159cf45.ssl.cf5.rackcdn.com/1.2/Linux/amd64/rack > /usr/local/bin/rack && chmod +x /usr/local/bin/rack && rack configure

# REPO_NAME usually is `DO_NOT_DELETE_LS_BACKUP`
rack files object upload --container <REPO_NAME> --region HKG --name <PROJECT_SHORT>/<TAR_FILE> --file ./<TAR_FILE>
```

