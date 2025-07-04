pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerHubCreds')   // ID in Jenkins
        SONARQUBE_ENV = 'Sonar'                               // Sonar server name in Jenkins
        GIT_CREDENTIALS = credentials('Github')             // GitHub user/pass or token
        DOCKER_IMAGE = 'shubhamj2024/daisyui-dashboard:latest'
        REPO_URL = 'https://github.com/Shubhamj1998/DevOps-Daisy-UI--2025.git'
    }
  
    parameters {
    string(name: 'IMAGE_TAG', defaultValue: 'shubhamj2024/daisyui-dashboard:latest', description: 'Docker image to deploy')
}

    stages {

        stage('Checkout Code') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS}", url: "${REPO_URL}", branch: 'main'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy fs --exit-code 1 --severity HIGH,CRITICAL . || echo "Trivy scan success."'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'sonar-scanner -Dsonar.projectKey=myapp -Dsonar.sources=. -Dsonar.host.url=$192.168.29.29:9000 -Dsonar.login=$Sonar'
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Push Code to GitHub') {
            steps {
                sh '''
                  git config user.name "Shubham Jadhav"
                  git config user.email "jadhavdshubham@gmail.com"
                  git add .
                  git commit -m "Auto-commit from Jenkins" || echo "Nothing to commit"
                  git push https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/Shubhamj1998/DevOps-Daisy-UI--2025.git HEAD:main
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHubCreds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                      echo "$PASS" | docker login -u "$USER" --password-stdin
                      docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Docker Pull Test') {
            steps {
                sh "docker rmi $DOCKER_IMAGE || true"
                sh "docker pull $DOCKER_IMAGE"
            }
        }

        stage('Trigger CD Pipeline') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                build job: 'Daisy-Dashboard-CD', wait: false
            }
        }
    }

    post {
        failure {
            emailext(
                subject: "Jenkins CI Pipeline Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Pipeline failed at stage: ${env.STAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: ${env.BUILD_URL}",
                to: "jadhavdshubham@gmail.com"
            )
        }
    }
}
