# How to deploy Fortinet solutions using terraform? 

## 1. Download our code
* You can download our code via the following methods:  
`Browser Download`  
`git clone via a command line`  

* You can place the downloaded code wherever you deem necessary, for example:  
`C:\terraform-fortinet-china`



## 2. Download Terraform
* You can follow the official document [here](https://www.terraform.io/downloads) to download terraform, and place the terraform execuable file under your desinated path. For example, `C:\Windows\System32` for PC.



## 3. Initialize terraform provider
* Go to your downloaded terraform project folder, for example:  
`C:\terraform-fortinet-china`
* Navigate to a specific terraform project, for example:  
`C:\terraform-fortinet-china\terraform-awschina\fgtvm-sniffer\`
* Run the following command to init terraform environment, for example: (If you encounter timeout, please refer to STEP.4 below)  
`terraform init`



## 4. (optional) Download Terraform Provider
* If you are having trouble during `terraform init`, please refer [here](https://releases.hashicorp.com/) to download terraform provider respectively.

* After successful download, for example, you have the execuable file `C:\Users\admin\Downloads\terraform-provider-aws_v4.57.1.exe`, you can run the following commands to import the provider into your terraform project.

* Please note that you need to modify the public cloud and terraform provider version to fit your deployment solution.  
```sh
cd C:\Users\admin\Downloads\
mkdir .\registry.terraform.io\hashicorp\aws\4.57.1\windows_amd64
mv terraform-provider-aws_v4.57.1.exe .\registry.terraform.io\hashicorp\aws\4.57.1\windows_amd64

cd C:\YOUR-TERRAFORM-PROJECT
terraform init -plugin-dir="C:\Users\admin\Downloads"
```


## 5. Deploy Terraform Project
* Upon successful initialization, you can refer to README/INSTRUCTIONs inside specific terraform project. There are detail steps to guide you through the provisioning.



## 6. APPENDIX
### 6.1 Terraform Sublime-Text Syntax
1.  Open the palette by pressing Ctrl+Shift+P (Win, Linux) or Cmd+Shift+P (OS X).  
Select “Install Package Control”

2.  Open the palette by pressing Ctrl+Shift+P (Win, Linux) or Cmd+Shift+P (OS X).  
Select "Package Control: Add Repository"  
Enter https://github.com/tmichel/sublime-terraform  

3.  Open the palette by pressing Ctrl+Shift+P (Win, Linux) or Cmd+Shift+P (OS X).  
Select "Package Control: Install Package"  
Select "sublime-terraform"

[Reference](https://github.com/tmichel/sublime-terraform)

### 6.2 Terraformer Download
[Terraformer](https://github.com/GoogleCloudPlatform/terraformer/releases)

### 6.3 Terraform Graphic with DOT
[DOT Download](https://graphviz.org/download/)  
terraform graph | dot -Tsvg > graph.svg