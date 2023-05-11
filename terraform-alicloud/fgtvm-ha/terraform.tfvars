#### Deploy NGFW in existing VPC
# terraform plan -out=tfplan -var "paramVpcNgfwId=vpc-049a1deda8161a407"
# cidrs and ipAddrs need change accordingly as well
#### END ####

#### Associate NGFW with existing EIPs
# terraform plan -out=tfplan -var "paramEipFgtCluster=eip-049a1deda8161a407" -var "paramEipFgtMgmt1=eip-049a1deda8161a407" -var "paramEipFgtMgmt2=eip-049a1deda8161a407"
# cidrs and ipAddrs need change accordingly as well
#### END ####


ProjectName = "fgtvm-ha"
CompanyName = "FTNT"

#################### VPC ####################
regionName                = "cn-huhehaote"

# Plese refer below for detail AliCloud region and availability zone.
# https://help.aliyun.com/document_detail/40654.html?spm=a2c4g.750001.0.i1
azList                    = ["b", "b"]
# azList                    = ["h", "h"]

nameVpcNgfw               = "VPC-SECURITY"
cidrVpcNgfw               = "172.25.0.0/16"

#################### Subnets ####################
cidrSubnetFgtPort1        = ["172.25.11.0/24",
                             "172.25.21.0/24"]
cidrSubnetFgtPort2        = ["172.25.12.0/24",
                             "172.25.22.0/24"]
cidrSubnetFgtPort3        = ["172.25.13.0/24",
                             "172.25.23.0/24"]
cidrSubnetFgtPort4        = ["172.25.14.0/24",
                             "172.25.24.0/24"]

#################### FortiGate ####################
instanceTypeFgtFixed      = "ecs.c6e.large"

#################### FortiGate Configuration File Variables ####################
portFgtHttps          = "8443"
licenseFiles          = [ 
                          "FGVM02TM22017609-AWS.lic",
                          "FGVM02TM22017610-AWS.lic",
                        ]