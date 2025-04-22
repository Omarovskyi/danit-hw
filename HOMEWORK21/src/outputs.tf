output "public_ips" {
  value = module.ec2_instances.instance_public_ips
}