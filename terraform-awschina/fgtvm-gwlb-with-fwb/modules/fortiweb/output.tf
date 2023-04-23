output "FortiWeb-Statistics" {
  value = [
    for cnt in range(local.cntFwb) :
    "[${var.licenseTypeFwb}] FWB-${var.CompanyName}-${cnt + local.cntFwbStart}: ${aws_instance.fortiweb[cnt].id} | https://${var.ipAddrFwbPort1List[cnt]}:${var.portFwbHttps}${var.enableDemoBastion == false ? " | https://${aws_eip.eipFwbMgmt[cnt].public_ip}:${var.portFwbHttps}" : ""}"
  ]
}
