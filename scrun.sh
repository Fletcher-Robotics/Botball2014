#!/bin/bash
# Copies all files (except those in .exclude) to the local computer from
# computer at IP
USER=stephen
#IP=192.168.1.7
DIR=Development/Botball2014
#USER=botball
IP=192.168.1.2
#DIR=Desktop/Botball2014

rsync -P --delete -rl -e ssh --exclude-from=.exclude --delete-excluded \
  $USER@$IP:/home/$USER/$DIR/. .

if [ $# -eq 1 ]; then
	time lua $1
	lua -e "(require 'lualink.motor').ao()"
fi
