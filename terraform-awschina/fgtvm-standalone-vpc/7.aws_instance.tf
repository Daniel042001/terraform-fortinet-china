resource "aws_instance" "fgtStandalone" {
  ami               = var.licenseType == "byol" ? var.amiFgtBYOL[var.regionName] : var.amiFgtPAYG[var.regionName]
  instance_type     = var.instanceType
  availability_zone = var.azFgt
  user_data         = data.template_file.fgtStandalone.rendered

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    volume_size           = "2"
    volume_type           = "gp2"
  }

  ebs_block_device {
    delete_on_termination = "true"
    device_name           = "/dev/sdb"
    encrypted             = "false"
    volume_size           = "30"
    volume_type           = "gp2"
  }

  ebs_optimized = "true"

  network_interface {
    network_interface_id = aws_network_interface.eniFgtPublic.id
    device_index         = 0
  }

  tags = {
    Name      = var.instanceNameFGT
    Terraform = true
  }
}


resource "aws_network_interface_attachment" "eniFgtPrivateAttach" {
  instance_id          = aws_instance.fgtStandalone.id
  network_interface_id = aws_network_interface.eniFgtPrivate.id
  device_index         = 1
}


data "template_file" "fgtStandalone" {
  template = file("${var.instanceBootstrapFgt}")
  vars = {
    licenseType       = "${var.licenseType}"
    licenseFile       = "${var.licenseFile}"
    adminsPort        = "${var.adminsPort}"
    eniIpFgtPublic    = "${var.eniIpFgtPublic}"
    eniIpFgtPrivate   = "${var.eniIpFgtPrivate}"
    cidrSubnetPrivate = "${var.cidrSubnetPrivate}"
    fgtConfPort1GW    = "${var.fgtConfPort1GW}"
    fgtConfPort2GW    = "${var.fgtConfPort2GW}"
    fgtConfHostname   = "${var.fgtConfHostname}"
    fgtConfPort1Mask  = "${var.fgtConfPort1Mask}"
    fgtConfPort2Mask  = "${var.fgtConfPort2Mask}"
  }
}
