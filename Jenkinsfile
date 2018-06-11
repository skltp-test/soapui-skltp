pipeline {

    agent any

    stages {
        stage('SOAP testing') {
            steps {
                // Run the tests
                sh 'cd soaptest && docker-compose run --rm testsuite'
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
