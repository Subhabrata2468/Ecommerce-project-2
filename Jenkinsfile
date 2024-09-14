// file name ecommerce

pipeline {
    agent any
    tools {
        nodejs 'node21'
    }

    environment {
        SCANNER_HOME = tool 'sonarqube'
        OWASP_HOME = 'Dependency-Check'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials' // The credentials ID for Docker Hub
        DOCKERHUB_USERNAME = 'your-dockerhub-username' // Your Docker Hub username
        CLIENT_REPO = "${JOB_NAME}/client-repo" // Docker Hub repository for the public image
        SERVER_REPO = "${JOB_NAME}/server-repo" // Docker Hub repository for the server image
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('GitHub Checkout') {
            steps {
                // Checkout code from GitHub branch 'correct'
                git url: 'https://github.com/Subhabrata2468/chat-app-react-nodejs-devops-project-2.git', branch: 'correct'
            }
        }

        stage('Install Dependency') {
            steps {
                // Run npm install in the server directory
                dir('server') {
                    sh 'npm install'
                }
                // Run npm install in the public directory
                dir('client') {
                    sh 'npm install'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectName=${JOB_NAME} -Dsonar.projectKey=${JOB_NAME}"
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                script {
                    def workspace = pwd()
                    def reportMainFolder = "TESTING"
                    def reportDir = "${workspace}/${reportMainFolder}/dependency-check-report"

                    // Ensure the directory exists
                    sh "mkdir -p ${reportDir}"
                    sh "chmod -R 777 ${reportDir}"

                    // Run the dependency check in Docker
                    sh """
                    docker run --rm \
                    -v ${workspace}/${reportMainFolder}:/src:z \
                    owasp/dependency-check:latest \
                    --project "${JOB_NAME}" \
                    --scan /src \
                    --format ALL \
                    --disableYarnAudit \
                    --disableNodeAudit \
                    --out /src/dependency-check-report
                    """

                    // List the contents of the report directory to verify the report was created
                    sh "ls -l ${reportDir}"
                }
            }
        }

        stage('Trivy File Scan') {
            steps {
		        script {
                   def reportMainFolder = "TESTING"
                   def reportDir = "${workspace}/${reportMainFolder}/Trivy-fileScan-check-report"
		
		            // Ensure the directory exists
                   sh "mkdir -p ${reportDir}"
                   sh "chmod -R 777 ${reportDir}"
		
		            // File Scan using Trivy
                   sh "trivy fs --format table -o ${reportDir}/trivy-fs-report.html ."
		        }
            }
        }

        stage('Docker Build & Push Client') {
            steps {
                script {
                    withDockerRegistry(credentialsId: DOCKERHUB_CREDENTIALS) {
                        // Build the Docker image for the public directory
                        sh "docker build -t ${CLIENT_REPO}:v1.${BUILD_ID} client"

                        // Tag the Docker image
                        sh "docker tag ${CLIENT_REPO}:v1.${BUILD_ID} ${DOCKERHUB_USERNAME}/ecommerce-client-repo:v1.${BUILD_ID}"
                        sh "docker tag ${CLIENT_REPO}:v1.${BUILD_ID} ${DOCKERHUB_USERNAME}/ecommerce-client-repo:latest"

                        // Push the Docker image to Docker Hub
                        sh "docker push ${DOCKERHUB_USERNAME}/ecommerce-client-repo:v1.${BUILD_ID}"
                        sh "docker push ${DOCKERHUB_USERNAME}/ecommerce-client-repo:latest"
                    }
                }
            }
        }

        stage('Docker Build & Push Server') {
            steps {
                script {
                    withDockerRegistry(credentialsId: DOCKERHUB_CREDENTIALS) {
                        // Build the Docker image for the server directory
                        sh "docker build -t ${SERVER_REPO}:v1.${BUILD_ID} server"

                        // Tag the Docker image
                        sh "docker tag ${SERVER_REPO}:v1.${BUILD_ID} ${DOCKERHUB_USERNAME}/ecommerce-server-repo:v1.${BUILD_ID}"
                        sh "docker tag ${SERVER_REPO}:v1.${BUILD_ID} ${DOCKERHUB_USERNAME}/ecommerce-server-repo:latest"

                        // Push the Docker image to Docker Hub
                        sh "docker push ${DOCKERHUB_USERNAME}/ecommerce-server-repo:v1.${BUILD_ID}"
                        sh "docker push ${DOCKERHUB_USERNAME}/ecommerce-server-repo:latest"
                    }
                }
            }
        }

        stage('Scan Docker Images with Trivy') {
            steps {
                script {
                    def reportMainFolder = "TESTING"
                    def reportDir = "${workspace}/${reportMainFolder}/Trivy-Docker-image-check-report"

                    // Ensure the directory exists
                    sh "mkdir -p ${reportDir}"
                    sh "chmod -R 777 ${reportDir}"

                    // Scan the Docker image using Trivy
                    sh "trivy image ${DOCKERHUB_USERNAME}/ecommerce-client-repo:v1.${BUILD_ID} > ${reportDir}/Trivy-Ecommerce-Client-image.txt"
		            sh "trivy image ${DOCKERHUB_USERNAME}/ecommerce-server-repo:v1.${BUILD_ID} > ${reportDir}/Trivy-Ecommerce-Server-image.txt"
                }
            }
        }

        stage("Create Namespace for Kubernetes") {
            steps {
                script {
                    withKubeCredentials(kubectlCredentials: [
                        [
                            caCertificate: '',            
                            clusterName: 'snappy-cluster-2',         
                            contextName: '',              
                            credentialsId: 'eks-to-jenkins',
                            namespace: '',         
                            serverUrl: 'https://150DB9C720FB273F7CF2094880F84199.yl4.us-east-1.eks.amazonaws.com'
                        ]
                    ]) {
                        // Attempt to create the namespaces
                        try {
                            
                            sh "kubectl create namespace ecommerce"
                        } catch (Exception e) {
                            // If the namespace already exists, log the error and proceed
                            echo 'Namespace already exists. Proceeding...'
                        }

                        try {
                            // Attempt to create the namespace
                            sh "kubectl create namespace prometheus-node-exporter"
                        } catch (Exception e) {
                            // If the namespace already exists, log the error and proceed
                            echo 'Namespace already exists. Proceeding...'
                        }
                    }
                }
            }
        }

        stage("Deployment in ecommerce Namespace") {
            steps {
                script {
                    dir('Kubernetes') {
                        withKubeCredentials(kubectlCredentials: [
                            [
                                caCertificate: '',            
                                clusterName: 'snappy-cluster-2',         
                                contextName: '',              
                                credentialsId: 'eks-to-jenkins',
                                namespace: 'snappy',         
                                serverUrl: 'https://150DB9C720FB273F7CF2094880F84199.yl4.us-east-1.eks.amazonaws.com'
                            ]
                        ]) {
                            sh 'chmod +x snappy-apply.sh'
                            sh './snappy-apply.sh'
                        }
                    }
                }
            }
        }

    }

    post {
        // Always cleanup after the build
        always {
            // Cleanup Docker images to free up space
            sh "docker rmi ${CLIENT_REPO}:v1.${BUILD_ID} || true"
            sh "docker rmi ${SERVER_REPO}:v1.${BUILD_ID} || true"
            sh "docker rmi ${DOCKERHUB_USERNAME}/ecommerce-client-repo:v1.${BUILD_ID} || true"
            sh "docker rmi ${DOCKERHUB_USERNAME}/ecommerce-client-repo:latest || true"
            sh "docker rmi ${DOCKERHUB_USERNAME}/ecommerce-server-repo:v1.${BUILD_ID} || true"
            sh "docker rmi ${DOCKERHUB_USERNAME}/ecommerce-server-repo:latest || true"

            // Send email for every build
            emailext subject: "Pipeline: ${currentBuild.fullDisplayName}",
                     body: """The Jenkins pipeline ${currentBuild.fullDisplayName} has completed.
                     Please check the console output for more details.""",
                     to: "your.email@example.com",
                     attachmentsPattern: 'TESTING/Trivy-fileScan-check-report/trivy-fs-report.html,TESTING/Trivy-Docker-image-check-report/Trivy-Ecommerce-Client-image.txt,TESTING/Trivy-Docker-image-check-report/Trivy-Ecommerce-Server-image.txt'
        }

        failure {
            // Send email on pipeline failure
            emailext subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                     body: """The Jenkins pipeline ${currentBuild.fullDisplayName} failed.
                     Please check the console output for more details.""",
                     to: "your.email@example.com",
                     attachmentsPattern: 'TESTING/Trivy-fileScan-check-report/trivy-fs-report.html,TESTING/Trivy-Docker-image-check-report/Trivy-Ecommerce-Client-image.txt,TESTING/Trivy-Docker-image-check-report/Trivy-Ecommerce-Server-image.txt'
        }
    }
}
