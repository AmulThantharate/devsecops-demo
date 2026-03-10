pipeline {
    agent any
    tools {
        nodejs "node"
    }
    environment{
        SONAR_HOME = tool "sonar"
        IMAGE_TAG   = sh(script: 'git log -1 --format="%h"', returnStdout: true).trim()
    }
    stages {
        stage("Checkout") {
            steps {
                checkout scm 
            }
        }
        stage("Install Dependencies") {
            steps{
                sh "npm install"
            }
        }
        stage("SonarQube Analysis"){
            steps{
                withSonarQubeEnv('sonar'){
                    sh """
            $SONAR_HOME/bin/sonar-scanner \
            -Dsonar.projectName=notetodo \
            -Dsonar.projectKey=notetodo
            """
                }
            }
        }
        stage("Quality Gate"){
            steps{
                timeout(time: 5, unit:"MINUTES"){
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        stage("OWASP"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format XML --out ./', odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Trivy File System Scan"){
            steps{
            sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        stage("Docker Build"){
            steps {
                sh "docker build -t dev-1:${IMAGE_TAG} ."
                echo "Build Success"
            }
        }
        stage("Docker Fs Test"){
            steps {
                sh "trivy image dev-1:${IMAGE_TAG}"
            }
        }
        stage("Push to Private Docker Hub Repo"){
            steps{
                withCredentials([usernamePassword(credentialsId:"DockerHubCreds",passwordVariable:"DockerPass",usernameVariable:"DockerUser")]){
                    sh 'docker login -u $DockerUser -p $DockerPass'
                    sh "docker tag dev-1:${IMAGE_TAG} \$DockerUser/dev-1:${IMAGE_TAG}"
                    sh "docker push \$DockerUser/dev-1:${IMAGE_TAG}"
                }
            }
        }
        stage("Start The Docker App"){
            steps{
                sh "docker run --rm --name ss claw4321/dev-1:${IMAGE_TAG}"
            }
        }
    }
}