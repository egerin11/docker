pipeline {
    agent { label 'ubuntu' }
    
    environment {
        GIT_CREDENTIALS_ID = 'github'
        IMAGE_VERSION = "1.0.${BUILD_NUMBER}"
    }
    
    stages {
        stage('checkout') {
            steps {
                git branch: 'master',
                    credentialsId: env.GIT_CREDENTIALS_ID,
                    url: 'git@github.com:egerin11/docker.git'
            }
        }
        
        stage('docker build') {
            steps {
                sh '''
                    cd /home/ubuntu/jenkins/workspace/taska/docker/dop_task/
                    docker build -t egerin/dop:$IMAGE_VERSION .
                '''
            }
        }
        
        stage('Deploy Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "docker push egerin/dop:$IMAGE_VERSION"
                    }
                }
            }
        }
        
        stage('rm docker images') {
            steps {
                sh 'docker rm $(docker ps -aq) || true'
            }
        }
        
        stage('connect to instance') {
         steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
            sh """
                ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ubuntu@52.87.163.129 '\
                sudo docker stop \$(sudo docker ps -aq) || true && \
                sudo docker rm \$(sudo docker ps -aq) || true && \
                sudo docker run -d -p 80:80 --name nginx egerin/dop:${IMAGE_VERSION} && \
                exit'
            """
        }
    }
}
    }
}
