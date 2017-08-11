pipeline {
  agent any

  environment {
    // static
    SERVICE_NAME = "string-extractor"
    VERSION = "0.0.${BUILD_NUMBER}"
    DOCKER_DIR = "docker"

    // Default to dev
    PROJECT = "qordoba-devel"
    DOCKERFILE = "Dockerfile_dev"
  }

  stages {

    stage('develop') {
      environment {
        PROJECT = "qordoba-devel"
        DOCKERFILE = "Dockerfile_dev"
      }

      when {
        // branch "develop"
        branch "ENG-1037-string-extractor"
      }

      steps {
        sh '''
            echo "SERVICE_NAME: ${SERVICE_NAME}"
            echo "VERSION: ${VERSION}"
            echo "PROJECT: ${PROJECT}"
            echo "DOCKERFILE: ${DOCKERFILE}"

            cd ${SERVICE_NAME}

            echo "Get latest base image"
            gcloud --quiet \
              docker -- pull gcr.io/${PROJECT}/qordoba-build:latest

            echo "Building image locally"
            docker build -t gcr.io/${PROJECT}/${SERVICE_NAME}:${VERSION} \
              -f ${DOCKER_DIR}/${DOCKERFILE} .

            echo "Pushing to google container registry"
            gcloud --quiet \
              docker -- push gcr.io/${PROJECT}/${SERVICE_NAME}:${VERSION}
        '''
      }
    }

  }

  post {
    always {
      echo 'Removing workspace'
      deleteDir()
    }
  }
}

