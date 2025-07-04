@Library('Shared') _
pipeline {
    agent any
    
    environment{
        SONAR_HOME = tool "Sonar"
    }
    }
  
    parameters {
        string(name: 'DOCKER_IMAGE_TAG', defaultValue: '', description: 'Setting docker image for latest push')
}

   stage('Git: Code Checkout') {
            steps {
                script{
                    code_checkout(https://github.com/Shubhamj1998/DevOps-Daisy-UI--2025.git","main")
                }
            }
        }

       stage("Trivy: Filesystem scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }

       stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar","DaisyUI","DaisyUI")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }
                                  
            stage("Docker: Build Images"){
            steps{
                script{
                      {
                            docker_build("daisyui-daashboards","${params.DOCKER_IMAGE_TAG","shubhamj2024")
                        }     
                }
            }
        }
        
          stage("Docker: Push to DockerHub"){
            steps{
                script{
                 docker_push("daisyui-daashboards","${params.DOCKER_IMAGE_TAG}","shubhamj2024")
                }
            }
        }
    }
     post{
        success{
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Daisy-Dashboard-CD", parameters: [
                string(name: 'DOCKER_IMAGE_TAG', value: "${params.DOCKER_IMAGE_TAG}"),
                ]
        }
    }
}
