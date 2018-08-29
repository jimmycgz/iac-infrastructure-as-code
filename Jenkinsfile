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
                    /* sudo chmod 777 $WORKSPACE */
                    
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
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -auto-approve
                   
                   cp terraform.tfstate ../$BUILD_NUMBER.tfstate
                    
                    """
                  }
                }
        
         
    }
}
