pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'M2_HOME'
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        IMAGE_NAME = 'elaabayoudh/student-management'
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {
        stage('Commit') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ela-bayoudh01/student-management.git'
                sh 'git log -1 --pretty=format:"%h - %an - %s"'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test unitaire') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG -t $IMAGE_NAME:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    // Apostrophes : c'est le shell qui lit $DOCKER_PASS, pas Groovy
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            echo "Pipeline réussi : jar archivé, image ${IMAGE_NAME}:${IMAGE_TAG} publiée sur Docker Hub."
        }
        failure {
            echo 'Pipeline en échec : consulter la Console Output et la page Test Result.'
        }
    }
}