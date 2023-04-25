module "vpc" {
  source = "../modules/network"

  vpc_cidr_block     = var.vpc_cidr_block
  private_subnet     = var.private_subnet
  public_subnet      = var.public_subnet
  availability_zone  = var.availability_zone
  project_name       = var.project_name
  create_nat_gateway = false
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey" # Create "myKey" to AWS!!
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.key.private_key_pem}' > ./myKey.pem"
  }
}

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/ansible.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-0ba13f7ae7e798cac"
  instance_type          = "t2.micro"
  subnet_id              = element(module.vpc.public_subnet_ids, 0)
  vpc_security_group_ids = [module.vpc.public_sg_id]
  key_name               = aws_key_pair.kp.key_name
  user_data              = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
  EOF

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --key-file ansible.pem -T 300 -i '${self.public_ip},', ../ansible/playbooks/playbook.yaml"
  }

  tags = {
    Name = "Test-server"
  }
}
