locals {
  nameEndpointSrvcGwlb = "vpce-srvc-for-gwlb"
  prefixGwlbeVpcNgfw   = "gwlbe-vpc-ngfw"
}



################### ENDPOINT SERVICE - GWLB ####################
resource "aws_vpc_endpoint_service" "vpceSrvcGwlbVpcNgfw" {
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
  count = length(var.azList)

  service_name      = aws_vpc_endpoint_service.vpceSrvcGwlbVpcNgfw.service_name
  subnet_ids        = [aws_subnet.subnetGwlbeNgfw[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.vpceSrvcGwlbVpcNgfw.service_type
  vpc_id            = local.idVpcNgfw

  tags = {
    Name      = "${local.prefixGwlbeVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}
