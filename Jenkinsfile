pipeline {
    agent none

    stages {

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

        stage('Run DB Ansible Playbook') {
            agent { label 'dev' }
            steps {
                echo "Executing Ansible playbook for DB setup..."
                sh 'ansible-playbook config/ansible/playbook.yml'
            }
        }
    }
}