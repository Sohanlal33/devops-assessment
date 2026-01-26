output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Nexgen_assessment.public_ip
}
output "elastic_ip" {
  description = "Elastic IP allocated and attached to EC2 instance"
  value       = aws_eip.app_eip.public_ip
}

