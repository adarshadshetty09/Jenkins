pipeline {
    agent any

    options {
        timeout(time: 90, unit: 'MINUTES')
        timestamps()
    }

    parameters {
        string(name: 'UNIVERSE_NAME', defaultValue: 'universe-pr')
        string(name: 'PROVIDER_NAME', defaultValue: 'gcp-provider')
        string(name: 'YB_VERSION', defaultValue: '2024.2.4.0-b89')
    }

    environment {
        YBA_HOST = "https://136.111.218.140:443"
        YBA_BIN  = "/home/adev4769_gmail_com/yba"
    }

    stages {

        stage('Verify YBA CLI') {
            steps {
                sh """
                ${YBA_BIN} --version
                """
            }
        }

        stage('Create Provider + Infra') {
            steps {
                withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {
                    sh """
                    ${YBA_BIN} provider onprem create \
                      --name ${PROVIDER_NAME} \
                      --region region-name=south-asia \
                      --zone zone-name=mum1::region-name=south-asia \
                      --ssh-user ybaadmin \
                      --ssh-keypair-name ybaadmin \
                      --ssh-keypair-file-path /home/adev4769_gmail_com/id_rsa \
                      -H ${YBA_HOST} --insecure \
                      -a ${YBA_TOKEN} || echo "Provider exists"

                    ${YBA_BIN} provider onprem instance-type add \
                      --name ${PROVIDER_NAME} \
                      --instance-type-name db-node-type \
                      --num-cores 2 \
                      --mem-size 10 \
                      --volume mount-points=/mnt/yba-data::size=10::type=SSD \
                      -H ${YBA_HOST} --insecure \
                      -a ${YBA_TOKEN} || echo "Instance type exists"
                    """
                }
            }
        }

        stage('Create Universe') {
            steps {
                withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {
                    sh """
                    ${YBA_BIN} universe create \
                      --name ${UNIVERSE_NAME} \
                      --yb-db-version ${YB_VERSION} \
                      --provider-code onprem \
                      --provider-name ${PROVIDER_NAME} \
                      --replication-factor 3 \
                      --num-nodes 3 \
                      --regions south-asia \
                      --instance-type db-node-type \
                      --assign-public-ip=false \
                      --enable-ysql=true \
                      --enable-ycql=false \
                      --enable-node-to-node-encrypt=false \
                      --enable-client-to-node-encrypt=false \
                      -H ${YBA_HOST} --insecure \
                      -a ${YBA_TOKEN} || echo "Universe may already exist"
                    """
                }
            }
        }

        stage('Wait For Universe Ready') {
            steps {
                withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {
                    sh """
                    echo "Waiting for Universe..."

                    for i in {1..60}; do
                      STATUS=\$(${YBA_BIN} universe describe \
                        --name ${UNIVERSE_NAME} \
                        -H ${YBA_HOST} --insecure \
                        -a ${YBA_TOKEN} | grep Ready)

                      if [ ! -z "\$STATUS" ]; then
                        echo "Universe Ready!"
                        exit 0
                      fi

                      echo "Still provisioning..."
                      sleep 60
                    done

                    echo "Universe not ready in time."
                    exit 1
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Universe deployment completed successfully 🚀"
        }
        failure {
            echo "Universe deployment FAILED ❌"
        }
    }
}