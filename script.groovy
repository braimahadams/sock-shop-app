def provisionTerraform () {
    dir('terraform') {
        sh ''' 
            terraform init
            terraform plan -out=eks_plan
            terraform apply --auto-approve eks_plan
        '''
    }
}


def updateKubeconfig () { 
    sh '''
        aws eks --region eu-west-2 update-kubeconfig --name sock-shop-cluster
    '''
    }

def intallIngressController () {
    dir('kubernetes') {
        echo 'pipeline is waiting for the cluster to be initialized...'
        sleep(time: '1', unit: 'MINUTES')
        sh '''
            helm install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --set-string controller.service.annotations."service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"="nlb"
        '''

    }
}

def mapDnsToExternalIp () {
    dir('kubernetes') {
        sh '''
            chmod +x dns-mapping.sh
            ./dns-mapping.sh
        '''
    }
}

def deploySockShopApp () {
    dir('kubernetes') {
        sh '''
            kubectl apply -f complete-demo.yaml
            kubectl apply -f cluster-autoscaler/
            kubectl apply -f priorityclass.yaml
            echo 'waiting for the sock-shop app to be fully deployed...'
            sleep 1m
            kubectl apply -f ingress-nginx.yaml
        '''
    }
}

def deployPrometheusAndGrafana () {
    dir('kubernetes/monitoring') {
        sh '''
            kubectl apply -f prometheus/
            kubectl apply -f grafana/
        '''
    }
}

def deployAlertManager () {
    dir('kubernetes/alertmanager') {
        sh '''
            kubectl apply -f alertmanager.yaml
            kubectl apply -f alertmanager-dep.yaml
            kubectl apply -f alertmanager-svc.yaml
        '''
    }
}

def destroyTerraform() {
    dir('terraform') {
        def userInput = input(id: 'confirm', message: 'Do you want to proceed with Terraform destroy?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: '', name: 'confirm'] ])
        if (userInput == 'true') {
            echo 'Proceeding with Terraform destroy...'
            sh '''
                terraform successully aborted by user.
            '''
        } else {
            sh '''
                terraform destroy --auto-approve
            '''
            // The 'return' statement here will not work as expected because it's inside a script block.
            // Instead, you can use 'error' to stop the pipeline execution or simply return from the function.
            // error('Terraform destroy aborted by user.')
        }
    }
}


return this



                   