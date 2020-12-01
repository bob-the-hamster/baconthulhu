pipeline {
    
    agent any
    stages {
        stage('build-image') {
            steps {
                sh 'docker build -tag baconthulhu_build_env ./dockerenv/'
            }
        }
        stage('build-distrib') {
            agent { docker { image 'debian:stable' } }
            steps {
                sh './distrib.sh'
            }
        }
    }
}
