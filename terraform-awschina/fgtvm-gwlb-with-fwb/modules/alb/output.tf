output "alb" {
  value = "http://${aws_lb.alb.dns_name}${var.portsAlb.portAlbListener != 80 && var.portsAlb.protocolAlbListener == "TCP" ? ":${var.portsAlb.portAlbListener}" : ""}"
}
