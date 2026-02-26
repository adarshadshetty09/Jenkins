pipeline {
    agent any

    stages {
        stage('Ansible Configuration') {
            steps {
                echo "Running Ansible..."
                sh 'ansible --version'
                sh 'ansible-playbook configure.yml'
            }
        }
    }
}
