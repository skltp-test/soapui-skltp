#!/bin/bash

# 
KEYSTORE=$1
PASSWORD=$2

echo ${KEYSTORE}
echo ${PASSWORD}

#sed -e "s/KEYSTOREVARIABLE/${KEYSTORE}/g;s/PASSWORDVARIABLE/${PASSWORD}/g" soapui-settings.xml > tmp.xml
sed -e 's@KEYSTOREVARIABLE@'"${KEYSTORE}"'@; s@PASSWORDVARIABLE@'"${PASSWORD}"'@' soapui-settings.xml > tmp.xml