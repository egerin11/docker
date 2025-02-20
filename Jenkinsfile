    pipeline {
        agent { label 'ubuntu' }
        
        environment {
            GIT_CREDENTIALS_ID = 'github'
            IMAGE_VERSION = "2.0.${BUILD_NUMBER}"
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
                        docker rmi -f $(docker images -aq)
                        cd /home/ubuntu/jenkins/workspace/taska/docker/nginx/
                        docker build  --no-cache -t egerin/nginx_test:$IMAGE_VERSION .
                        cd /home/ubuntu/jenkins/workspace/taska/docker/apache80/
                        docker build   --no-cache -t egerin/apache80_test:$IMAGE_VERSION .
                    '''
                }
            }
            
            stage('Deploy Image') {
                steps {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                            sh "docker push egerin/nginx_test:$IMAGE_VERSION"
                            sh "docker push egerin/apache80_test:$IMAGE_VERSION"
                        }
                    }
                }
            }
            
            stage('rm docker images') {
                steps {
                    sh 'docker rm $(docker ps -aq) || true'
                }
            }
            
        stage('cleanup containers') {
        steps {
            withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
                sh """
                    ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ubuntu@52.87.163.129 '\
                    sudo docker stop \$(sudo docker ps -aq) || true && \
                    sudo docker rm \$(sudo docker ps -aq) || true && \
                    docker rmi -f $(docker images -aq) || true && \
                    docker network rm my_network || true  && \
                    docker network create --driver bridge my_network &&\
                    docker run  -d -p 8080:8080  --network my_network --name apache egerin/apache80_test:${IMAGE_VERSION} && \
                    exit'
                """
            }
        }
    }

    stage('deploy containers') {
        steps {
            withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
                sh """
                    ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ubuntu@52.87.163.129 '\
                
                    sudo docker run -d -p 443:443 -p 80:80 --network my_network --name nginx egerin/nginx_test:${IMAGE_VERSION} && \
                    exit'
                """
            }
        }
    }
        }
    }
