pipeline {
    agent { label 'dev' }

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
        YBA_PATH = "/home/adev4769_gmail_com"
        CONTROL_NODE = "control-node"
    }

    stages {

        stage('Verify YBA CLI') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}
                ./yba version
                '
                """
            }
        }

        stage('Register YBA CLI (If Needed)') {
            steps {
                withCredentials([string(credentialsId: 'yba-admin-password', variable: 'YBA_PASS')]) {
                    sh """
                    ssh ybaadmin@${CONTROL_NODE} '
                    if [ ! -f ~/.yba-cli.yaml ]; then
                        echo "Registering YBA CLI..."
                        cd ${YBA_PATH}
                        ./yba register \
                          -f \
                          -n admin \
                          -e admin@gmail.com \
                          -p "${YBA_PASS}" \
                          --environment dev \
                          -H ${YBA_HOST}
                    else
                        echo "YBA already registered. Skipping..."
                    fi
                    '
                    """
                }
            }
        }

        stage('Create Provider') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}
                ./yba provider onprem create \
                  --name ${PROVIDER_NAME} \
                  --region region-name=south-asia \
                  --zone zone-name=mum1::region-name=south-asia \
                  --ssh-user ybaadmin \
                  --ssh-keypair-name ybaadmin \
                  --ssh-keypair-file-path /home/adev4769_gmail_com/id_rsa \
                  -H ${YBA_HOST} || echo "Provider may already exist"
                '
                """
            }
        }

        stage('Create Instance Type') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}
                ./yba provider onprem instance-type add \
                  --name ${PROVIDER_NAME} \
                  --instance-type-name db-node-type \
                  --num-cores 2 \
                  --mem-size 10 \
                  --volume mount-points=/mnt/yba-data::size=10::type=SSD \
                  -H ${YBA_HOST} || echo "Instance type may already exist"
                '
                """
            }
        }

        stage('Add Nodes') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}

                ./yba provider onprem node add \
                  --name ${PROVIDER_NAME} \
                  --ip 10.0.0.12 \
                  --instance-type db-node-type \
                  --region south-asia \
                  --zone mum1 \
                  --node-name db-pr-node-1 \
                  -H ${YBA_HOST} || echo "Node 1 exists"

                ./yba provider onprem node add \
                  --name ${PROVIDER_NAME} \
                  --ip 10.0.0.13 \
                  --instance-type db-node-type \
                  --region south-asia \
                  --zone mum1 \
                  --node-name db-pr-node-2 \
                  -H ${YBA_HOST} || echo "Node 2 exists"

                ./yba provider onprem node add \
                  --name ${PROVIDER_NAME} \
                  --ip 10.0.0.14 \
                  --instance-type db-node-type \
                  --region south-asia \
                  --zone mum1 \
                  --node-name db-pr-node-3 \
                  -H ${YBA_HOST} || echo "Node 3 exists"
                '
                """
            }
        }

        stage('Create Universe') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}
                ./yba universe create \
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
                  -H ${YBA_HOST}
                '
                """
            }
        }

        stage('Wait For Universe Ready') {
            steps {
                sh """
                ssh ybaadmin@${CONTROL_NODE} '
                cd ${YBA_PATH}

                echo "Waiting for Universe to become Ready..."

                for i in {1..60}; do
                  STATUS=$(./yba universe describe \
                    --name ${UNIVERSE_NAME} \
                    -H ${YBA_HOST} | grep "state" | awk "{print \$2}")

                  echo "Current Status: \$STATUS"

                  if [[ "\$STATUS" == "Ready" ]]; then
                    echo "Universe is Ready!"
                    exit 0
                  fi

                  sleep 60
                done

                echo "Universe did not become ready in time."
                exit 1
                '
                """
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