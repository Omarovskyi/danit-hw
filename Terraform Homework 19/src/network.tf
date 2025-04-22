provider "aws" {
  region  = "eu-central-1"
  profile = "mfa"
}

terraform {
  backend "s3" {
    bucket  = "lesson-examples"
    key     = "iac-4/terraform.tfstate"
    region  = "eu-central-1"
    profile = "mfa"
  }
}

resource "aws_vpc" "hw-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "hw19-vpc"
    Owner = "Omarovskyi"
  }
}

resource "aws_subnet" "hw-subnet-public" {
  vpc_id                  = aws_vpc.hw-vpc.id
  cidr_block              = "10.0.15.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name  = "hw19-subnet-public"
    Owner = "Omarovskyi"
  }
}

resource "aws_subnet" "hw-subnet-private" {
  vpc_id     = aws_vpc.hw-vpc.id
  cidr_block = "10.0.25.0/24"

  tags = {
    Name  = "hw19-subnet-private"
    Owner = "Omarovskyi"
  }
}

resource "aws_eip" "hw-eip" {
  domain = "vpc"

  tags = {
    Name  = "hw19-eip"
    Owner = "Omarovskyi"
  }
}

resource "aws_internet_gateway" "hw-igw" {
  vpc_id = aws_vpc.hw-vpc.id

  tags = {
    Name  = "hw19-igw"
    Owner = "Omarovskyi"
  }
}

resource "aws_nat_gateway" "hw-ngw" {
  allocation_id = aws_eip.hw-eip.id
  subnet_id     = aws_subnet.hw-subnet-public.id

  tags = {
    Owner = "Omarovskyi"
  }
}

resource "aws_route_table" "hw-rt-public" {
  vpc_id = aws_vpc.hw-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hw-igw.id
  }

  tags = {
    Owner = "Omarovskyi"
  }
}

resource "aws_route_table_association" "hw-rt-association-public" {
  subnet_id      = aws_subnet.hw-subnet-public.id
  route_table_id = aws_route_table.hw-rt-public.id
}

resource "aws_route_table" "hw-rt-private" {
  vpc_id = aws_vpc.hw-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.hw-ngw.id
  }

  tags = {
    Owner = "Omarovskyi"
  }
}

resource "aws_route_table_association" "hw-rt-association-private" {
  subnet_id      = aws_subnet.hw-subnet-private.id
  route_table_id = aws_route_table.hw-rt-private.id
}