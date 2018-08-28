pipeline {
    /*  Get Terraform resource file by checking out SCM*/
    /* Create Security Group by Terraform resource file */
    
    agent any

environment {
        TERRAFORM_CMD = 'terraform'
    }
    stages {
        stage('checkout repo') {
            steps {
              checkout scm
            }
        }
     
        stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -out=tfplan -input=false 
                    """
                
                }
           }
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false tfplan
                    """
                  }
                }
    }
}
