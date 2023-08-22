locals {
  nameEndpointSrvcGwlb = "vpce-srvc-for-gwlb"
  prefixGwlbeVpcNgfw   = "gwlbe-vpc-ngfw"
}



################### ENDPOINT SERVICE - GWLB ####################
resource "aws_vpc_endpoint_service" "vpceSrvcGwlbVpcNgfw" {
  count = var.enableFgStandalone == true ? 0 : 1

  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlbFgt.arn]

  tags = {
    Name      = local.nameEndpointSrvcGwlb
    Terraform = true
    Project   = var.ProjectName
  }
}



################### GWLBE AT VPC-FGT ####################
resource "aws_vpc_endpoint" "gwlbeVpcNgfw" {
  count = var.enableFgStandalone == true ? 0 : length(var.azList)

  service_name      = aws_vpc_endpoint_service.vpceSrvcGwlbVpcNgfw[0].service_name
  subnet_ids        = [aws_subnet.subnetGwlbeNgfw[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.vpceSrvcGwlbVpcNgfw[0].service_type
  vpc_id            = local.idVpcNgfw

  tags = {
    Name      = "${local.prefixGwlbeVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}
