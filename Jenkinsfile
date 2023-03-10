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
                script {
		       sh 'sudo docker build -t proj1_flask_image .'
		       sh "sudo docker run -d -p 5000:5000 --name Proj1_Flask_Container proj1_flask_image '${params.Name}'"
                }
            }
        }
	    
	// Testing the Flask web-service is successfully launched
	// ******************************************************
	stage('Make HTTP Request') {
            steps {
		
		// Build Running User: information collection
		// ******************************************
		wrap([$class: 'BuildUser']) {
                    sh 'echo "Build triggered by ${BUILD_USER}"'
                }
		
                script {
		    // Flask web-service successful deployment: information collection
		    // ***************************************************************
                    def response = sh(returnStdout: true, script: 'curl -v http://54.236.55.72:5000')
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
			
		    // Current Date: information collection
		    // ************************************
		    def currentDate = new Date()
                    println "Current Date: ${currentDate}"
                }
            }
	}
	    
	// Testing the Flask web-service is successfully launched
	// ******************************************************
	stage('Build the Test Results CSV File') {
	    steps {
		script {
		    echo 'Buidling CSV file'
			
		    def buildTimestamp = currentBuild.getTimeInMillis()
		    def formattedTimestamp = new Date(buildTimestamp).format('yyyy-MM-dd-HHmmss')
		    echo "Build timestamp: ${formattedTimestamp}"
		    def fileName = "/home/ubuntu/tests_results_${formattedTimestamp}.csv"
		    def fileText = "Jenkins job built by: BUILD_USER, Test status: ${test_status}, Date & Time: ${formattedTimestamp}"
		    println "File name: ${fileName}"
// 			println "File text: ${fileText}"
			
		    writeFile(file: fileName, text: fileText, append: true)
// 		    echo 'Hello, World!' >> tests_results3.csv
			
		    		}
// 		echo 'Buidling CSV file'
// 		writeFile(file:'/home/ubuntu/tests_results.csv', text: 'Hello, World!\n', append: true)
// 		writeFile(file: '/home/ubuntu/tests_results.csv', text: 'Hello, World!\n')
// 		echo 'Hello World!' >> tests_results.csv
		
// 		cat tests_results.csv
		
// 		echo "This text will also be appended" >> /home/ubuntu/myfile.txt
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
