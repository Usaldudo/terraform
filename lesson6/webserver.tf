# Terraform
#
# Build webserver

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
  ami                                  = "ami-0d15082500b576303" # Amazon linux
  instance_type                        = "t3.micro"
  key_name                             = "pc"
  vpc_security_group_ids               = [aws_security_group.my_webserver.id]
  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name = "WebServer"
  }
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Me",
    names  = ["Vasya", "Petya", "John"]
  })

  lifecycle {
    prevent_destroy = true # Запрет на удаление
    ignore_changes = [     # Игнорирование изменений
      ami, user_data
    ]
    create_before_destroy = true
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description      = "HTTP"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }


  egress = [
    {
      description      = "HTTP"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "my_webserversg"
  }
}
