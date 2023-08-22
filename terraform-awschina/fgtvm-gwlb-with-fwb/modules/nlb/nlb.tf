locals {
  nameNlb            = "${var.nameNlb}-${substr(var.vpcId, -8, -1)}"
  prefixEipNlbPublic = "eip-${local.nameNlb}"
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}



#################### NLB EIP ####################
resource "aws_eip" "eipNlbPublic" {
  count = var.enableLbPublic == true ? length(var.azList) : 0

  domain = "vpc"

  tags = {
    Name      = "${local.prefixEipNlbPublic}-${local.azFtntList[count.index % length(var.azList)]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### NLB ####################
resource "aws_lb" "nlb" {
  name               = local.nameNlb
  load_balancer_type = "network"

  internal = var.enableLbPublic == true ? false : true

  enable_cross_zone_load_balancing = var.enableCrossZoneLoadBalancing

  dynamic "subnet_mapping" {
    for_each = var.azList
    content {
      subnet_id     = var.subnetNlb[subnet_mapping.key]
      allocation_id = var.enableLbPublic == true ? aws_eip.eipNlbPublic[subnet_mapping.key].id : null
    }
  }

  tags = {
    Name      = local.nameNlb
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### TARGET GROUP: HTTP ####################
resource "aws_lb_target_group" "tgtGrpNlbHttp" {
  name               = "backend-${var.portsNlb.protocolFwbListener}-${var.portsNlb.portFwbListener}"
  port               = var.portsNlb.portFwbListener
  protocol           = var.portsNlb.protocolFwbListener
  target_type        = "ip"
  vpc_id             = var.vpcId
  preserve_client_ip = var.preserveClientIp

  health_check {
    interval = 30
    port     = var.portsNlb.portFwbHealthChk
    protocol = var.portsNlb.protocolFwbHealthChk
  }
}



#################### LISTENER ####################
resource "aws_lb_listener" "listenerNlbHttp" {
  load_balancer_arn = aws_lb.nlb.arn

  port     = var.portsNlb.portNlbListener
  protocol = var.portsNlb.protocolNlbListener

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgtGrpNlbHttp.arn
  }
}



resource "aws_lb_target_group_attachment" "attachIpAddrFwbPort1ToTgtgrpHttp" {
  count = length(var.ipAddrFwbPort1List)

  depends_on = [aws_lb_target_group.tgtGrpNlbHttp]

  target_group_arn = aws_lb_target_group.tgtGrpNlbHttp.arn
  target_id        = var.ipAddrFwbPort1List[count.index]
}
