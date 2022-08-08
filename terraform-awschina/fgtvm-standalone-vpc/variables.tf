#################### VPC ####################
variable "regionName" {
  type    = string
  default = "cn-northwest-1"
}

variable "azFgt" {
  type    = string
  default = "cn-northwest-1a"
}

variable "vpcName" {
  type    = string
  default = "VPC-NGFW"
}

variable "cidrVpcNgfw" {
  type    = string
  default = "172.31.0.0/16"
}

#################### Subnet FGT ####################
variable "subnetPublicName" {
  type    = string
  default = "Subnet_Public"
}

variable "subnetPrivateName" {
  type    = string
  default = "Subnet_Private"
}

variable "cidrSubnetPublic" {
  type    = string
  default = "172.31.11.0/24"
}

variable "cidrSubnetPrivate" {
  type    = string
  default = "172.31.12.0/24"
}


#################### ENI IP Address ####################
variable "eniIpFgtPublic" {
  type    = string
  default = "172.31.11.11"
}

variable "eniIpFgtPrivate" {
  type    = string
  default = "172.31.12.11"
}

#################### FortiGate ####################
variable "licenseType" {
  type    = string
  default = "payg"
}

variable "instanceType" {
  type    = string
  default = "c5.large"
}

variable "instanceNameFGT" {
  type    = string
  default = "FGT-AWS-Standalone"
}

variable "instanceBootstrapFgt" {
  type    = string
  default = "7.aws_instance_fgt.conf"
}

variable "adminsPort" {
  type    = string
  default = "443"
}

variable "licenseFile" {
  type    = string
  default = "license.lic"
}


variable "amiFgtBYOL" { # FGT AWS (BYOL) - 6.4.7 | FGT AWSChina (BYOL) - 6.4.6
  type = map(any)
  default = {
    cn-north-1     = "ami-0545b951bcac91111"
    cn-northwest-1 = "ami-01257a2cdfb51cce4"
    us-west-2      = "ami-0e08f3fe74ba7e859"
    us-west-1      = "ami-0baabe133544a64f0"
    us-east-1      = "ami-065f5f3d485c1ec3f"
    us-east-2      = "ami-044959ac92cbb585b"
    ap-east-1      = "ami-0d29fd65fc50a0a68"
    ap-south-1     = "ami-071e11bc680d59725"
    ap-northeast-3 = "ami-062467bb168cb7641"
    ap-northeast-2 = "ami-036c495952ea228f8"
    ap-southeast-1 = "ami-0d6b93a8ed23875f8"
    ap-southeast-2 = "ami-07c25feff0b1d73cb"
    ap-northeast-1 = "ami-05f22289eae68a667"
    ca-central-1   = "ami-02bedc73195b4f137"
    eu-central-1   = "ami-0c971b652ecda772d"
    eu-west-1      = "ami-0e360533772060fd1"
    eu-west-2      = "ami-0df08d256789f9289"
    eu-south-1     = "ami-004cf59a5f497ff89"
    eu-west-3      = "ami-09a295993c0c918b3"
    eu-north-1     = "ami-0033cfa8c85af242f"
    me-south-1     = "ami-0705cf1da677bd2e9"
    sa-east-1      = "ami-0aecd7b1537bcbf91"
  }
}


variable "amiFgtPAYG" { # FGT AWS (PAYG) - 6.4.7 | FGT AWSChina (PAYG) - 7.2.1
  type = map(any)
  default = {
    cn-north-1     = "ami-0aff7ef2c54c25cce"
    cn-northwest-1 = "ami-0bf4220e85eaec536"
    us-west-2      = "ami-0a56e818a46c63c91"
    us-west-1      = "ami-0ba8bcbaa9804c553"
    us-east-1      = "ami-0d480c4d334beff0e"
    us-east-2      = "ami-0d5333f9359d76a8e"
    ap-east-1      = "ami-0528a929e41968c90"
    ap-south-1     = "ami-03f7a76c1380c7ad6"
    ap-northeast-3 = "ami-02a07846a621a69d9"
    ap-northeast-2 = "ami-016b91e562c386569"
    ap-southeast-1 = "ami-04b14fc559454956a"
    ap-southeast-2 = "ami-0021afae0133c1009"
    ap-northeast-1 = "ami-03323ffab431a051a"
    ca-central-1   = "ami-065842c41b73e0197"
    eu-central-1   = "ami-0026cf2f0ab64b87b"
    eu-west-1      = "ami-0d853ba436dc8fc01"
    eu-west-2      = "ami-0f7055c9365eae6f4"
    eu-south-1     = "ami-048355214147aa2d1"
    eu-west-3      = "ami-03432560a8dfbb4f7"
    eu-north-1     = "ami-0f5b9a3a22260ebf1"
    me-south-1     = "ami-0da8469b3b9eb7afa"
    sa-east-1      = "ami-089cad2a7a4d3501e"
  }
}


#################### FortiGate Configuration File Variables ####################
# For configuration template file only, NOT for AWS provisioning
variable "fgtConfPort1GW" {
  type    = string
  default = "172.31.11.1"
}

variable "fgtConfPort2GW" {
  type    = string
  default = "172.31.12.1"
}

variable "fgtConfHostname" {
  default = "FGT-VM"
  type    = string
}

variable "fgtConfPort1Mask" {
  type    = string
  default = "255.255.255.0"
}

variable "fgtConfPort2Mask" {
  type    = string
  default = "255.255.255.0"
}
