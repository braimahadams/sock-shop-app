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

        stage('Check if Ingress Controller is Installed') {
            steps {
                script {
                    // command to check if the ingress controller is installed
                    def isInstalled = sh(script: 'kubectl get svc -n ingress-nginx', returnStatus: true) == 0
                    env.INGRESS_CONTROLLER_INSTALLED = isInstalled
                }
            }
        }
        stage('Install Ingress Controller') {
            when {
                expression { !env.INGRESS_CONTROLLER_INSTALLED }
            }
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
}



