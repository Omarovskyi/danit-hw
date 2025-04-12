variable "vpc_id" {}
variable "project_name" {
  default = "Omarovskyi"
}
variable "list_of_open_ports" {
  description = "List of ports which should be opened for security group"
  type        = list(number)
}
variable "instance_ami" {}
variable "instance_type" {}
variable "subnet_id" {}
