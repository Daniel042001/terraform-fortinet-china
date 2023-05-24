ProjectName = "fgtvm-ha"
CompanyName = "FTNT"

#### Deploy NGFW in existing Resource Group
##
# terraform plan -out=tfplan -var "paramNameResrcGrp=rgrp-daniel"
##
#### END ####

#### Deploy NGFW in existing Resource Group and VNET
##
# terraform plan -out=tfplan -var "paramNameResrcGrp=rgrp-daniel" -var "paramNameVnetNgfw=VNET-NGFW"
##
# cidrs need change accordingly as well!!!
# nameResrcGrp, nameVnetNgfw will be ignored!!!
# locationResrcGrp, locationVnetNgfw will be ignored!!!
#### END ####

#################### RESOURCE GROUP ####################
nameResrcGrp               = "rgrp-daniel"
locationResrcGrp           = "chinanorth3"

#################### VNET ####################
nameVnetNgfw               = "VNET-NGFW"
locationVnetNgfw           = "chinanorth3"
cidrVnetNgfw               = "192.168.0.0/16"

#################### Subnets ####################
cidrSubnetFgtPort1         = "192.168.11.0/24"
cidrSubnetFgtPort2         = "192.168.12.0/24"
cidrSubnetFgtPort3         = "192.168.13.0/24"
cidrSubnetFgtPort4         = "192.168.14.0/24"

#################### FortiGate ####################
instanceTypeFgtFixed      = "Standard_F4s"

# once consolidateHaPort set to true, we will combine HAsync and Mgmt feature together into single port3,
# instead of HAsync places on port3, and Mgmt on port4,
# leaving port4 at your command.
consolidateHaPort         = false

# imageVersion          = "fgtvm72"
imageVersion          = "fgtvm70"
# imageVersion          = "fgtvm64"

adminUsername             = "adminuser"

#################### FortiGate Configuration File Variables ####################
portFgtHttps          = "8443"
licenseFiles          = [ 
                          "FGVM02TM22017607-Azure.lic",
                          "FGVM02TM22017608-Azure.lic",
                        ]