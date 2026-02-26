pipeline {
    agent none

    stages {

        stage('Install the Ansible') {
            parallel {

                stage('dev Agent') {
                    agent { label 'dev' }
                    steps {
                        echo "Running Ansible on DEV..."
                        sh 'sudo yum install ansible-core -y'
                        sh 'ansible --version'
                        sh 'ip r'
                        sh 'hostname'
                    }
                }

                stage('uat Agent') {
                    agent { label 'uat' }
                    steps {
                        echo "Running Ansible on UAT..."
                        sh 'sudo yum install ansible-core -y'
                        sh 'ansible --version'
                        sh 'ip r'
                        sh 'hostname'
                    }
                }
            }
        }

        stage('Hello') {
            agent { label 'dev' } 
            steps {
                echo 'Hello World'
                sh 'ip r'
            }
        }
    }
}