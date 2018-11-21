#!/bin/sh

#For the directory of this script, set ownership of all files to same as directory

DIR=$(dirname `readlink -f $0`)
DIR_OWNER=$(stat -c "%u:%g" $DIR)
set -x
chown -R $DIR_OWNER $DIR
