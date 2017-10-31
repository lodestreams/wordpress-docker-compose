#!/usr/bin/env bash

readonly NOW=`date +"%Y-%m-%d-%H-%M-%S"`
readonly DEST=`pwd`/backups

function backup {
  ./backup_volume.sh $1 "$DEST/$NOW/"
}

# Create archive folder
echo rm -rf "$DEST/$NOW", waiting for 3s
sleep 3
rm -rf "$DEST/$NOW"

echo mkdir -p "$DEST/$NOW"
mkdir -p "$DEST/$NOW"

# Backup
readonly volumes=`docker-compose ps -q | xargs docker container inspect  \
                 -f '{{ range .Mounts }}{{ .Name }} {{ end }}' \
                 | xargs -n 1 echo`
readonly volumes_arr=($volumes)
for i in "${volumes_arr[@]}"
do
   backup "$i"
done

