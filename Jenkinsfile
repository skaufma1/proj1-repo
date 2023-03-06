pipeline {
    agent any

    stages {
        stage('Pull from GitHub') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/skaufma1/proj1-repo.git']])
            }
        }
    }
}
