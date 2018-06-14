pipeline {

    agent any

    stages {
       stage('SOAP testing') {
            steps {
                withCredentials([certificate(credentialsId: 'TSTNMT2321000156-B4X', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTPWD')]) {
                    sh "openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTPWD} -noout"
                    sh "cd soaptest; docker build -t testsuite ."
                    sh "docker run -v `pwd`:/usr/src/soapui --rm testsuite -e https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21"
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
