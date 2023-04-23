module "nlbPublic" {
  source                       = "./modules/nlb"
  nameNlb                      = "nlb-public"
  ProjectName                  = var.ProjectName
  CompanyName                  = var.CompanyName
  enableLbPublic               = true
  enableCrossZoneLoadBalancing = false
  preserveClientIp             = var.enableNlbPreserveClientIp
  regionName                   = var.regionName
  azList                       = var.azList
  vpcId                        = local.idVpcNgfw
  subnetNlb                    = [for subnet in aws_subnet.subnetNlbPublic : subnet.id]
  portsNlb                     = var.portsNlb
  ipAddrFwbPort1List           = local.ipAddrFwbPort1ListByol
}
