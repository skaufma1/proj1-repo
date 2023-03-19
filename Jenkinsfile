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
	stage('Test: Perform HTTP Request') {
            steps {		
                script {
		    // Flask web-service successful deployment: information collection
		    // ***************************************************************
                    def response = sh(returnStdout: true, script: 'curl -v http://3.238.55.1:5000')
		    println "Response: $response"
		    
	            // Flask web-service success deployment: analysis of check response
		    def myString = response
		    def mySubstring = "Hello,"

		    if (myString.contains(mySubstring)) {
    			echo "Substring found"
			test_status = "Success"
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
		    
		    env.FILE_NAME = fileName
		    env.DATETIME = formattedTimestamp
		    env.BUILD_USER_NAME = buildUserFullName
		    env.BUILD_USER_NAME_no_spaces = env.BUILD_USER_NAME.replaceAll(' ', '_')
	            env.TESTSTATUS = test_status
		
		    // Creating a CSV file with the needed text (file will be later on loaded to AWS S3 service)
		    // *****************************************************************************************
		    writeFile(file: fileName, text: fileText)
    		}
		
		// CSV file upload to AWS S3
		// *************************
		withAWS(region: 'us-east-1', credentials: 'awscredentials') {
		    s3Upload(bucket: 'proj1-flask-bucket', path: '', file: env.FILE_NAME)
		}
		    		    
		// Data upload to AWS DynamoDB table
		// *********************************
		script {		
		    withAWS(credentials: 'awscredentials', region: 'us-east-1') {
			sh '''
 			   aws dynamodb put-item \
 			        --table-name proj1-flask-dyndb \
 			        --item \
 			         '{"DateTime": {"S": "'$DATETIME'"}, "TestJobRunBy": {"S": "'$BUILD_USER_NAME_no_spaces'"}, "TestStatus": {"S": "'$TESTSTATUS'"}}' \
 				--return-consumed-capacity TOTAL
			   '''
		    } 
		}		    
            }
        }
	    
	// Cleanup
	// ****************************
	stage('Cleanup - Job Ending') {
	    steps {	   
		script {
			
	            // Auto removal of deployed container, supporting the next run
                    // ***********************************************************
	            sh 'sudo docker stop Proj1_Flask_Container'	
	            sh 'sudo docker rm Proj1_Flask_Container'
			
	    	    echo 'Container removed - READY for next run !!!'
		
		    // Removing the temporary file (loaded already to S3)
		    // **************************************************
	    	    sh 'rm ${FILE_NAME}'
			
		    if (test_status == 'FAILURE') {
		       error 'Job ends with FAILURE !!! - due to Erred Test Check at the Deployed Web-Service'
		    }
		}
	    }
	}
    }
}
