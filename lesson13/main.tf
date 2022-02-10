terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null",
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt "
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "print('Hello world!')"
    interpreter = [
      "python", "-c"
    ]
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Petya"
      NAME3 = "Kolya"
    }
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> logs.txt"
  }
  depends_on = [
    null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4
  ]
}
