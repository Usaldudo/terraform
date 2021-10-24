provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu-1"  {
    count = 2
    ami = "ami-0ff338189efb7ed37"
    instance_type = "t3.micro"
}