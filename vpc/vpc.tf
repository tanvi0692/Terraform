# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
# create the VPC
resource "aws_vpc" "VPC-01" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "VPC-01"
}
} # end resource
# create the Subnet
resource "aws_subnet" "VPC-01-Subnet" {
  vpc_id                  = aws_vpc.VPC-01.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "My VPC Subnet"
}
} # end resource
# Create the Security Group
resource "aws_security_group" "VPC-01-Security-Group" {
  vpc_id       = aws_vpc.VPC-01.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "VPC 01 Security Group"
   Description = "My VPC Security Group"
}
} # end resource
# create VPC Network access control list
resource "aws_network_acl" "VPC-01-Security-ACL" {
  vpc_id = aws_vpc.VPC-01.id
  subnet_ids = [ aws_subnet.VPC-01-Subnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "VPC 01 ACL"
}
} # end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "VPC-01-GW" {
 vpc_id = aws_vpc.VPC-01.id
 tags = {
        Name = "VPC 01 Internet Gateway"
}
} # end resource
# Create the Route Table
resource "aws_route_table" "VPC-01-route-table" {
 vpc_id = aws_vpc.VPC-01.id
 tags = {
        Name = "My VPC Route Table"
}
} # end resource
# Create the Internet Access
resource "aws_route" "VPC-01-internet-access" {
  route_table_id         = aws_route_table.VPC-01-route-table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.VPC-01-GW.id
} # end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "VPC-01-association" {
  subnet_id      = aws_subnet.VPC-01-Subnet.id
  route_table_id = aws_route_table.VPC-01-route-table.id
} # end resource
# end vpc.tf