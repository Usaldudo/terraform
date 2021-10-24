provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu-1" {
  count = 1
  ami   = "ami-0ff338189efb7ed37" # ubuntu
  # ami = "ami-0d15082500b576303" # amazon
  instance_type = "t3.micro"
  key_name      = "pc"
  tags = {
    Name  = "web-servers"
    Owner = "me"
  }
}
