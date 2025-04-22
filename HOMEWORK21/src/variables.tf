variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = 2
}
variable "ssh_key_pair_name" {
  description = "Name of the existing SSH key pair to use for EC2 instance"
  type        = string
  default     = "Omarovskyi"
}

variable "allowed_ports" {
  type    = list(number)
  default = [22, 80]
}