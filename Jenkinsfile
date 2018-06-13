pipeline {

    agent any

    stages {
        stage('SOAP testing') {
            agent {
                dockerfile {
                    dir 'soaptest'
                    args '$PWD:/usr/src/soapui -e https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21'
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
