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
		    
                script {
                    def response = sh(returnStdout: true, script: 'curl -v http://35.153.60.106:5000')
		    println "Response: $response"
			
// 		    sh 'if grep -q "200 OK" $response; then echo "200 OK"; fi'
		    sh 'if sed -n \'/XXX/p\' $response; then echo "Test OK"; else echo "Failure"; fi'
		    
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
			
		    def currentDate = new Date()
                    println "Current Date: ${currentDate}"
                }
            }
        }
    }
}
