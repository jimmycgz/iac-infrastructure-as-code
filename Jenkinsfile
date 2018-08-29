pipeline {
    /*  Get Terraform resource file by checking out SCM*/
    /* Create Security Group by Terraform resource file */
    
    agent any

environment {
        TERRAFORM_CMD = 'terraform'
    }
    stages {
    
          stage('init') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} init -backend=true -input=false
                    """
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
                    cp terraform.tfstate ../$BUILD_NUMBER.tfstate
                   
                   
                    
                    """
                  }
                }
        
         
    }
}
