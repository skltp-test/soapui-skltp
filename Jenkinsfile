pipeline {

    agent any

    stages {
       stage('SOAP testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTKEYPWD')]) {
                    sh """
                        #! /bin/bash 
                        echo "Tests will be run using the following url: ${TEST_ENV}"
                        openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTKEYPWD} -noout
                        cd soaptest 
                        cat ${CERTKEY} > ./cert.p12 
                        ls -l ./cert.p12
                        sed -i -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@KEYSTOREPASSWORD@'"${KEYPWD}"'@' soapui-settings.xml
                        sed -i -e 's@SOURCESYSTEMHSA@'"${SOURCESYSTEMHSA}"'@' data.xml
                        cat data.xml
                        docker build -t testsuite .
                        docker run -v `pwd`:/usr/src/soapui --rm testsuite -e ${TEST_ENV}
                    """
                }
            }
        }
        stage('Load testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTKEYPWD'),
                                 certificate(credentialsId: 'TSTNMT_TRUSTSTORE', keystoreVariable: 'TRUSTKEY', passwordVariable: 'TRUSTKEYPWD')]) {
                    sh """
                        #! /bin/bash
                        echo "Loadtest will be run using the following url: ${TEST_ENV}"
                        cd loadtest
                        cat ${CERTKEY} > ./conf/cert.p12
                        ls -l ./cert.p12
                        sed -i -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@KEYSTOREPASSWORD@'"${CERTKEYPWD}"'@' ./conf/gatling.conf
                        cat ${TRUSTKEY} > ./conf/truststore.p12
                        ls -l ./truststore.p12
                        sed -i -e 's@TRUSTSTOREVARIABLE@'"truststore.p12"'@; s@TRUSTSTOREPASSWORD@'"${TRUSTKEYPWD}"'@' ./conf/gatling.conf
                        docker-compose run --rm testsuite 
                    """
                }
                gatlingArchive()
            }
        }
    }

    post {
        always {
            
            // Archive soaptest results
            junit healthScaleFactor: 100.0, testResults: 'soaptest/TEST*.xml'
            
        }
    }
}
