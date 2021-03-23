#! /bin/bash 

if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters"
    echo "./soaptest_local.sh TARGETHOST CERTKEY CERTKEYPWD SOURCESYSTEMHSA"
    exit
fi

TARGETHOST=$1
CERTKEY=$2
CERTKEYPWD=$3
SOURCESYSTEMHSA=$4
COOPERATION_URL=${COOPERATION_URL:-COOPERATION}

echo "Tests will be run against the following host: ${TARGETHOST}"
openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTKEYPWD} -noout
ls -l ./cert.p12
sed -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@KEYSTOREPASSWORD@'"${CERTKEYPWD}"'@' soapui-sed.xml > soapui-settings.xml
sed -e 's@SOURCESYSTEMHSA@'"${SOURCESYSTEMHSA}"'@; s@TARGETHOST@'"${TARGETHOST}"'@' \
    -e  "s,COOPERATION,$COOPERATION_URL,"\
        data-sed.xml > data.xml

cat data.xml
docker build -t testsuite .
docker run -v `pwd`:/usr/src/soapui --rm testsuite

