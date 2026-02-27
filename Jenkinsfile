pipeline {
    agent none

    stages {

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

        /* =========================
           DATA EXPORT STAGE
        ========================== */

        stage('Export Data and Archive CSV') {
            agent { label 'dev' }   // change to 'uat' if needed
            steps {
                echo "Exporting query result and archiving CSV..."

                archiveArtifacts artifacts: 'exports/*.csv', fingerprint: true
            }
        }
    }
}