pipeline {
    agent {label "slave1"}

    stages {
	// Checkout from GitHub. This triggers via webhook, using the Jenkisfile 
	// *********************************************************************
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
      
	// Deploying the docker image + container onto the Slave server
	// Flask web-service is auto-launched at port 5000
	// ************************************************************
	stage('Create Flask Image & Deploy Container') {
            steps {		    
                script {
		       sh 'sudo docker build -t proj1_flask_image .'
		       sh "sudo docker run -d -p 5000:5000 --name Proj1_Flask_Container proj1_flask_image '${params.Name}'"
                }
            }
        }
	    	    
	// Testing the Flask web-service is successfully launched
	// ******************************************************
	stage('Perform HTTP Request') {
            steps {		
                script {
		    // Flask web-service successful deployment: information collection
		    // ***************************************************************
                    def response = sh(returnStdout: true, script: 'curl -v http://44.198.159.126:5000')
		    println "Response: $response"
		    
	            // Flask web-service success deployment: analysis of check response
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
	    
	// Testing the Flask web-service is successfully launched
	// ******************************************************
	stage('Build the Test Result CSV File') {
	    steps {				    
		script {		
		    // Current Date: information collection
		    // ************************************
		    //def currentDate = new Date()
                    		    
		    // Build Running User: information collection
		    // ******************************************	    
		    def buildUserFullName = ""
		    wrap([$class: 'BuildUser']) {
                        buildUserFullName = env.BUILD_USER
		    }
		    		    
	            // Compiling the CSV file name & text
		    // **********************************	 
		    def buildTimestamp = currentBuild.getTimeInMillis()
		    def formattedTimestamp = new Date(buildTimestamp).format('yyyy-MM-dd-HHmmss')
		    echo "Build timestamp: ${formattedTimestamp}"
		    def fileName = "/home/ubuntu/proj1FlaskDeployment_test_result_${formattedTimestamp}.csv"
		    def fileText = sh(returnStdout: true, script: "echo 'Jenkins job built by: ${buildUserFullName}; Test status: ${test_status}; Date & Time: ${formattedTimestamp}\n\n'").trim()
		    			
		    writeFile(file: fileName, text: fileText, append: true)
    		}		    
            }
        }
    }
	
    post {
	always {
	    		
	    // During testing phase - auto removal of deployed image + container, supporting the next run
            // ******************************************************************************************
	    sh 'sudo docker stop Proj1_Flask_Container'	
	    sh 'sudo docker rm Proj1_Flask_Container'
	 
	    echo 'Container removed - READY for next run !!!'
	}
    }
}
