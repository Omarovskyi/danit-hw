output "public_ec2_public_ip" {
  description = "Public IP of public EC2 instance"
  value       = aws_instance.hw-instance-public.public_ip
}

output "private_ec2_private_ip" {
  description = "Private IP of private EC2 instance"
  value       = aws_instance.hw-instance-private.private_ip
}

output "private_ssh_key" {
  description = "Private SSH key"
  value       = tls_private_key.ssh-key.private_key_pem
  sensitive   = true
}