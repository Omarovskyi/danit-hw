provider "aws" {
  region  = "eu-central-1"
  profile = "mfa"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Omarovskyi-VPC"
  }
}

resource "aws_subnet" "main" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Omarovskyi-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Omarovskyi-GW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Omarovskyi-RouteTable"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.public.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "ec2_instances" {
  source              = "./modules/ec2-nginx"
  subnet_ids          = aws_subnet.main[*].id
  instance_type       = var.instance_type
  instance_count      = var.instance_count
  ami                 = data.aws_ami.amazon_linux.id
  ssh_key_pair_name   = var.ssh_key_pair_name
  vpc_id              = aws_vpc.main.id         
  allowed_ports       = var.allowed_ports
}

resource "local_file" "ssh_key" {
  content         = module.ec2_instances.ssh_private_key
  filename        = "${path.module}/ansible/private.key"
  file_permission = "0400"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    instance_ips = module.ec2_instances.instance_public_ips
  })
  filename = "${path.module}/ansible/inventory"
}