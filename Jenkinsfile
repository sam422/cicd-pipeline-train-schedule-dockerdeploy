pipeline {
    agent any
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
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
         stage('Build Docker Image') {
            when {
                return env.BRANCH_NAME = 'master';
            }
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
            when {
                branch 'master'
            }
            steps {
               skenai appId: '2c7b91b8-b8ee-48ff-851f-66d7eb47c143', orgId: 'd3a8ea44-ae17-4013-b9db-3f79f29ead77'
            }
        }
         stage('Scan Docker Image using clair scan') {
            when {
                branch 'master'
            }
            steps {
                script {
                    
                        
                        sh 'clair-scanner_linux_amd64 -w example-alpine-scan.yaml --ip 10.10.10.12 msvkumar/sam422'
                       
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
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
