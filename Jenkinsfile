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
		    
// 		wrap([$class: 'BuildUser']) {
//                     sh 'echo "${BUILD_USER}"'
//                 }
// 		sh 'echo User.current()'
		    
		wrap([$class: 'BuildUser']) {
                    sh 'echo "Build triggered by ${BUILD_USER}"'
                }
		    
                script {
                    def response = sh(returnStdout: true, script: 'curl -v http://54.236.55.72:5000')
		    println "Response: $response"
			
// 		    sh 'if grep -q "200 OK" $response; then echo "200 OK"; fi'
		    sh 'if sed -n \'/XXX/p\' $response; then echo "Test OK"; else echo "Failure"; fi'
		    def analyzed_response = sh 'sed -n \'/200 OK/p\' $response'
		    sh 'echo "Analyzed rsponse: $analyzed_response"'
		    
		    def substring = response.substring(0, 5)
		    println "Substring: $substring"
			
// 		    def jenkinsUser = currentBuild.getBuildCauses()[0].getUserName()
//                     println "Jenkins user: $jenkinsUser"

// 		    def job = Jenkins.getInstance().getItemByFullName(env.JOB_BASE_NAME, Job.class)
// 		    def build = job.getBuildByNumber(env.BUILD_ID as int)
// 		    def userId = build.getCause(Cause.UserIdCause).getUserId()
			
// 		    def username = currentBuild.getBuildCauses()[0].getUserName()
//                     echo "The job was triggered by user: ${username}"
// 		    println "The job was triggered by user: $username"
			
// 		    def username = env.BUILD_USER
//                     echo "The username who triggered the build is: ${username}"
			
		    def lastCommit = sh(script: 'git log -1', returnStdout: true).trim()
                    def authorMatch = lastCommit =~ /Author: (.*) <.*>/
                    def author = authorMatch ? authorMatch[0][1] : 'Unknown'
                    echo "The last commit was authored by: ${author}"
		
// 		    node {
//   			wrap([$class: 'BuildUser']) {
//     			def user = env.BUILD_USER_ID
//  			}
// 		    }
			
		    def currentDate = new Date()
                    println "Current Date: ${currentDate}"
			
// 		    def myString = "Hello, world!"
// 		    def mySubstring = "worldd"
		    def myString = response
		    def mySubstring = "Hello,"

		    if (myString.contains(mySubstring)) {
    			echo "Substring found"
			def test_status = "200 OK. Successful Test"
		    } else {
   		        echo "Substring not found"
			def test_status = "Test ended with FAILURE"
		    }
		    echo "Test status: $test_status"
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
