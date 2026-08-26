```groovy
pipeline {

    agent any

    parameters {
        string(
            name: 'AMI_ID',
            description: 'Enter a valid AMI ID for your AWS region'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan \
                    -var="ami_id=${AMI_ID}" \
                    -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Do you want to apply the Terraform changes?',
                      ok: 'Apply'

                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Terraform Output') {
            steps {
                sh 'terraform output'
            }
        }
    }

    post {

        success {
            echo 'Terraform deployment completed successfully!'
        }

        failure {
            echo 'Terraform deployment failed!'
        }

        always {
            echo 'Terraform pipeline execution completed.'
        }
    }
}
```
