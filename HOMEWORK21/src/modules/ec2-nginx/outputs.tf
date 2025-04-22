output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}