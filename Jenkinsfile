pipeline {
    agent any

    stages {
        stage('Pull from GitHub') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/skaufma1/proj1-repo.git']])
            }
        }
	stage('Deploy Flask Container') {
            steps {
                sh "echo ${params.NAME}"
                
                script {
                    sudo def dockerImage = docker.build('proj1_flask_image')
                    sudo dockerImage.push()
                }
            }
        }
    }
}
