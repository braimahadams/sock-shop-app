def groovy
pipeline {
    agent any
    parameters {
        booleanParam(name: 'terraformProvisioning', defaultValue: true, description: 'Deploy the sock-shop app to EKS cluster')
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-Credentials', url: 'https://github.com/braimahadams/sock-shop-app']])
            }
        }

        stage ('init') {
            steps {
                script {
                    groovy = load "script.groovy"

                }
            }

        }
        
        stage('Provisioning EKS Cluster with Terraform') {
            steps {
                script {
                    groovy.provisionTerraform ()
                }
            }
        }

        stage('updating Kubeconfig File') {
            steps {
                script {
                    groovy.updateKubeconfig ()
                }
            }
        }

        stage('Installing Ingress Controller') {
            steps {
                script {
                    groovy.intallIngressController ()
                }
            }
        }

        stage('Mapping Domain to Load Balancer External IP') {
            steps {
                script {
                    groovy.mapDnsToExternalIp ()
                }
            }
        }

        stage('Deploying Sock-Shop App to EKS Cluster') {
            steps {
                script {
                    groovy.deploySockShopApp ()
                }
            }
        }

        stage('Deploying Prometheus and Grafana') {
            steps {
                script {
                    groovy.deployPrometheusAndGrafana ()
                }
            }
        }

        stage('Deploying Alertmanager for Sending Alerts to Slack Channel') {
            steps {
                script {
                    groovy.deployAlertManager ()
                }
            }
        }

        stage('Terraform Destroy') {
           steps {
               script {
                   groovy.destroyTerraform ()
               }
           }
        }
    }
    
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'Pipeline executed successfully'
        }

        failure {
            echo 'Pipeline execution failed'
        }
    }
}



