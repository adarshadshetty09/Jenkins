pipeline {
    agent none

    stages {
        stage('Print the Jenkinsfile'){
            agent {label 'dev'}
            steps{
                sh 'cat Jenkinsfile'
            }
        }
        stage('Verify MySQL') {
            agent { label 'dev' }
            steps {
                echo "Checking MySQL version..."
                sh 'mysql --version'
            }
        }

        stage('Show MySQL Role File') {
            agent { label 'dev' }
            steps {
                echo "Printing MySQL role task file..."
                sh 'cat config/ansible/roles/mysql_role/tasks/main.yml'
            }
        }

        stage('Run DB Ansible Playbook dev') {
            agent { label 'dev' }
            steps {
                echo "Executing Ansible playbook for DB setup..."
                sh 'ansible-playbook config/ansible/playbook.yml'
            }
        }
        stage('Verify MySQL uat') {
            agent { label 'uat' }
            steps {
                echo "Checking MySQL version..."
                sh 'mysql --version'
            }
        }

        stage('Show MySQL Role File uat') {
            agent { label 'uat' }
            steps {
                echo "Printing MySQL role task file..."
                sh 'cat config/ansible/roles/mysql_role/tasks/main.yml'
            }
        }

        stage('Run DB Ansible Playbook uat') {
            agent { label 'uat' }
            steps {
                echo "Executing Ansible playbook for DB setup..."
                sh 'ansible-playbook config/ansible/playbook.yml'
            }
        }
    }
}