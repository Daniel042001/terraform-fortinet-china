#################### AWS CHINA or AWS GLOBAL ####################
locals {
  nameAwsLocation = var.regionName == "cn-north-1" || var.regionName == "cn-northwest-1" ? "CHINA" : "GLOBAL"
  isFOS64         = length(regexall("6.4.[0-9][0-9]?", var.versionFgt)) > 0 ? true : false
  isFOS70         = length(regexall("7.0.[0-9][0-9]?", var.versionFgt)) > 0 ? true : false
}

locals {
  nameFgtByol = {
    CHINA  = local.isFOS64 == true ? "FGT_VM64_AWS-v6.4.9.F-build1966*" : local.isFOS70 == true ? "FGT_VM64_AWS-v7.0.7.F-build0367*" : "FortiGate-AWS-7.2.5_BYOL-Release*"
    GLOBAL = "FortiGate-VM64-AWS build*${var.versionFgt}*"
  }
  nameFgtPayg = {
    CHINA  = "FortiGate-AWS-7.2.5_PAYG-Release*"
    GLOBAL = "FortiGate-VM64-AWSONDEMAND build*${var.versionFgt}*"
  }
}



locals {
  amiFilterString = var.licenseTypeFgt == "byol" ? local.nameFgtByol[local.nameAwsLocation] : local.nameFgtPayg[local.nameAwsLocation]
}



data "aws_ami" "fortigate" {
  most_recent = true

  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = [local.amiFilterString]
  }
}
