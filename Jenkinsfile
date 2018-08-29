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
                    git add terraform.tfstate
                    git -c user.name="Jimmy Cui" -c user.email="jimmycgz@gmail.com" commit -m "terraform state file update from Jenkins"
                    git push origin master
                    """
                  }
                }
        
         
    }
}
