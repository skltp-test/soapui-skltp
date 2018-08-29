#!/bin/bash

# -j: Output jUnit XML report
# -r: Pretty print the result at the end of the run.
find . -maxdepth 1 -iname '*soapui-project.xml' -exec echo {} \; -exec /opt/soapui/bin/testrunner.sh {} -j -r \;
