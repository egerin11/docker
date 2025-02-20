    pipeline {
        agent { label 'ubuntu' }
        
        environment {
            GIT_CREDENTIALS_ID = 'github'
            IMAGE_VERSION = "2.0.${BUILD_NUMBER}"
        }
        
        stages {
            stage('checkout') {
            steps {
                cleanWs()
                git branch: 'master',
                    credentialsId: env.GIT_CREDENTIALS_ID,
                    url: 'git@github.com:egerin11/docker.git'
            }
        }

         stage('docker build') {
    steps {
        sh '''
            docker system prune -af  
            cd /home/ubuntu/jenkins/workspace/taska/docker/nginx/
            docker build --no-cache --build-arg CACHE_INVALIDATE="$(date +%s)" -t egerin/nginx_work:$IMAGE_VERSION .
            cd /home/ubuntu/jenkins/workspace/taska/docker/apache80/
            docker build --no-cache -t egerin/apache80_test:$IMAGE_VERSION .
        '''
    }
}
            
            stage('Deploy Image') {
                steps {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                            sh "docker push egerin/nginx_work:$IMAGE_VERSION"
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
                        sh '''
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@52.87.163.129 '\
                            sudo docker stop $(sudo docker ps -aq) || true && \
                            sudo docker rm $(sudo docker ps -aq) || true && \
                            sudo docker rmi -f $(sudo docker images -aq) || true && \
                            sudo docker network rm my_network || true && \
                            sudo docker network create --driver bridge my_network && \
                            sudo docker pull egerin/apache80_test:'${IMAGE_VERSION}' && \
                            sudo docker run -d -p 8080:8080 --network my_network --name apache egerin/apache80_test:'${IMAGE_VERSION}' && \
                            exit'
                        '''
                    }
                }
            }

            stage('deploy containers') {
                steps {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@52.87.163.129 '\
                            sudo docker pull egerin/nginx_work:'${IMAGE_VERSION}' && \
                            sudo docker run -d -p 443:443 -p 80:80 --network my_network --name nginx egerin/nginx_work:'${IMAGE_VERSION}' && \
                            exit'
                        '''
                    }
                }
            }
                    }
    }
