#!/usr/bin/env bash
# sudo ./backup_volume.sh <VOLUME> `pwd`/backups

echo "Backing up volume $1 to $2"

sudo docker run -it --rm -v $1:/volume -v $2:/backups alpine tar -cjf /backups/$1.tar.bz2 -C /volume ./
