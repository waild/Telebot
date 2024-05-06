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
                sh "TARGETOS=${OS} TARGETARCH=${ARCH} make image"
            }
        }

        stage('push') {
            steps {
                echo "PUSH IMAGE"
                script{
                    docker.withRegistry('https://ghcr.io', 'ghcr-credentials') {
                        sh 'make push'
                    }
                }
            }
        }
    }
}