pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'daisyui-dashboardv1:latest'
        REPO_URL = 'https://github.com/Shubhamj1998/DevOps-Daisy-UI--2025.git'
        BRANCH = 'main'
        GIT_CREDENTIALS = credentials('Github')
        DOCKERHUB_CREDENTIALS = credentials('dockerHubCreds')
        SONARQUBE_ENV = 'Sonar'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code from Git') {
            steps {
                git branch: "${BRANCH}", credentialsId: "${GIT_CREDENTIALS}", url: "${REPO_URL}"
            }
        }

        stage('Trivy File Scan') {
            steps {
                sh 'trivy fs --exit-code 0 --severity MEDIUM,HIGH . > trivy-report.txt'
                archiveArtifacts artifacts: 'trivy-report.txt', fingerprint: true
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'Sonar'
            }
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=YourProject -Dsonar.sources=.'
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Docker Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHubCreds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Post Success: Notify Gmail & Trigger CD Job') {
            steps {
                script {
                    emailext (
                        subject: "CI Pipeline Success - ${env.JOB_NAME}",
                        body: "CI pipeline completed successfully for ${env.JOB_NAME}.\nTriggered CD job.",
                        to: 'youremail@gmail.com'
                    )

                    build job: 'CD-Deploy-Job', wait: false
                }
            }
        }
    }

    post {
        failure {
            emailext (
                subject: "CI Pipeline Failed - ${env.JOB_NAME}",
                body: "CI pipeline failed for ${env.JOB_NAME}. Please check the Jenkins logs.",
                to: 'jadhavdshubham@gmail.com'
            )
        }
    }
}
