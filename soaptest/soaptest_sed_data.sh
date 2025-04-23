#! /bin/bash 

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "./soaptest_sed_data.sh {dev|test|qa|vmdev}"
    exit
fi

ENVIRONMENT_VAR=$1

if [ "$1" = "dev" ]; then
    COOPERATION_URL="https://dev.api.ntjp.se"
    # COOPERATION_URL="http://ind-dtjp-apache-api-vip.ind1.sth.basefarm.net"
elif [ "$1" = "test" ]; then
    COOPERATION_URL="https://test.api.ntjp.se"
    # COOPERATION_URL="http://ind-ttjp-apache-api-vip.ind1.sth.basefarm.net"
elif [ "$1" = "qa" ]; then
    COOPERATION_URL="http://ind-stjp-apache-api-vip.ind1.sth.basefarm.net"
elif [ "$1" = "vmdev" ]; then
    COOPERATION_URL="https://dev.api.ntjp.se"
else
    echo "Illegal parameter"
    echo "./soaptest_sed_data.sh {dev|test|qa|vmdev}"
    exit
fi

if [ "$1" = "vmdev" ]; then
    TARGETHOST="dev.esb.ntjp.se/vm"
else
    TARGETHOST="$1.esb.ntjp.se"
fi


echo "Tests will be run against the following host: ${TARGETHOST}"

sed -e "s,TARGETHOST,$TARGETHOST," \
    -e "s,COOPERATION,$COOPERATION_URL,"\
	-e "s,ENVIRONMENT,$ENVIRONMENT_VAR,"\
        data-sed.xml > data.xml
