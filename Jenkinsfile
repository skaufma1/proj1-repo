pipeline {
    agent {label "slave1"}
    stages {
	// Checkout from GitHub. This triggers via webhook, using the Jenkisfile 
	// *********************************************************************
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
      
	// Deploying the docker image + container onto the Slave server
	// Flask web-service is auto-launched at port 5000
	// ************************************************************
	stage('Deploy Flask Container') {
            steps {
                sh "echo ${params.Name}"
				   		    
                script {
		       sh 'sudo docker build -t proj1_flask_image .'
		       sh "sudo docker run -d -p 5000:5000 --name Proj1_Flask_Container proj1_flask_image '${params.Name}'"
                }
            }
        }
	    
	// Testing the Flask web-service is successfully launched
	// ******************************************************
	stage('Make HTTP request') {
            steps {
		
		// Collecting the build-run initiating user
		// ****************************************
		wrap([$class: 'BuildUser']) {
                    sh 'echo "Build triggered by ${BUILD_USER}"'
                }
		
// 		def currentDate = new Date()
//                 println "Current Date: ${currentDate}"
		
                script {
                    def response = sh(returnStdout: true, script: 'curl -v http://54.236.55.72:5000')
		    println "Response: $response"
			
			
		    def currentDate = new Date()
                    println "Current Date: ${currentDate}"
			
// 		    def myString = "Hello, world!"
// 		    def mySubstring = "worldd"
		    def myString = response
		    def mySubstring = "Hello,"

		    if (myString.contains(mySubstring)) {
    			echo "Substring found"
			test_status = "200 OK. Successful"
		    } else {
   		        echo "Substring not found"
			test_status = "FAILURE"
		    }
		    echo "Test status: ${test_status}"
                }
            }
        }
    }
	
    post {
	always {
	    sh 'sudo docker stop Proj1_Flask_Container'	
	    sh 'sudo docker rm Proj1_Flask_Container'
	 
	    echo 'Container removed - READY for next run !!!'
	}
    }
}
