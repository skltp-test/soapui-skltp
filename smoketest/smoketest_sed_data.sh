#! /bin/bash 

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "./soaptest_sed_data.sh {dev|test|qa}"
    exit
fi

TARGETHOST="$1.esb.ntjp.se"
SOURCESYSTEMHSA="LOAD-MOCKS"

echo "Tests will be run against the following host: ${TARGETHOST}"

sed -e 's@SOURCESYSTEMHSA@'"${SOURCESYSTEMHSA}"'@; s@TARGETHOST@'"${TARGETHOST}"'@' \
        data-sed.xml > data.xml
