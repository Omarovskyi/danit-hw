data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon-linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

module "hw-task" {
  source             = "./modules/task"
  project_name       = local.full_prj_name
  list_of_open_ports = var.list_of_open_ports
  instance_ami       = data.aws_ami.amazon-linux.id
  instance_type      = var.instance_type
  vpc_id             = data.aws_vpc.default.id
  subnet_id          = data.aws_subnets.default_vpc_subnets.ids[0]
}
