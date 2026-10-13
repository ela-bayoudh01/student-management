pipeline {
    agent any

    tools {
        jdk   'JDK17'      // nom exact déclaré dans Manage Jenkins > Tools
        maven 'M2_HOME'
    }

    triggers {
        pollSCM('H/5 * * * *')   // scrute GitHub toutes les 5 min, build seulement si nouveau commit
    }

    stages {
        stage('Commit') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<TON_USER>/student-management.git'
                // dernier commit : hash court - auteur - message
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
                    // publié même si un test échoue
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            echo 'Pipeline réussi : jar archivé.'
        }
        failure {
            echo 'Pipeline en échec : consulter la Console Output et la page Test Result.'
        }
    }
}