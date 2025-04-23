pipeline {
    agent any
    parameters {
        booleanParam(name: 'RUN_CORE', defaultValue: true, description: 'Kör tester av kärnfunktionalitet')
        booleanParam(name: 'RUN_EI', defaultValue: true, description: 'Kör EI-tester')
        booleanParam(name: 'RUN_AGP', defaultValue: true, description: 'Kör tester för aggregerande tjänster')
        booleanParam(name: 'RUN_REST', defaultValue: true, description: 'Kör REST-tester')
        booleanParam(name: 'RUN_ADAPTER', defaultValue: true, description: 'Kör adapter-tester')
    }
    stages {
       stage('Prepare SOAP testing') {
            steps {
                withCredentials([
                    certificate(credentialsId: 'TSTNMT2321000156-B02', keystoreVariable: 'CERTKEY', passwordVariable: 'CERTKEYPWD'),
                    string(credentialsId: 'ntjp-cooperation-auth-header', variable: 'COOP_AUTH_HEADER')
                ]) {
                    sh """
                        #! /bin/bash
                        echo "Tests will be run against the following host: ${TARGETHOST}"
                        openssl pkcs12 -info -in ${CERTKEY} -passin pass:${CERTKEYPWD} -noout
                        cd soaptest
                        cat ${CERTKEY} > ./cert.p12
                        ls -l ./cert.p12
                        sed -e 's@KEYSTOREVARIABLE@'"cert.p12"'@; s@KEYSTOREPASSWORD@'"${CERTKEYPWD}"'@' soapui-sed.xml > soapui-settings.xml
						sed -e 's@TARGETHOST@'"${TARGETHOST}"'@' \
							-e 's@COOPERATION@'"${params.COOPERATION_URL}"'@; s@COOPAUTH@'"${COOP_AUTH_HEADER}"'@' \
							-e 's@ENVIRONMENT@'"${ENVIRONMENT_VAR}"'@' \
							data-sed.xml > data.xml
                        rm -f ./report/*
                        docker build -t testsuite .
                    """
                }
            }
        }
        stage('Run core tests') {
             when {
                expression { return params.RUN_CORE }
            }
            steps {
                sh """
                    cd soaptest
                    docker run -v `pwd`:/usr/src/soapui --rm testsuite 'SKLTP-Core-*soapui-project.xml'
                """
            }
        }
        stage('Run EI tests') {
            when {
                expression { return params.RUN_EI }
            }
            steps {
                sh """
                    cd soaptest
                    docker run -v `pwd`:/usr/src/soapui --rm testsuite 'SKLTP-EI-*soapui-project.xml'
                """
            }
        }
        stage('Run AgP tests') {
            when {
                expression { return params.RUN_AGP }
            }
            steps {
                sh """
                    cd soaptest
                    docker run -v `pwd`:/usr/src/soapui --rm testsuite 'SKLTP-AgP-*soapui-project.xml'
                """
            }
        }
        stage('Run REST tests') {
            when {
                expression { return params.RUN_REST && !params.TARGETHOST.contains('vm') }
            }
            steps {
                sh """
                    cd soaptest
                    docker run -v `pwd`:/usr/src/soapui --rm testsuite 'SKLTP-REST-*soapui-project.xml'
                """
            }
        }
        stage('Run adapter tests') {
            when {
                expression { return params.RUN_ADAPTER && !params.TARGETHOST.contains('vm') }
            }
            steps {
                sh """
                    cd soaptest
                    docker run -v `pwd`:/usr/src/soapui --rm testsuite 'SKLTP-Adapter-*soapui-project.xml'
                """
            }
        }
    }
    post {
        always {
            // Archive soaptest results
            junit healthScaleFactor: 100.0, testResults: 'soaptest/report/*.xml'


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
					to: "${params.EMAIL_ON_FAIL_DEST}"
				)
			}
        }
    }
}
