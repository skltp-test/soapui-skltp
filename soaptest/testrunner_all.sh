#!/bin/bash

#-----------------------------------------
# For the directory of this script, set ownership of all files to same as directory
#-----------------------------------------
DIR=$(dirname `readlink -f $0`)
DIR_OWNER=$(stat -c "%u:%g" $DIR)
set -x
chown -R $DIR_OWNER $DIR

#-----------------------------------------
# Run tests
#-----------------------------------------
# -j: Output jUnit XML report
# -r: Pretty print the result at the end of the run.
find . -maxdepth 1 -iname '*soapui-project.xml' -exec echo {} \; -exec /opt/soapui/bin/testrunner.sh {} -j -r \;
