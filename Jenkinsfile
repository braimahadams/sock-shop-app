pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-Credentials', url: 'https://github.com/braimahadams/sock-shop-app']])
                checkout scm
            }
        }
        
        
    }
}
