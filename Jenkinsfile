pipeline {
    agent any

    environment {
        IMAGE_NAME = "ankitchhetri/myapp:latest"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        K8S_NAMESPACE = "default"
        APP_NAME = "myapp"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Ankitchh/DevOpsExam.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

      stage('Push Image to Registry') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh """
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
            """
        }
    }
}


        stage('Deploy to GREEN Environment') {
            steps {
                sh """
                kubectl apply -f kind_cluster/k8s/green-deployment.yaml
                kubectl set image deployment/${APP_NAME}-green \
                  ${APP_NAME}=${IMAGE_NAME}:${IMAGE_TAG} \
                  -n ${K8S_NAMESPACE}
                """
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Approve switching production traffic to GREEN?',
                      ok: 'Approve'
            }
        }

        stage('Switch Traffic to GREEN') {
            steps {
                sh """
                kubectl patch service ${APP_NAME}-service \
                -n ${K8S_NAMESPACE} \
                -p '{"spec":{"selector":{"app":"${APP_NAME}","env":"green"}}}'
                """
            }
        }
    }
}

