#################### VPC ####################
regionName           = "cn-northwest-1"
azFgt                = "cn-northwest-1a"
vpcName              = "VPC-NGFW"
cidrVpcNgfw          = "172.31.0.0/16"

#################### Subnet FGT ####################
subnetPublicName     = "Subnet_Public"
subnetPrivateName    = "Subnet_Private"
cidrSubnetPublic     = "172.31.11.0/24"
cidrSubnetPrivate    = "172.31.12.0/24"

#################### ENI IP Address ####################
eniIpFgtPublic       = "172.31.11.11"
eniIpFgtPrivate      = "172.31.12.11"


#################### FortiGate ####################
licenseType          = "byol"
instanceType         = "c5.large"
instanceNameFGT      = "FGT-AWS-Standalone"


#################### FortiGate Configuration File Variables ####################
# For configuration template file only, NOT for AWS provisioning
instanceBootstrapFgt = "7.aws_instance_fgt.conf"
adminsPort           = "443"
licenseFile          = "FGVM02TM22017609-AWS.lic"

fgtConfPort1GW       = "172.31.11.1"
fgtConfPort2GW       = "172.31.12.1"
fgtConfHostname      = "FGT-AWS-Standalone"
fgtConfPort1Mask     = "255.255.255.0"
fgtConfPort2Mask     = "255.255.255.0"