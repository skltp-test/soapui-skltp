pipeline {

    agent any

    stages {
        stage('SOAP testing') {
            steps {
                sh "cd soaptest"
                sh "docker build -t testsuite ."
                sh "docker run -v $PWD:/usr/src/soapui -it --rm testsuite -e https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21"
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
