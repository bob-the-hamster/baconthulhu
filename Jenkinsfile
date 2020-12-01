pipeline {
    
    agent any
    stages {
        stage('build-image') {
            steps {
                sh 'docker build --tag baconthulhu_build_env ./dockerenv/'
            }
        }
        stage('build-distrib') {
            agent { docker { image 'baconthulhu_build_env' } }
            steps {
                sh './distrib.sh'
            }
        }
    }
}
