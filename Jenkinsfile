pipeline {
    /*  Used Dev branch to further develop the code for IaC */
    /*  Get Terraform resource file by checking out SCM*/
    /* Create Security Group by Terraform resource file */
    
    agent any

environment {
        TERRAFORM_CMD = 'sudo terraform'
    }
    stages {
    
          stage('init') {
            steps {
                sh  """
                                       
                   ${TERRAFORM_CMD} init 
                    """
            }
        }
        
        stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -lock=false  
                    """
                
                }
           }
        
         
    }
}
