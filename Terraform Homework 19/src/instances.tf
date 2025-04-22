resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key-public" {
  key_name   = "hw19-key"
  public_key = tls_private_key.ssh-key.public_key_openssh
}

resource "aws_security_group" "hw-sg" {
  name   = "HW19-SSH"
  vpc_id = aws_vpc.hw-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "Omarovskyi"
  }
}

resource "aws_instance" "hw-instance-public" {
  ami                    = "ami-0bade3941f267d2b8"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.hw-subnet-public.id
  vpc_security_group_ids = [aws_security_group.hw-sg.id]
  key_name               = aws_key_pair.ssh-key-public.key_name

  tags = {
    Name  = "HW19-Instance-Public"
    Owner = "Omarovskyi"
  }
}

resource "aws_instance" "hw-instance-private" {
  ami                    = "ami-0bade3941f267d2b8"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.hw-subnet-private.id
  vpc_security_group_ids = [aws_security_group.hw-sg.id]
  key_name               = aws_key_pair.ssh-key-public.key_name

  tags = {
    Name  = "HW19-Instance-Private"
    Owner = "Omarovskyi"
  }
}