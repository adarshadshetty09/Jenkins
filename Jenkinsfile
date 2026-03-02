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
        string(name: 'NODE_IPS', defaultValue: '10.0.0.12,10.0.0.13,10.0.0.14', description: 'Comma separated DB node IPs')
        string(name: 'REGION_NAME', defaultValue: 'south-asia')
        string(name: 'ZONE_NAME', defaultValue: 'mum1')
    }

    environment {
        YBA_HOST = "https://136.111.218.140:443"
        YBA_BIN  = "/home/adev4769_gmail_com/yba"
    }

    stages {

        stage('Verify YBA CLI') {
            steps {
                sh "${YBA_BIN} --version"
            }
        }

        stage('Create Provider + Instance Type') {
            steps {
                withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {
                    sh """
                    ${YBA_BIN} provider onprem create \
                      --name ${params.PROVIDER_NAME} \
                      --region region-name=${params.REGION_NAME} \
                      --zone zone-name=${params.ZONE_NAME}::region-name=${params.REGION_NAME} \
                      --ssh-user ybaadmin \
                      --ssh-keypair-name ybaadmin \
                      --ssh-keypair-file-path /home/ybaadmin/.ssh/id_rsa \
                      -H ${YBA_HOST} --insecure \
                      -a ${YBA_TOKEN} || echo "Provider exists"

                    ${YBA_BIN} provider onprem instance-type add \
                      --name ${params.PROVIDER_NAME} \
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

        stage('Add OnPrem Nodes Dynamically') {
            steps {
                script {
                    def ips = params.NODE_IPS.split(',')
                    withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {

                        for (int i = 0; i < ips.size(); i++) {
                            def ip = ips[i].trim()
                            def nodeName = "db-node-${i+1}"

                            sh """
                            ${YBA_BIN} provider onprem node add \
                              --name ${params.PROVIDER_NAME} \
                              --ip ${ip} \
                              --instance-type db-node-type \
                              --region ${params.REGION_NAME} \
                              --zone ${params.ZONE_NAME} \
                              --node-name ${nodeName} \
                              -H ${YBA_HOST} --insecure \
                              -a ${YBA_TOKEN} || true
                            """
                        }
                    }
                }
            }
        }

        stage('Create Universe') {
            steps {
                script {
                    def nodeCount = params.NODE_IPS.split(',').size()

                    withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {
                        sh """
                        ${YBA_BIN} universe create \
                          --name ${params.UNIVERSE_NAME} \
                          --yb-db-version ${params.YB_VERSION} \
                          --provider-code onprem \
                          --provider-name ${params.PROVIDER_NAME} \
                          --replication-factor ${nodeCount} \
                          --num-nodes ${nodeCount} \
                          --regions ${params.REGION_NAME} \
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
        }

        stage('Wait For Universe Ready') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'yba-api-token', variable: 'YBA_TOKEN')]) {

                        sh """
                        echo "Waiting for Universe..."

                        for i in {1..60}; do
                          STATUS=\$(${YBA_BIN} universe describe \
                            --name ${params.UNIVERSE_NAME} \
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