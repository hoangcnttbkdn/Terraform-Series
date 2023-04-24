output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "public_sg_name" {
  value = aws_security_group.public_sg.name
}

output "public_sg_description" {
  value = aws_security_group.public_sg.description
}

output "public_sg_ingress" {
  value = aws_security_group.public_sg.ingress
}
