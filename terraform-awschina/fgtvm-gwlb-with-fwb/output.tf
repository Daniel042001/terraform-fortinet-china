output "a_AZ-List" {
  value = local.azFtntList
}

output "a_VPC-Information" {
  value = "${local.idVpcNgfw} | ${var.cidrVpcNgfw}"
}

output "b_FortiGate-BYOL-Statistics" {
  value = var.cntFgtByol == 0 ? null : module.fortigate-byol.FortiGate-Statistics
}

output "b_FortiGate-PAYG-Statistics" {
  value = var.cntFgtPayg == 0 ? null : module.fortigate-payg.FortiGate-Statistics
}

output "c_FortiWeb-BYOL-Statistics" {
  value = var.cntFwbByol == 0 ? null : module.fortiweb-byol.FortiWeb-Statistics
}

output "d_NLB-Simple-WEB" {
  value = var.enableSimpleWebSrv == false ? null : module.nlbPublic.nlb
}

output "d_NLB-DVWA" {
  value = var.enableDemoDvwa == false ? null : "${module.nlbPublic.nlb}/DVWA/login.php"
}
