variable "ProjectName" {}
variable "CompanyName" {}

variable "enableLbPublic" { type = bool }
variable "enableCrossZoneLoadBalancing" { type = bool }

variable "regionName" {}
variable "azList" {}

variable "nameAlb" {}

variable "subnetAlb" {}
variable "vpcId" {}

variable "portsAlb" {}
variable "ipAddrFwbPort1List" {}
