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
                                       
                   sudo ${TERRAFORM_CMD} init 
                    """
            }
        }
        
        stage('plan') {
            steps {
                sh  """
                    sudo ${TERRAFORM_CMD} plan -lock=false  
                    """
                
                }
           }
        stage('apply') {
            steps {
                sh  """
                    sudo ${TERRAFORM_CMD} apply -lock=false -auto-approve
                   
                   cp terraform.tfstate ../$BUILD_NUMBER.tfstate
                    
                    """
                  }
                }
        
         
    }
}
