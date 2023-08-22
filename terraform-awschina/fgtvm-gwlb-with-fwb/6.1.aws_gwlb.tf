locals {
  nameGwlbFgt          = "gwlb-fgt-${substr(local.idVpcNgfw, -8, -1)}"
  nameGwlbFgtTargetGrp = "gwlb-target-fgt-${substr(local.idVpcNgfw, -8, -1)}"
}

resource "aws_lb" "gwlbFgt" {
  name                             = local.nameGwlbFgt
  load_balancer_type               = "gateway"
  enable_cross_zone_load_balancing = true

  dynamic "subnet_mapping" {
    for_each = var.azList
    content {
      subnet_id = aws_subnet.subnetFgtPort2[subnet_mapping.key].id
    }
  }

  tags = {
    Name      = local.nameGwlbFgt
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_lb_target_group" "gwlbFgtTargetGrp" {
  name        = local.nameGwlbFgtTargetGrp
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = local.idVpcNgfw

  health_check {
    port     = 8008
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "gwlbFgtListener" {
  load_balancer_arn = aws_lb.gwlbFgt.arn

  default_action {
    target_group_arn = aws_lb_target_group.gwlbFgtTargetGrp.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "targetGrpToFgtByol" {
  count = var.cntFgtByol

  target_group_arn = aws_lb_target_group.gwlbFgtTargetGrp.arn
  target_id        = local.ipAddrFgtPort2ListByol[count.index]
  port             = 6081
}

resource "aws_lb_target_group_attachment" "targetGrpToFgtPayg" {
  count = var.cntFgtPayg

  target_group_arn = aws_lb_target_group.gwlbFgtTargetGrp.arn
  target_id        = local.ipAddrFgtPort2ListPayg[count.index]
  port             = 6081
}

#################### GWLB GENEVE ENI ####################
data "aws_network_interface" "eniGwlbeVpcNgfw" {
  count = length(var.azList)

  depends_on = [aws_lb_listener.gwlbFgtListener]

  filter {
    name   = "subnet-id"
    values = [aws_subnet.subnetFgtPort2[count.index].id]
  }

  filter {
    name   = "status"
    values = ["in-use"]
  }

  filter {
    name   = "description"
    values = ["*ELB gwy/${local.nameGwlbFgt}/*"]
  }
}
