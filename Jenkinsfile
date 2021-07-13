pipeline {
    environment{
        keySSH_masterHost = "id_rsa_master"     // The name of the key pair for SSH binding of the master host with the deployed instances
        project_ID = "devops-school-317412"     // ID of the GCP project in which to work
        inventory_GCP_file = "./dynamicInventoryGCP.gcp.yml"
    }

    agent none
    stages{
        stage ('Create instanses'){
            agent{ label 'master' }
            stages{
                // stage('Create builder and production instance'){
                //     steps{
                //         withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                //             sh 'yes y | ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/${keySSH_masterHost} -q -N ""'
                //             sh 'terraform init -input=false'
                //             sh 'terraform apply \
                //                     -var="public_key_path=${HOME}/.ssh/${keySSH_masterHost}.pub" \
                //                     -var="service_account_key=${service_account_file}" \
                //                     -var="project_GCP=${project_ID}" \
                //                     -input=false -auto-approve'
                //         }
                //     }
                // }
                stage('Build web application'){
                    steps{
                        withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                            sh 'cat ${service_account_file} > /tmp/service_account_file.json'                            
                        }
                        sh 'ansible-playbook --extra-vars "service_account_key=/tmp/service_account_file.json \
                                                           project_ID=${project_ID} \
                                                           inventory_GCP_file=${inventory_GCP_file}" \
                                             deployApp.yml'
                        sh 'ansible-inventory --graph -i ${inventory_GCP_file}'
                        sh 'ls -la'
                    }
                }
            }
        }
    }
}