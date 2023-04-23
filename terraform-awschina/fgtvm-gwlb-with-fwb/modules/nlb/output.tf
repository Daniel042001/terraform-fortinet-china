output "nlb" {
  value = "http://${aws_lb.nlb.dns_name}${var.portsNlb.portNlbListener != 80 && var.portsNlb.protocolNlbListener == "TCP" ? ":${var.portsNlb.portNlbListener}" : ""}"
}
