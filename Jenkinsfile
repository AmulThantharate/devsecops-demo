pipeline {
    agent any 
    environment{
        SONAR_HOME = tool "sonar"
    }
    stages {
        stage("Checkout") {
            steps {
                checkout scm 
            }
        }
    }
}