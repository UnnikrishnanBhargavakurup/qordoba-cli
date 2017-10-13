pipeline {
  agent any

  environment {
    // static
    SERVICE_NAME = "string-extractor"
    VERSION = "${BRANCH_NAME}-0.0.${BUILD_NUMBER}"
    BASE_IMAGE_NAME = "qordoba-builder"
    BASE_IMAGE_VERSION = "0.0.8"
    DOCKER_DIR = "string-extractor/docker"

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
        expression { BRANCH_NAME ==~ /(develop|ENG-[0-9]+-.*)/ }
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
              docker -- pull gcr.io/${PROJECT}/${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}

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

