#!/usr/bin/env bash

readonly NOW=`date +"%Y-%m-%d-%H-%M-%S"`
readonly DEST=`pwd`/backups

function backup {
  ./backup_volume.sh $1 "$DEST/$NOW/"
}


function confirm_or_quit {
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi
}

function delete_old_backups {
  ls -At | tail -n +$KEEP
  echo 'is going to be deleted,' && confirm_or_quit
  ls -At | tail -n +$KEEP | xargs rm --
}

# Delete old backups
cd $DEST
old_backups=`ls -At | tail -n +$KEEP | wc -l`;
if (( old_backups > 0 )); then
  delete_old_backups
fi

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
