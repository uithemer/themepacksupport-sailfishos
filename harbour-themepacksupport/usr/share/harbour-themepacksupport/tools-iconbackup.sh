#!/bin/bash

# Set directory variables
main=/usr/share/harbour-themepacksupport

name="uithemerbackup_"$(date +%Y%m%d%H%M%S)

echo "creating icons backup..."

if [ ! -d $main/backup/icons ]; then
	$main/icon-backup.sh
fi

cd $main/backup/
tar -zcf /home/defaultuser/$name.tar.gz ./icons
chown defaultuser:defaultuser /home/defaultuser/$name.tar.gz

echo "/home/defaultuser/$name.tar.gz created"
