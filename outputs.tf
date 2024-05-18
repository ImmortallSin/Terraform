output "ec2pubip" {
    value = aws_instance.admin0.public_ip
}

output "ec2id" {
  value = aws_instance.admin0.id
}

output "pubdns" {
  value = aws_instance.admin0.public_dns
}

output "ec2tag" {
  value = aws_instance.admin0.tags
}