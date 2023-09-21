#! /bin/bash 

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "./soaptest_sed_data.sh {dev|test|qa}"
    exit
fi

if [ "$1" = "dev" ]; then
    COOPERATION_URL="https://dev.api.ntjp.se"
    # COOPERATION_URL="http://ind-dtjp-apache-api-vip.ind1.sth.basefarm.net"
elif [ "$1" = "test" ]; then
    COOPERATION_URL="https://test.api.ntjp.se"
    # COOPERATION_URL="http://ind-ttjp-apache-api-vip.ind1.sth.basefarm.net"
elif [ "$1" = "qa" ]; then
    COOPERATION_URL="https://stage.api.ntjp.se"
    # COOPERATION_URL="http://ind-stjp-apache-api-vip.ind1.sth.basefarm.net"
else
    echo "Illegal parameter"
    echo "./soaptest_sed_data.sh {dev|test|qa}"
    exit
fi
TARGETHOST="$1.esb.ntjp.se"
SOURCESYSTEMHSA="LOAD-MOCKS"
# COOP_AUTH_HEADER="Basic base64EncodedusernamePass"

echo "Tests will be run against the following host: ${TARGETHOST}"

sed -e 's@SOURCESYSTEMHSA@'"${SOURCESYSTEMHSA}"'@; s@TARGETHOST@'"${TARGETHOST}"'@' \
    -e "s,COOPERATION,$COOPERATION_URL,"\
    # -e 's@COOPAUTH@'"${COOP_AUTH_HEADER}"'@' \
        data-sed.xml > data.xml
