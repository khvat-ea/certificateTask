pipeline {
    environment{
        keySSH_masterHost = 'id_rsa_master'
    }

    agent none
    stages{
        stage ('Create instanses'){
            agent{ label 'master' }
            stages{
                stage('Create a key pair for the master host') {
                    steps {
                        sh 'ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/${keySSH_masterHost} -q -N ""'
                    }
                }
            }
        }
    }
}