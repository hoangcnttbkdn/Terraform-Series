output "Test_server_ip" {
  value = aws_instance.my_instance.public_ip
}