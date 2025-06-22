pipeline{
    agent any      
    environment {
        APP_NAME = "hello-world"
        RELEASE_NUMBER = "1.0"
        DOCKER_USER = "rcregalado"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE_NUMBER}"
        SERVER = "192.168.100.4:5000"
        COMMIT_HASH = ''
    }
    stages{
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    COMMIT_HASH = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
            }
        }

        stage('Docker Build and Push'){
          
          steps{
            echo 'Docker build app'
            script{
                    docker.withRegistry("http://${SERVER}", 'nexus-regalado' ) {
                            docker_image = docker.build "${IMAGE_NAME}"
                            docker_image.push("${IMAGE_TAG}-${COMMIT_HASH}")
                            docker_image.push("latest")
              }
            }
          }
        }
        stage('Deploy') {
            steps {
                script {
                    // Verifica si ya se está ejecutando el contenedor
                    def exists = sh(script: "docker ps -a --format '{{.Names}}' | grep -w ${IMAGE_NAME}", returnStatus: true) == 0

                    if (exists) {
                        echo "Contenedor existe. Actualizando..."
                        sh """
                            docker stop ${IMAGE_NAME} || true
                            docker rm ${IMAGE_NAME} || true
                        """
                    } else {
                        echo "Contenedor no existe. Creando nuevo..."
                    }

                    sh """
                        docker run -d --restart=always \
                            --name ${IMAGE_NAME} \
                            --network app_network \
                            -p 6000:6000 \
                            ${SERVER}/${IMAGE_NAME}:${COMMIT_HASH}
                    """
                }
            }
        }
    }
    post {
        success {
            echo "Aplicación desplegada correctamente con commit ${COMMIT_HASH}"
        }
        failure {
            echo "Hubo un error durante el despliegue"
        }
    }
}
