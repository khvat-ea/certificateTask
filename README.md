## Task for the certificate [DevOps School].

### Formulation of the task:
>_Write a Jenkins pipeline that deploys instances to AWS (GCP or Azure), builds Java applications on them, and deploys the application to the stage. Must use Terraform and Ansible code. The application must be deployed to a container._

✨During the assignment, Google Cloud Platform was selected as the cloud provider. As an educational example, the source code of the BoxFuse web application is taken - https://github.com/boxfuse/boxfuse-sample-java-war-hello.git

### 1. Preparation of working tools.
##### 1.1 Create a new instance with characteristics of 4 CPU x 4 RAM. Operating system - Ubuntu 1804.
##### 1.2 Install Jenkins (https://pkg.jenkins.io/debian-stable/).
##### 1.3 Install Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli).
##### 1.4 Install Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-debian).
##### 1.5 Install Ubuntu packages:
  - docker engine (apt install docker.io)
  - PIP Python (apt install python-pip)
---
### 2. Configuring tools and preparing the runtime environment.
#### 2.1 Configuring Google Cloud.
Create a key in the Service Account (IAM section) as a JSON file upload - `<any>.json`;
> Note: the created file `<any>.json` will be applied in Jenkins (see "Configuring Jenkins", point 2).
  
#### 2.2 Configuring Jenkins.
**a)** enable the following plugins:
- SSH
- SSH agent

**b)** Add security Service Account GCP file to Jenkins credentials:
- select "Secret file" from the "Kind" drop-down list;
- select the JSON file `<any>.json` prepared earlier (see "Configuring Google Cloud" point 1);
- specify the "ID", the name of which should be `secret_GCP` (you can use your own name, but you will also need to change it in the Jenkins pipeline).
         
**c)** Create a new Pipeline.
- on the "General" tab, in the "Pipeline" section, from the "Definition" drop-down list, select "Pipeline script from SCM";
- then select "Git" from the "SCM" drop-down list;
- in the "Repository URL" field, specify a link to the current repository - https://github.com/khvat-ea/certificateTask;
- in the "Branch Specifier" field, specify the repository branch (in this case, it is one - "main");
- in the "Script Path" field, specify the name of the file describing the pipeline (by default, it is Jenkinsfile).
    
#### 2.3 Configuring Ansible.
**a)** Install required libraries for GCP modules:
```sh
pip install requests google-auth
```       
**b)** Configure `ansible.cfg` (/etc/ansible/ansible.cfg).

Activate the plugin for dynamic inventory:
```sh
[inventory]
enable_plugins = gcp_compute
```
Disable fingerprint verification:
```sh
[defaults]
host_key_checking = False
```
> Note: The dynamic inventory file for GCP itself is obtained in the CI / CD process using a template (https://github.com/khvat-ea/certificateTask/blob/main/roles/createInventoryGCP/templates/dynamicInventoryGCP.j2).
---
### 3. Execute task.
After completing the preparation of the build and deployment environment, simply run the pipeline in Jenkins. If the pipeline completed successfully, go to the deployed web application at the address in the browser `<external_instance (production) _IP>: 8090 / hello-1.0`


[DevOps School]:<https://devops-school.ru/devops_engineer.html>