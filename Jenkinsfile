pipeline {
    agent {label "slave1"}
    stages {
	stage('CheckoutSCM') {
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

	stage('Deploy Flask Container') {
            steps {
                sh "echo ${params.Name}"
				   		    
                script {
		       sh 'sudo docker build -t proj1_flask_image .'
		       sh "sudo docker run -d -p 5000:5000 --name Proj1_Flask_Container proj1_flask_image '${params.Name}'"
                }
            }
        }
	stage('Make HTTP request') {
            steps {
                script {
                    def response = sh(returnStdout: true, script: 'curl -v http://44.200.235.249:5000')
                    println "Response: $response"
			
		    def jenkinsUser = currentBuild.getBuildCauses()[0].getUserName()
                    println "Jenkins user: $jenkinsUser"
                }
            }
        }
    }
}
