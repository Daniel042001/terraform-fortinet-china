variable "ProjectName" { type = string }
variable "regionName" { type = string }

variable "azFtnt1" { type = string }

#################### VPC-FGT ####################
variable "vpcNameNgfw" { type = string }
variable "cidrVpcNgfw" { type = string }

# VPC-FGT - Subnets AZ1
variable "cidrSubnetFgtPublicAz1" { type = string }
variable "cidrSubnetFgtPrivateAz1" { type = string }

variable "ipAddrFgtPublicAz1" { type = string }
variable "ipAddrFgtPrivateAz1" { type = string }

#################### FortiGate ####################
variable "hostnameFgtAz1" { type = string }
variable "instanceTypeFgt" { type = string }

variable "licenseType" { type = string }
variable "imageVersion" { type = string }
variable "dataDiskSzFgt" { type = string }

#################### FortiGate Configuration File Variables ####################
# For configuration template file only, NOT for AWS provisioning
variable "instanceBootstrapFile" { type = string }
variable "portFgtHttps" { type = string }
variable "licenseFile" { type = string }


#################### Optional Arguments ####################
variable "isProvisionVpcSniffer" { type = bool }

variable "paramVpcCustomerId" {
  type    = string
  default = ""
}

variable "paramIgwId" {
  type    = string
  default = ""
}
