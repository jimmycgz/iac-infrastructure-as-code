pipeline {
    /*  Jenkinsfile */
    /* Used Dev branch to further develop the code for IaC */
    /*  Get Terraform resource file by checking out SCM*/
    /* Create Security Group by Terraform resource file */
    
    agent any

environment {
        TERRAFORM_CMD = 'sudo terraform'
    }
    stages {
    
          stage('INIT') {
            steps {
                sh  """
                                       
                   ${TERRAFORM_CMD} init 
                    """
            }
        }
        
        stage('PLAN') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -lock=false  
                    """
                
                }
           }
        
        stage('APPLY') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -auto-approve
                                 
                    """
                  }
                }
        
    }
}
