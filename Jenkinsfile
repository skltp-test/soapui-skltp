pipeline {

    agent any

    stages {
        stage('SOAP testing') {
            steps {
                sh "cd soaptest; docker build -t testsuite -f soaptest/Dockerfile ."
                sh "docker run -v `pwd`:/usr/src/soapui --rm testsuite -e https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21"
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