output "FortiGate-Statistics" {
  value = [
    for cnt in range(local.cntFgt) :
    "[${var.licenseTypeFgt}] FG-${var.CompanyName}-${cnt + local.cntFgtStart}: ${aws_instance.fortigate[cnt].id} | https://${var.ipAddrFgtPort1List[cnt]}:${var.portFgtHttps}${var.enableDemoBastion == false ? " | https://${aws_eip.eipFgtMgmt[cnt].public_ip}:${var.portFgtHttps}" : ""}"
  ]
}
