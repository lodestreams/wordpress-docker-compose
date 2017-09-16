#!/usr/bin/env bash

readonly project_name=<PROJ_NAME>

mkdir -p backups/tmp && \
rm -rf backups/tmp/* && \
\
sudo docker-compose exec wp bash -c 'apt update && apt install -y mysql-client && mysqldump -h db -u wordpress "--password=<CHANGE_ME>" --single-transaction --events --databases wordpress > /tmp/wp.sql' && \
sudo docker-compose exec wp bash -c 'tar -czf /var/www/html.tar.gz /var/www/html' && \
sudo docker cp <CONTAINER_NAME>:/tmp/wp.sql ./backups/tmp/wp.sql && \
sudo docker cp <CONTAINER_NAME>:/var/www/html.tar.gz ./backups/tmp/ && \
\
cd backups/tmp && \
sudo chown -R ls:ls . && \
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$project_name-backup$BACKUP_SUFFIX.tar.gz
tar -czf $tarball ./* && \
mv $tarball ../ && \
cd .. && \
sudo rm -rf tmp && \
cd ..
