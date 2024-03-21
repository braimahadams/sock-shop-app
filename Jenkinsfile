def groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[credentialsId: 'Github-Credentials', url: 'https://github.com/braimahadams/sock-shop-app']]
                )
            }
        }


        stage('Terraform Destroy') {
           steps {
               script {
                dir ('terraform') {
                    groovy.destroyTerraform ()    
                }
               }
           }
        }
    }
}
