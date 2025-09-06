pipeline {
    agent any

    environment {

    }

    stages {
        stage (' Checkout Infra') {
            steps {
                git branch: 'main', url: 'https://github.com/iam-venkateshwarlu/threadedtreasure-deploy.git'
            }
        }

        stage ('Deploy minikube') {
            steps {
                sh '''
                    echo "Deploying minikube cluster"
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage ('Verify Deployment') {
            steps {
                sh '''
                    echo "Verifying deployment"
                    kubectl get pods
                    kubectl get services
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}