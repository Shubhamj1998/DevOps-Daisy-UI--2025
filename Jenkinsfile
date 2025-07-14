@Library('Shared') _

pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Setting docker image tag for push')
    }

    stages {
        stage("Workspace Cleanup") {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage("Git: Code Checkout") {
            steps {
                script {
                    code_checkout("https://github.com/Shubhamj1998/DevOps-Daisy-UI--2025.git", "main")
                }
            }
        }

        stage("Trivy: Filesystem Scan") {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "Daisy-UI", "Daisy-UI")
                }
            }
        }

        stage("SonarQube: Quality Gate") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Docker: Build Image") {
            steps {
                script {
                    docker_build("daisyui-dashboard", "${DOCKER_TAG}", "shubhamj2024")
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
                script {
                    docker_push("daisyui-dashboard", "${params.DOCKER_TAG}", "shubhamj2024") 
                }
            }
        }
    }

    post {
        success {
            build job: "Daisy-Dashboard-CD", parameters: [
                string(name: 'DOCKER_TAG', value: "${params.DOCKER_TAG}")
            ]
        }

        failure {
            emailext(
                subject: "❌ CI Failed: ${env.JOB_NAME}",
                body: "The CI pipeline failed. Please check Jenkins logs.",
                to: 'jadhavdshubham@gmail.com'
            )
        }

        always {
            cleanWs()
        }
    }
}
