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
//                 sh 'sudo su'
// 		   sh 'sudo docker build -t proj1_flask_image .'
		   		    
                script {
//                     docker build -t 'proj1_flask_image' .
		       /usr/bin/docker.build("proj1_flask_image", "--user=root .")
                }
            }
        }
    }
}
