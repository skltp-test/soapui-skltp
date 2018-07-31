pipeline {

    agent any

    stages {
       stage('SOAP testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTPWD')]) {
                    sh """
                        #! /bin/bash 
                        echo "Tests will be run using the following url: ${TEST_ENV}"
                        openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTPWD} -noout
                        cd soaptest 
                        cat ${CERTKEY} > ./cert.p12 
                        ls -l ./cert.p12
                        sed -i -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@PASSWORDVARIABLE@'"${CERTPWD}"'@' soapui-settings.xml
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
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTPWD')]) {
                    sh """
                        #! /bin/bash
                        echo "Loadtest will be run using the following url: ${TEST_ENV}"
                        cd loadtest
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
