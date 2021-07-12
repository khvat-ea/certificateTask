pipeline {
    environment{
        keySSH_masterHost = "id_rsa_master"     // Name of SSH key
        project_ID = "devops-school-317412"     // ID of the GCP project in which to work
    }

    agent none
    stages{
        stage ('Create instanses'){
            agent{ label 'master' }
            stages{
                stage('Create builder and production instance'){
                    steps{
                        withCredentials([file(credentialsId: 'secret_GCP', variable: 'serviceAccount_GCP')]) {
                            sh 'yes y | ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/${keySSH_masterHost} -q -N ""'
                            sh 'terraform init -input=false'
                            sh 'terraform apply \
                                    -var="public_key_path=${HOME}/.ssh/${keySSH_masterHost}.pub" \
                                    -var="service_account_key=${serviceAccount_GCP}" \
                                    -var="project_GCP=${project_ID}" \
                                    -input=false -auto-approve'
                        }
                    }
                }
            }
        }
    }
}