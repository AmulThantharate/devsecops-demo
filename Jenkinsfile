pipeline {
    agent any 
    environment{
        SONAR_HOME = tool "Sonar"
    }
    stages {
        stage("Checkout") {
            steps {
                checkout scm 
            }
        }
    }
}