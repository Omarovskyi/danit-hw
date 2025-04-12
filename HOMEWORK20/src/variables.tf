variable "prj_name" {}
variable "environment" {}

variable "list_of_open_ports" {
  type = list(number)
}
variable "instance_type" {}

locals {
  full_prj_name = "${var.prj_name}-${var.environment}"
}
