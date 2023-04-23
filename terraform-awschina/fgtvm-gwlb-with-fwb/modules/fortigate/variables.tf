variable "ProjectName" {}
variable "CompanyName" {}

variable "enableDemoBastion" { type = bool }

variable "regionName" {}
variable "azList" {}

variable "cidrSubnetFgtPort1" {}
variable "cidrSubnetFgtPort2" {}

variable "ipAddrFgtStart" {}
variable "ipAddrFgtPort1List" {}
variable "ipAddrFgtPort2List" {}


variable "cntFgtByol" {}
variable "cntFgtPayg" {}
variable "versionFgt" {}
variable "instanceTypeFgtFixed" {}

variable "portFgtHttps" {}
variable "asgFgtClusterPSK" {}

variable "instanceBootstrapFgt" { type = string }

variable "licenseTypeFgt" {}
variable "licenseFiles" {}

variable "sgFgtPort1" {}
variable "sgFgtPort2" {}

variable "subnetFgtPort1" {}
variable "subnetFgtPort2" {}

variable "ipAddrEniGwlbAz1" {}
variable "ipAddrEniGwlbAz2" {}
variable "ipAddrEniGwlbAz3" {}
