pipeline {
    agent { docker { image 'debian/stable' } }
    stages {
        stage('build') {
            steps {
                sh './distrib.sh'
            }
        }
    }
}
