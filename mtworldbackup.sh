#!/bin/bash
# Utility script to stage current backup of Minetest world data is ~/.mtworldback.
# Stop Minetest before running this script to ensure a usable backup.
cd /home/$USER
mtuser=${USER}
# Overwrite mtuser if -u flag is used to indicate a specific minetest user. Default is current user.
while getopts 'u:' OPTION; do
	case "$OPTION" in
		u) # Indicates minetest user with map data
			echo "mtuser set to ${OPTARG}"
			mtuser=$OPTARG
			;;
	esac
done

# Check target user for mt world data directory
if [ ! -d "/home/${mtuser}/" ]; then
	echo "User $mtuser not found!"
	exit 1
fi

if [ ! -d "/home/${mtuser}/.minetest/" ]; then
	echo "Minetest data not found for user, ${mtuser}!"
	exit 1
fi

if [ ! -d "/home/${mtuser}/.minetest/worlds/" ]; then
	echo "No world data found to back up!"
	exit 0
fi

# Make backup data directory if does not exist
if [ ! -d ".mtworldbackup" ]; then
	echo "Creating minetest data directory '.mtworldbackup'"
	mkdir .mtworldbackup
fi

# Create backups in backup directory
cd ~/.mtworldbackup
if [ ! -d "backups" ]; then
	echo "Creating backup directory '.mtworldbackup/backups'"
	mkdir backups
fi
# Iterate through worlds and make tar.gz of each world dir (Overwrites exiting backup)
for path in /home/${mtuser}/.minetest/worlds/*; do
	[ -d "${path}" ] || continue #
	dirname="$(basename "${path}")"
	echo "Backing up $dirname"
	tar -zcvf ./backups/${dirname}.tar.gz ${path}
done
exit 0
