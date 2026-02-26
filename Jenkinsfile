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

        stage('Run DB Ansible Playbook') {
            agent { label 'dev' }
            steps {
                echo "Executing Ansible playbook for DB setup..."
                sh 'ansible-playbook config/ansible/playbook.yml'
            }
        }
    }
}