pipeline {

    agent any
    parameters {
        string(name: 'COOPERATION_URL', defaultValue: 'http://ind-ptjp-apache-api-vip.ind1.sth.basefarm.net', description: 'nod för takapi att testa, lämna tom för att stå över')
    }
    stages {
       stage('SOAP testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTKEYPWD')]) {
                    sh """
                        #! /bin/bash
                        echo "Tests will be run against the following host: ${TARGETHOST}"
                        openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTKEYPWD} -noout
                        cd soaptest
                        cat ${CERTKEY} > ./cert.p12
                        ls -l ./cert.p12
                        sed -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@KEYSTOREPASSWORD@'"${CERTKEYPWD}"'@' soapui-sed.xml > soapui-settings.xml
                        sed -e 's@SOURCESYSTEMHSA@'"${SOURCESYSTEMHSA}"'@; s@TARGETHOST@'"${TARGETHOST}"'@'  \
                            -e  's,COOPERATION,'"${params.COOPERATION_URL}"','\
                                 data-sed.xml > data.xml
                        cat data.xml
                        docker build -t testsuite .
                        docker run -v `pwd`:/usr/src/soapui --rm testsuite
                    """
                }
            }
        }
    }

    post {
        always {
            // Archive soaptest results
            junit healthScaleFactor: 100.0, testResults: 'soaptest/TEST*.xml'            
        }
        unstable {
            // Set failed when failed tests
            script {
                currentBuild.result = 'FAILED'
            }
        }
        failure {
			script {
				emailext (
					body: '''${FAILED_TESTS}\nSe ${BUILD_URL}''', 
					subject: '''Felutfall: ${PROJECT_NAME}''', 
					to: 'fd8ba3ec.inera.se@emea.teams.ms'
				)
			}
        }
    }
}
