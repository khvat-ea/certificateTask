pipeline {
    agent none
    stages{
        stage ('Create instanses'){
            agent{ label 'master' }
            stages{
                stage('Example') {
                    steps {
                        echo 'Hello World'
                    }
                }
            }
        }
    }
}