pipeline{
    agent any      
    environment {
        APP_NAME = "hello-world"
        RELEASE_NUMBER = "1.0"
        DOCKER_USER = "sweetpeaito"
        DOCKER_PASS = 'docker'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE_NUMBER}"
    
    }
    stages{
        stage('Docker Build and Push'){
          
          steps{
            echo 'Docker build app'
            script{
                    docker.withRegistry('http://192.168.100.4:8081/repository/ci-images', 'nexus-regalado' ) {
                            docker_image = docker.build "${IMAGE_NAME}"
                            docker_image.push("${IMAGE_TAG}")
                            docker_image.push("latest")
              }
            }
          }
        }

        stage ('Cleanup Artifacts') {
             steps {
                 script {
                     sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                     sh "docker rmi ${IMAGE_NAME}:latest"
                 }
             }
        }
    }
}
