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
backup 'demolss_lss_db_data'
backup 'demolss_lss_db_etc_mysql'
backup 'demolss_lss_wp_data'
backup 'demolss_ost_db_data'
backup 'demolss_ost_db_etc_mysql'
backup 'demolss_ost_i18n'
backup 'demolss_ost_plugins'
backup 'demolss_ost_upload_files'


