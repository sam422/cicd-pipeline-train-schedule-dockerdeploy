pipeline {
    agent any
    environment {
    FULL_PATH_BRANCH = "${sh(script:'git name-rev --name-only HEAD', returnStdout: true)}"
    GIT_BRANCH = FULL_PATH_BRANCH.substring(FULL_PATH_BRANCH.lastIndexOf('/') + 1, FULL_PATH_BRANCH.length())
  }
    stages {
        stage('checkout'){
            steps{
                echo 'Git checkout Master'
                git branch: 'master', url: 'https://github.com/sam422/cicd-pipeline-train-schedule-dockerdeploy.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Running build automation'
                echo 'Branch Name is ${GIT_BRANCH}'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
         stage('Build Docker Image') {
           /* when {
                expression {
                return env.BRANCH_NAME = 'master';
                return env.GIT_BRANCH = 'master';
                }
            }*/
              steps {
                script {
                    app = docker.build("msvkumar/sam422")
                    app.inside {
                        sh 'echo $(curl localhost:8081)'
                    }
                }
            }
        }
        stage('Pipeline scans using Sken') {
          /*  when {
                branch 'master'
            }*/
            steps {
               skenai appId: '2c7b91b8-b8ee-48ff-851f-66d7eb47c143', orgId: 'd3a8ea44-ae17-4013-b9db-3f79f29ead77'
            }
        }
        stage('Scan Docker Image using clair scan') {
           /* when {
                branch 'master'
            }*/
            steps {
                script {
                    
                        
                        sh './clair-scanner --ip 10.0.1.16 vulhub/flask:1.1.1'
                       
                }
            }
        }
        stage('Push Docker Image') {
      /*      when {
                branch 'master'
            }*/
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
    }   
}
