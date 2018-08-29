#!/bin/bash
find . -maxdepth 1 -iname '*soapui-project.xml' -exec echo {} \; -exec /opt/soapui/bin/testrunner.sh {} -j -r \;
