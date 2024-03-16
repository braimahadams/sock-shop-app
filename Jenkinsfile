pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-Credentials', url: 'https://github.com/braimahadams/sock-shop-app']])
                checkout scm
            }
        }
        
        stage('Terraform Provisioning') {
            steps {
                script {
                    dir('terraform') {
                        sh '''
                            terraform init
                            terraform plan -out=eks_plan
                            terraform apply -auto-approve eks_plan
                        '''
                    }
                }
            }
        }

        stage('Configure Kubectl') {
            steps {
                script {
                    dir('kubernetes') {
                        sh '''
                            aws eks --region eu-west-2 update-kubeconfig --name sock-shop-cluster
                        '''
                    }
                }
            }
        }
        
        stage('Deploy App on Cluster') {
            steps {
                script {
                    echo 'waiting for cluster to be initialized'
                    sleep(time: 1, unit: 'MINUTES')
                    dir('kubernetes') {
                        sh '''
                            kubectl apply -f cluster-autoscaler.yaml
                            kubectl apply -f priorityClass.yaml
                            kubectl apply -f complete-demo.yaml 
                            kubectl apply -f frontend-ingress.yaml


                        '''
                    }
                }
            }
        }
    }
}
