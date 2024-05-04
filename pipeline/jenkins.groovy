pipeline {
    agent any
    environment {
        GHCR_CREDENTIALS=credentials('github-app-creds')
    }
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick ARCH')
    }
    stages {
        stage('clone') {
            steps {
                echo 'CLONE REPOSITORY'
                git branch: "${BRANCH}", url: "${REPO}" 
            }
        }

        stage('test') {
            steps {
                echo "TEST EXECUTION"
                sh 'make test'
            }
        }

        stage('image') {
            steps {
                echo "BUILD IMAGE"
                sh 'make linux'
            }
        }

        stage('push') {
            steps {
                echo "PUSH IMAGE"
                docker.withRegistry('https://ghcr.io', GHCR_CREDENTIALS) {
                    sh 'make push'
                }
                
            }
        }
    }
}