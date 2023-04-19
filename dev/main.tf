module "vpc" {
  source = "../modules/network"

  vpc_cidr_block    = "10.0.0.0/16"
  private_subnet    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zone = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  project_name = "rekaizen"
  create_nat_gateway = false
}

resource "aws_key_pair" "hoangbvh_key" {
  key_name   = "hoangbvh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDxblHyALvIRvj5CzYQO3TG088y38ySd0CFex+c9JhD7dk9iGxbfZ/z2dGX/6KkH+P2AXlukOI0ze+8uIGARUcLCE/UCA3O59J1fJBOl1ujn6AesDRxqdKC00tQJMvQ5O27wXLZpv8DnwL14k9kqskV+dYv4YP/NAtTz7Spw3zbQTROIdwI71Qa5SiMPwVhklQjKWjSEA8+RpDTtfklz7Qw5idIa+e10yzoKkjaBs2pUjhFFO1mNr/OEjI6uY+BvnbZcDi5Mr9RjBS5t9VWcHjaAnwaVl6O68yjhkrE1ZkDyC3jTQE32X+h0b9qbTLuQe/E6XdeBBnV22Ui9cNUuY4dSkOYPqnkSAOPHqKo748xS4bnqDF/hFUrwap+eTntmoT39gL7DEdz/jHD8U1+5hBvrWyXPojPasiapni9KL7VxLZWExeTGh4STLgbbrINzVzfAbqi+6c81xqWayFRO8IE+XYHOSHsVY5FTISCjxAZohgyCPWEulvebWSpk8+7HSE= huyhoang@nitro5"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-052c9af0c988f8bbd"
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public_subnet_ids, 0)
  key_name      = aws_key_pair.hoangbvh_key.key_name
  user_data     = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
  EOF
  
}