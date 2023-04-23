variable "ProjectName" {}
variable "CompanyName" {}

variable "enableLbPublic" { type = bool }
variable "enableCrossZoneLoadBalancing" { type = bool }
variable "preserveClientIp" { type = bool }

variable "regionName" {}
variable "azList" {}

variable "nameNlb" {}

variable "subnetNlb" {}
variable "vpcId" {}

variable "portsNlb" {}
variable "ipAddrFwbPort1List" {}
