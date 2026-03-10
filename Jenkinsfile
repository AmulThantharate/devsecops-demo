pipeline {
    agent any
    tools {
        nodejs "node"
    }
    environment{
        SONAR_HOME = tool "sonar"
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
        stage("Trivy File System Scan"){
            steps{
            sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        stage("Docker Build"){
            steps {
                sh "docker build -t dev-1:latest ."
                echo "Build Success"
            }
        }
        stage("Docker Fs Test"){
            steps {
                sh "trivy image dev-1:latest"
            }
        }
        stage("Push to Private Docker Hub Repo"){
            steps{
                withCredentials([usernamePassword(credentialsId:"DockerHubCreds",passwordVariable:"DockerPass",usernameVariable:"DockerUser")]){
                    sh "docker login -u $DockerUser -p $DockerPass"
                    sh "docker tag dev-1:latest $DockerUser/dev-1:latest"
                    sh "docker push $DockerUser/dev-1:latest"
                }
            }
        }
    }
}