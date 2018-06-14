#!/bin/bash

# 
KEYSTORE=$1
PASSWORD=$2

sed -i -e "s/KEYSTOREVARIABLE/${KEYSTORE}/g;s/PASSWORDVARIABLE/${PASSWORD}/g" soapui-settings.xml
