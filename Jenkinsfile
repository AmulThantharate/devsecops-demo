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
                sh """ trivy fs --scanners vuln,secret,misconfig \
                --format template --template "@html.tpl" -o fs-report.html . """
            }
        }
    }
}