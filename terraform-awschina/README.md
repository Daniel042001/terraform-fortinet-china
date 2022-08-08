# terraform-fortinet-china
## AWS



### Install awscli
[AWS Documentation]https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html  

[Linux]  
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  
unzip awscliv2.zip  
sudo ./aws/install  

[Windows]  
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi  

[MacOS]  
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"  
sudo installer -pkg AWSCLIV2.pkg -target /  



### Configure awscli
aws configure  
AWS Access Key ID [AK]:  
AWS Secret Access Key [SK]:  
Default region name [cn-northwest-1 | cn-north-1]:  
Default output format [yaml]:  



### Terraform configuration
[Terraform Documentation]https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#### init
terraform init

#### plan (run with 'Variables Definiation Files')
terraform apply -out=tfplan -var-file="variables.tfvars" -var='adminPassword=****'

#### apply
terraform apply "tfplan"

#### check
terraform state list

#### destroy
terraform apply -destroy



### Terraformer CLI
[Terraformer]https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md  
terraformer-aws.exe import aws --resources=vpc --filter=vpc=vpc-********** –-regions=cn-northwest-1  
terraformer-aws.exe import aws --resources=sg --filter=security_group=sg-************  
terraformer-aws.exe import aws --resources=eni --filter=network_interface=eni-**********  
terraformer-aws.exe import aws --resources=ec2_instance --filter=instances=i-************  
terraformer-aws.exe import aws --resources=rtb --filter=route_tables=rtb-**********  