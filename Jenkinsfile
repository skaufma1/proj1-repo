pipeline {
    agent {label "slave1"}
    stages {
	stage('Checkout SCM') {
	    steps {
		 checkout([
			 $class: 'GitSCM',
			 branches: [[name: 'main']],
			 userRemoteConfigs: [[
				 url: 'https://github.com/skaufma1/proj1-repo.git',
				 credentialsId: ''
				 ]]
			 ])		    
	    }		
	}
//         stage('Pull from GitHub') {
//             steps {
//                 checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/skaufma1/proj1-repo.git']])
//             }
//         }
	stage('Deploy Flask Container') {
            steps {
                sh "echo ${params.Name}"
//                 sh 'sudo su'
// 		   sh 'sudo docker build -t proj1_flask_image .'
				   		    
                script {
//                     docker build -t proj1_flask_image .
// 		       def dockerImage = docker.build("proj1_flask_image", "--user=root .")
		       sh 'sudo docker build -t proj1_flask_image .'
		       sh "sudo docker run -d -p 5000:5000 --name Proj1_Flask_Container proj1_flask_image '${params.Name}'"
                }
            }
        }
    }
}
