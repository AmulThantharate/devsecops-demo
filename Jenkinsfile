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
    }
}