pipeline {
    agent any

    stages {
        stage('Execute MySQL Queries') {
            steps {
                echo "Running MySQL scripts..."
                sh 'mysql --version'
                sh 'mysql -u root -proot < scripts/schema.sql'
            }
        }
    }
}
