pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                echo '=========================================='
                echo 'Cleaning Jenkins Workspace'
                echo '=========================================='

                deleteDir()
            }
        }

        stage('Git Checkout') {
            steps {
                echo '=========================================='
                echo 'Cloning Terraform Project'
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
                echo '=========================================='
                echo 'Checking Tools'
                echo '=========================================='

                sh '''
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
                echo 'AWS Authentication'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

                        echo "Testing AWS authentication..."
                        aws sts get-caller-identity

                        echo ""
                        echo "AWS authentication successful."
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM INIT'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

                        rm -rf .terraform
                        rm -f .terraform.lock.hcl

                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Format') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM FORMAT CHECK'
                echo '=========================================='

                sh '''
                    terraform fmt -check -recursive
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM VALIDATE'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM PLAN'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

                        terraform plan \
                            -input=false \
                            -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM APPLY'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

                        terraform apply \
                            -input=false \
                            -auto-approve \
                            tfplan
                    '''
                }
            }
        }

        stage('Terraform Output') {
            steps {
                echo '=========================================='
                echo 'TERRAFORM OUTPUT'
                echo '=========================================='

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1

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
VPC and Public Subnet created successfully.
==========================================
'''
        }

        failure {
            echo '''
==========================================
TERRAFORM DEPLOYMENT FAILED
==========================================
Check the Jenkins Console Output.
==========================================
'''
        }

        always {
            echo 'Terraform pipeline execution completed.'
        }
    }
}
