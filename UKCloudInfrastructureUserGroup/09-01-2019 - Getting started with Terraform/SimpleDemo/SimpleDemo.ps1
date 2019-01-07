# Log into Azure Cloud Shell

# Modify main.tf as needed (add username, password, IPs etc)

# Upload main.tf into Cloud Shell

# Run below commands
az account set --subscription "Your subscription name" # Changes to the correct subscription
cd ~
terraform init # Terraform downloads the terraform Azure plugin
terraform plan -out=plan # This is what Terraform will do to make your infrastructure like the configuration
terraform apply

# Open new session
code plan
code terraform.tfstate
cd ./.terraform

