pipeline {
    agent none

    stages {

        stage('Print the Jenkinsfile') {
            agent { label 'dev' }
            steps {
                sh 'cat Jenkinsfile'
            }
        }

        /* =========================
           DEV ENVIRONMENT
        ========================== */

        stage('Verify MySQL - DEV') {
            agent { label 'dev' }
            steps {
                echo "Checking MySQL version on DEV..."
                sh 'mysql --version'
            }
        }

        stage('Show MySQL Role File - DEV') {
            agent { label 'dev' }
            steps {
                echo "Printing MySQL role task file (DEV)..."
                sh 'cat config/ansible/roles/mysql_role/tasks/main.yml'
            }
        }

        stage('Run DB Ansible Playbook - DEV') {
            agent { label 'dev' }
            steps {
                echo "Executing Ansible playbook for DEV..."

                withCredentials([string(credentialsId: 'mysql-root-pass-dev', variable: 'DB_PASS')]) {
                    sh """
                        ansible-playbook \
                        -e mysql_root_password=${DB_PASS} \
                        config/ansible/playbook.yml
                    """
                }
            }
        }

        /* =========================
           UAT ENVIRONMENT
        ========================== */

        stage('Verify MySQL - UAT') {
            agent { label 'uat' }
            steps {
                echo "Checking MySQL version on UAT..."
                sh 'mysql --version'
            }
        }

        stage('Show MySQL Role File - UAT') {
            agent { label 'uat' }
            steps {
                echo "Printing MySQL role task file (UAT)..."
                sh 'cat config/ansible/roles/mysql_role/tasks/main.yml'
            }
        }

        stage('Run DB Ansible Playbook - UAT') {
            agent { label 'uat' }
            steps {
                echo "Executing Ansible playbook for UAT..."

                withCredentials([string(credentialsId: 'mysql-root-pass-uat', variable: 'DB_PASS')]) {
                    sh """
                        ansible-playbook \
                        -e mysql_root_password=${DB_PASS} \
                        config/ansible/playbook.yml
                    """
                }
            }
        }
    }
}