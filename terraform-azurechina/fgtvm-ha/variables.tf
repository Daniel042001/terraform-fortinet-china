variable "ProjectName" { type = string }
variable "CompanyName" { type = string }

#################### INPUT VARIABLES ####################
variable "paramNameResrcGrp" {
  type    = string
  default = ""
}

variable "paramNameVnetNgfw" {
  type    = string
  default = ""
}

#################### VPC ####################
variable "nameResrcGrp" { type = string }
variable "locationResrcGrp" { type = string }

variable "nameVnetNgfw" { type = string }
variable "locationVnetNgfw" { type = string }
variable "cidrVnetNgfw" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrVnetNgfw, 0, 0))
    error_message = "MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

#################### Subnets ####################
variable "cidrSubnetFgtPort1" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrSubnetFgtPort1, 0, 0))
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort2" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrSubnetFgtPort2, 0, 0))
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort3" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrSubnetFgtPort3, 0, 0))
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort4" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrSubnetFgtPort4, 0, 0))
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

# #################### FortiGate ####################
variable "instanceTypeFgtFixed" { type = string }
variable "consolidateHaPort" { type = bool }
variable "adminUsername" { type = string }
variable "adminPassword" { type = string }

variable "imageVersion" { type = string }
variable "verFgtChina" {
  type = map(any)
  default = {
    fgtvm64 = "6.4.9"
    fgtvm70 = "7.0.9"
    fgtvm72 = "7.2.3"
  }
}

variable "imageOfferFgtChina" {
  type = map(any)
  default = {
    fgtvm64 = "fortinet_fortigate-vm_v7_2"
    fgtvm70 = "fortinet_fortigate-vm_v7_0"
    fgtvm72 = "fortinet_fortigate-vm_v7_2"
  }
}

variable "skuFgtChina" {
  type = map(any)
  default = {
    fgtvm64 = "fortinet_fg-vm_7_2"
    fgtvm70 = "fortinet_fg-vm_7_0"
    fgtvm72 = "fortinet_fg-vm_7_2"
  }
}


#################### FortiGate Configuration File Variables ####################
variable "portFgtHttps" {
  type = string
  validation {
    condition     = can(regex("^(?:0|[1-9]\\d{0,3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$", var.portFgtHttps))
    error_message = "VALUE MUST BE IN RANGE FROM 0 TO 65535"
  }
}

variable "licenseFiles" {
  type    = list(string)
  default = [""]
}
