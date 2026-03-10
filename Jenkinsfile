pipeline {
    agent any 
    enviormnet {
        SONAR_SCANNER = tool "Sonar"
    }
    stages {
        stage("Checkout") {
            steps {
                checkout scm 
            }
        }
    }
}