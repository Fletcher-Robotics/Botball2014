#!/bin/bash
# Copies all files (except those in .exclude) to the local computer from
# computer at IP

if [ $1 = "lubuntu" ]; then
	USER=stephen
	IP=192.168.1.93
	DIR=Development/Botball2014
else
	USER=stephen
	IP=192.168.1.3
	DIR=Development/Botball2014
fi

rsync -P --delete -rl -e ssh --exclude-from=.exclude --delete-excluded \
  $USER@$IP:/home/$USER/$DIR/. .

if [ $# -eq 2 ]; then
	CIDR=$(pwd)
	cd $(dirname $2)
	time lua $(basename $2)
	cd $CDIR
	lua -e "(require 'lualink.motor').ao()"
fi
