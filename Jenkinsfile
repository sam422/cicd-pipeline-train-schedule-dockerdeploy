pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
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
               skenai appId: '784cd345-991f-44a7-9e5f-e6e0925dbd00', orgId: 'd3a8ea44-ae17-4013-b9db-3f79f29ead77'
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
        stage ('DeployToProduction') {
    when {
        branch 'master'
    }
    steps {
        input 'Deploy to Production'
        milestone(1)
        withCredentials ([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
            script {
                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@${env.prod_ip} \"docker pull <DOCKER_HUB_USERNAME>/train-schedule:${env.BUILD_NUMBER}\""
                try {
                   sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@${env.prod_ip} \"docker stop train-schedule\""
                   sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@${env.prod_ip} \"docker rm train-schedule\""
                } catch (err) {
                    echo: 'caught error: $err'
                }
                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@${env.prod_ip} \"docker run --restart always --name train-schedule -p 8080:8080 -d <DOCKER_HUB_USERNAME>/train-schedule:${env.BUILD_NUMBER}\""
            }
        }
    }
}
    }   
}
