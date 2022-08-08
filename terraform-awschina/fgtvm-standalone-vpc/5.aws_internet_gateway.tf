resource "aws_internet_gateway" "vpcNgfwIgw" {
  vpc_id = aws_vpc.vpcNgfw.id

  tags = {
    Name      = "IGW"
    Terraform = true
  }
}
