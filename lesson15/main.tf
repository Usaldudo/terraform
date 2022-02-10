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

provider "aws" {
  region = "eu-central-1"
  alias  = "EU"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "IR"
}

#=====================================================
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*x86_64-gp2"]
  }
}

data "aws_ami" "eu_latest_amazon_linux" {
  provider    = aws.EU
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*x86_64-gp2"]
  }
}

data "aws_ami" "ir_latest_amazon_linux" {
  provider    = aws.IR
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*x86_64-gp2"]
  }
}
#================================================================
resource "aws_instance" "my_default_server" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.latest_amazon_linux.id
  tags = {
    "Name" = "Default Server"
  }
}

resource "aws_instance" "my_europe_server" {
  provider      = aws.EU
  instance_type = "t3.micro"
  ami           = data.aws_ami.eu_latest_amazon_linux.id
  tags = {
    "Name" = "Europe Server"
  }
}

resource "aws_instance" "my_ireland_server" {
  provider      = aws.IR
  instance_type = "t3.micro"
  ami           = data.aws_ami.ir_latest_amazon_linux.id
  tags = {
    "Name" = "Ireland Server"
  }
}

