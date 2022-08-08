#################### VPC ####################
output "VpcNgfwId" {
  value = aws_vpc.vpcNgfw.id
}

#################### Subnet Primary ####################
output "FortiGateId" {
  value = aws_instance.fgtStandalone.id
}

output "AZ" {
  value = aws_subnet.subnetPublic.availability_zone
}

output "SubnetPublic" {
  value = aws_subnet.subnetPublic.cidr_block
}

output "SubnetPrivate" {
  value = aws_subnet.subnetPrivate.cidr_block
}


#################### EIPs ####################
output "EIP-FGT" {
  value = aws_eip.eipFgt.public_ip
}
