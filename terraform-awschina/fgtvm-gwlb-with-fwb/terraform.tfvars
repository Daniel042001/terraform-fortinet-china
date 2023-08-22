ProjectName = "fgtvm-gwlb-with-fwb"
CompanyName = "FTNT"

#################### Features [toggle true/false] ####################
# when 'enableNewVpcNgfw = false', you must specific the following variable, for example
# terraform plan -out=tfplan -var "paramVpcCustomerId=vpc-049a1deda8161a407" -var "paramIgwId=igw-0b951c8cf77c2318f"
# cidrs and ipAddrs need change accordingly as well,
# -var variables are stackable
enableNewVpcNgfw          = true

# when 'enableFgStandalone = true', only FortiGate and GWLB will be provisioned, no NLB, no NAT-GW and related route table
enableFgStandalone        = true

# when 'enableFgStandalone = true', this will be ignored
enableNlbPreserveClientIp = true

# when 'enableDemoBastion = true', an Ubuntu instance will be placed into subnetBastionAz1
enableDemoBastion         = false

# when 'enableSimpleWebSrv = true', Ubuntu instance(s) will be placed into subnetApp[*] per az
enableSimpleWebSrv        = false

# when 'enableDemoDvwa = true', an Ubuntu instance will be placed into subnetDvwaAz1
enableDemoDvwa            = false

enableDemoApigw           = false



#################### VPC ####################
regionName                = "cn-northwest-1"

# azList = ["a"]
# azList = ["b"]
# azList = ["c"]
azList = ["a", "b"]
# azList = ["a", "c"]
# azList = ["b", "c"]
# azList = ["a", "b", "c"]

vpcName                   = "VPC-NGFW"
cidrVpcNgfw               = "172.25.0.0/16"

#################### Subnets ####################
cidrSubnetFgtPort1        = ["172.25.11.0/24",
                             "172.25.21.0/24",
                             "172.25.31.0/24"]
cidrSubnetFgtPort2        = ["172.25.12.0/24",
                             "172.25.22.0/24",
                             "172.25.32.0/24"]
cidrSubnetFwbPort1        = ["172.25.111.0/24",
                             "172.25.121.0/24",
                             "172.25.131.0/24"]
cidrSubnetNlbPublic       = ["172.25.201.0/24",
                             "172.25.202.0/24",
                             "172.25.203.0/24"]
cidrSubnetNatgwVpcNgfw    = ["172.25.211.0/24",
                             "172.25.212.0/24",
                             "172.25.213.0/24"]
cidrSubnetGwlbeNgfw       = ["172.25.251.0/24",
                             "172.25.252.0/24",
                             "172.25.253.0/24"]
cidrSubnetApp             = ["172.25.141.0/24",
                             "172.25.142.0/24",
                             "172.25.143.0/24"]
cidrSubnetBastionVncAz1   = "172.25.254.0/25"

#################### FortiGate ####################
cntFgtByol                = 0
cntFgtPayg                = 2

instanceTypeFgtFixed      = "c6i.large"

#### choose 'FortiGate FOS Version' ####
#### FortiGate in AWS-China will only work with FOS72!!!
# versionFgt              = "7.4.0"
# versionFgt              = "7.2.5"
versionFgt              = "7.0.12"
# versionFgt              = "6.4.13"

#################### FortiWeb ####################
cntFwbByol                = 0

portFwbHttps              = "8443"
instanceTypeFwbFixed      = "m5.large"

#### choose 'License Type' of FortiWeb ####
# licenseTypeFwb           = "payg"
licenseTypeFwb            = "byol"

#################### NLB ####################
portsNlb = {
    portNlbListener      = 80
    protocolNlbListener  = "TCP"
    portFwbListener      = 80
    protocolFwbListener  = "TCP"
    portFwbHealthChk     = 80
    protocolFwbHealthChk = "TCP"
}

#################### GENERAL SRV ####################
#### choose ubuntu ####
versionUbuntu             = "bionic1804"
# versionUbuntu            = "focal2004"
# versionUbuntu            = "jammy2204"

keynameUbuntu             = "kpc_linux"

#################### FortiGate Configuration File Variables ####################
# For configuration template file only, NOT for AWS provisioning
asgFgtClusterPSK      = "12345678"

portFgtHttps          = "8443"
licenseFiles          = [ 
                          "FGVM02TM22017609-AWS.lic",
                          "FGVM02TM22017610-AWS.lic",
                          "FGVM02TM22016495-Aliyun.lic",
                          "FGVM02TM22016496-Aliyun.lic",
                        ]
