output "Ubuntu-Statistics" {
  value = [
    for cnt in range(var.cntUbuntu) :
    "${var.nameUbuntu}-${var.CompanyName}-${cnt + 1}: ${aws_instance.ubuntu[cnt].id} | ssh -i ~/.ssh/${var.keynameUbuntu}.pem ubuntu@${aws_instance.ubuntu[cnt].private_ip}${var.public == true ? " | ssh -i ~/.ssh/${var.keynameUbuntu}.pem ubuntu@${aws_eip.eipUbuntu[cnt].public_ip}" : ""}"
  ]
}
