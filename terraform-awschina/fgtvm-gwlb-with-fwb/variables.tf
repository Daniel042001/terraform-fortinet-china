variable "ProjectName" { type = string }
variable "CompanyName" { type = string }

#################### Features [toggle true/false] ####################
variable "enableNewVpcNgfw" { type = bool }
variable "paramVpcCustomerId" {
  type    = string
  default = ""
}
variable "paramIgwId" {
  type    = string
  default = ""
}

variable "enableFgStandalone" { type = bool }
variable "enableNlbPreserveClientIp" { type = bool }

variable "enableDemoBastion" { type = bool }
variable "enableSimpleWebSrv" { type = bool }
variable "enableDemoDvwa" { type = bool }
variable "enableDemoApigw" { type = bool }

#################### VPC ####################
variable "regionName" { type = string }
variable "azList" {
  type    = list(string)
  default = [""]
}
variable "vpcName" { type = string }
variable "cidrVpcNgfw" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrVpcNgfw, 0, 0))
    error_message = "MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

#################### Subnets ####################
variable "cidrSubnetFgtPort1" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort1 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort2" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort2 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFwbPort1" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFwbPort1 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetApp" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetApp : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetNlbPublic" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetNlbPublic : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetNatgwVpcNgfw" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetNatgwVpcNgfw : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetGwlbeNgfw" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetGwlbeNgfw : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetBastionVncAz1" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrSubnetBastionVncAz1, 0, 0))
    error_message = "MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

#################### FortiGate ####################
variable "cntFgtByol" {
  type = number
  validation {
    condition     = var.cntFgtByol >= 0
    error_message = "FortiGate-BYOL COUNT MUST BE GREAT THAN OR EQUAL TO 0"
  }
}

variable "cntFgtPayg" {
  type = number
  validation {
    condition     = var.cntFgtPayg >= 0
    error_message = "FortiGate-PAYG COUNT MUST BE GREAT THAN OR EQUAL TO 0"
  }
}

variable "instanceTypeFgtFixed" { type = string }

variable "versionFgt" {
  type = string
  validation {
    condition     = can(regex("^([6|7].[0|2|4].[0-9][0-9]?)$", var.versionFgt))
    error_message = "PLEASE CHOOSE FROM '6.4.x', '7.0.x', '7.2.x' OR '7.4.x'"
  }
}

#################### FortiWeb ####################
variable "cntFwbByol" {
  type = number
  validation {
    condition     = var.cntFwbByol >= 0
    error_message = "FortiWeb COUNT MUST BE GREAT THAN OR EQUAL TO 0"
  }
}

variable "portFwbHttps" {
  type = string
  validation {
    condition     = can(regex("^(?:0|[1-9]\\d{0,3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$", var.portFwbHttps))
    error_message = "VALUE MUST BE IN RANGE FROM 0 TO 65535"
  }
}
variable "instanceTypeFwbFixed" { type = string }
variable "licenseTypeFwb" {
  type = string
  validation {
    condition     = can(regex("^(byol|payg)$", var.licenseTypeFwb))
    error_message = "PLEASE CHOOSE FROM 'byol' OR 'payg'"
  }
}

#################### NLB ####################
variable "portsNlb" {
  type = object({
    portNlbListener      = number
    protocolNlbListener  = string
    portFwbListener      = number
    protocolFwbListener  = string
    portFwbHealthChk     = number
    protocolFwbHealthChk = string
  })
}

#################### GENERAL SRV ####################
variable "versionUbuntu" {
  type = string
  validation {
    condition     = can(regex("^(bionic1804|focal2004|jammy2204)$", var.versionUbuntu))
    error_message = "PLEASE CHOOSE FROM 'bionic1804', 'focal2004' OR 'jammy2204'"
  }
}
variable "keynameUbuntu" { type = string }

#################### FortiGate Configuration File Variables ####################
# For configuration template file only, NOT for AWS provisioning
variable "asgFgtClusterPSK" { type = string }

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
