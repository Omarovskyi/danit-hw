variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {}
variable "instance_count" {}
variable "ami" {}
variable "vpc_id" {}
variable "ssh_key_pair_name" {
  description = "Name of the existing SSH key pair to use for EC2 instance"
  type        = string
}
variable "allowed_ports" {
  type = list(number)
}