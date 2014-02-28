#!/bin/bash
USER=stephen
IP=192.168.1.7
DIR=Development/Botball2014

rsync -P --delete -rl -e ssh --exclude-from=.exclude \
  $USER@$IP:/home/$USER/$DIR/* .
lua $1
