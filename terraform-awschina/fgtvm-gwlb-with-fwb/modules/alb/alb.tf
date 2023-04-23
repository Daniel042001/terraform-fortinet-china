locals {
  nameAlb            = "${var.nameAlb}-${substr(var.vpcId, -8, -1)}"
  prefixEipAlbPublic = "eip-${local.nameAlb}"
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}



#################### ALB EIP ####################
resource "aws_eip" "eipAlbPublic" {
  count = var.enableLbPublic == true ? length(var.azList) : 0

  vpc = true

  tags = {
    Name      = "${local.prefixEipAlbPublic}-${local.azFtntList[count.index % length(var.azList)]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### ALB ####################
resource "aws_lb" "nlb" {
  name               = local.nameAlb
  load_balancer_type = "application"

  internal = var.enableLbPublic == true ? false : true

  dynamic "subnet_mapping" {
    for_each = var.azList
    content {
      subnet_id     = var.subnetAlb[subnet_mapping.key]
      allocation_id = var.enableLbPublic == true ? aws_eip.eipAlbPublic[subnet_mapping.key].id : null
    }
  }

  tags = {
    Name      = local.nameAlb
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### TARGET GROUP: HTTP ####################
resource "aws_lb_target_group" "tgtGrpAlbHttp" {
  name        = "backend-${var.portsAlb.protocolFwbListener}-${var.portsAlb.portFwbListener}"
  port        = var.portsAlb.portFwbListener
  protocol    = var.portsAlb.protocolFwbListener
  target_type = "ip"
  vpc_id      = var.vpcId

  health_check {
    interval = 30
    port     = var.portsAlb.portFwbHealthChk
    protocol = var.portsAlb.protocolFwbHealthChk
  }
}



#################### LISTENER ####################
resource "aws_lb_listener" "listenerAlbHttp" {
  load_balancer_arn = aws_lb.nlb.arn

  port     = var.portsAlb.portAlbListener
  protocol = var.portsAlb.protocolAlbListener

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgtGrpAlbHttp.arn
  }
}



resource "aws_lb_target_group_attachment" "attachIpAddrFwbPort1ToTgtgrpHttp" {
  count = length(var.ipAddrFwbPort1List)

  depends_on = [aws_lb_target_group.tgtGrpAlbHttp]

  target_group_arn = aws_lb_target_group.tgtGrpAlbHttp.arn
  target_id        = var.ipAddrFwbPort1List[count.index]
}
