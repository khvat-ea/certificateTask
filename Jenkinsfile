pipeline {
    environment{
        keySSH_masterHost = "id_rsa"                            // The name of the key pair for SSH binding of the master host with the deployed instances
        project_ID = "devops-school-317412"                     // ID of the GCP project in which to work
        inventory_GCP_file = "./dynamicInventoryGCP.gcp.yml"    // GCE Dynamic Inventory file
        version_release_app = "1.0.0"                           // Release version of the web application
    }

    agent any 
    stages{
        stage('Create builder and production instance'){
            steps{
                withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                    sh 'yes y | ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/${keySSH_masterHost} -q -N ""'
                    sh 'terraform init -input=false'
                    sh 'terraform apply \
                            -var="public_key_path=${HOME}/.ssh/${keySSH_masterHost}.pub" \
                            -var="service_account_key=${service_account_file}" \
                            -var="project_GCP=${project_ID}" \
                            -input=false -auto-approve'
                }
            }
        }

        stage('Create dynamic GCP inventory'){
            steps{
                withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                    sh 'cat ${service_account_file} > /tmp/service_account_file.json'                            
                }
                sh 'ansible-playbook --extra-vars "service_account_key=/tmp/service_account_file.json \
                                                    project_ID=${project_ID} \
                                                    inventory_GCP_file=${inventory_GCP_file}" \
                    inventaryGCP.yml'
                sh 'ansible-inventory --graph -i ${inventory_GCP_file}'
            }
        }

        stage('Build web application'){
            steps{
                withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                    sh 'ansible-playbook    --user root \
                                            -i ${inventory_GCP_file} \
                                            --extra-vars "service_account_key=$(cat ${service_account_file} | base64 --wrap=0) \
                                                            project_ID=${project_ID} \
                                                            version_release_app=${version_release_app}" \
                        buildApp.yml'
                }
            }
        }

        stage('Deploy web application'){
            steps{
                withCredentials([file(credentialsId: 'secret_GCP', variable: 'service_account_file')]) {
                    sh 'ansible-playbook    --user root \
                                            -i ${inventory_GCP_file} \
                                            --extra-vars "service_account_key=$(cat ${service_account_file} | base64 --wrap=0) \
                                                            project_ID=${project_ID} \
                                                            version_release_app=${version_release_app}" \
                        deployApp.yml'
                }
            }
        }
    }
}