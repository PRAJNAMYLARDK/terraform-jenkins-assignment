pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-2'
    }

    stages {

        stage('Git Checkout') {
            steps {
                echo '=========================================='
                echo 'Cloning Terraform project from GitHub'
                echo '=========================================='

                git branch: 'main',
                    url: 'https://github.com/PRAJNAMYLARDK/terraform-jenkins-assignment.git'

                sh '''
                    echo "Project files:"
                    ls -la

                    echo ""
                    echo "Terraform module files:"
                    find modules -type f | sort
                '''
            }
        }

        stage('Check Tools') {
            steps {
                sh '''
                    echo "=========================================="
                    echo "Checking Installed Tools"
                    echo "=========================================="

                    echo "Terraform version:"
                    terraform --version

                    echo ""
                    echo "AWS CLI version:"
                    aws --version
                '''
            }
        }

        stage('AWS Authentication') {
            steps {
                echo '=========================================='
                echo 'Testing AWS authentication'
                echo '=========================================='

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-ecr']
                ]) {
                    sh '''
                        echo "Checking AWS identity..."
                        aws sts get-caller-identity

                        echo ""
                        echo "AWS Region:"
                        echo "$AWS_REGION"
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo '=========================================='
                echo 'Terraform Init'
                echo '=========================================='

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-ecr']
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION="$AWS_REGION"

                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo '=========================================='
                echo 'Terraform Validate'
                echo '=========================================='

                sh '''
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                echo '=========================================='
                echo 'Terraform Plan'
                echo '=========================================='

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-ecr']
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION="$AWS_REGION"

                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo '=========================================='
                echo 'Terraform Apply'
                echo '=========================================='

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-ecr']
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION="$AWS_REGION"

                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Output') {
            steps {
                echo '=========================================='
                echo 'Terraform Output'
                echo '=========================================='

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-ecr']
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION="$AWS_REGION"

                        terraform output
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '''
            ==========================================
            TERRAFORM DEPLOYMENT SUCCESSFUL
            ==========================================
            AWS resources have been created successfully.
            ==========================================
            '''
        }

        failure {
            echo '''
            ==========================================
            TERRAFORM DEPLOYMENT FAILED
            ==========================================
            Check Jenkins Console Output.
            ==========================================
            '''
        }

        always {
            echo 'Terraform pipeline execution completed.'
        }
    }
}
