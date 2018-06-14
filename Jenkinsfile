pipeline {

    agent any

    stages {
       stage('SOAP testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B4X', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTPWD')]) {
                    sh """
                        #! /bin/bash 
                        openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTPWD} -noout
                        cd soaptest 
                        sed -i -e "s/KEYSTOREVARIABLE/${CERTKEY}/g; s/PASSWORDVARIABLE/${CERTPWD}/g" soapui-settings.xml
                        cat soapui-settings.xml
                        docker build -t testsuite .
                        docker run -v `pwd`:/usr/src/soapui --rm testsuite -e https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21
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
    }
}
