terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

variable "owner" {
  default = "Vasya"
}

resource "random_password" "rds_passwd" {
  length           = 16
  special          = true
  override_special = "!#$&"
  keepers = {
    "keepeer1" = var.owner
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master password for RDS"
  type        = "SecureString"
  value       = random_password.rds_passwd.result
}

data "aws_ssm_parameter" "rds_mysql_password" {
  name = "/prod/mysql"
  depends_on = [
    aws_ssm_parameter.rds_password
  ]
}

resource "aws_db_instance" "my_db" {
  identifier           = "prod-rds"
  name                 = "prod"
  skip_final_snapshot  = true
  apply_immediately    = true
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "administrator"
  password             = data.aws_ssm_parameter.rds_mysql_password.value
  parameter_group_name = "default.mysql5.7"
}


# output "rds_password" {
#   value = data.aws_ssm_parameter.rds_mysql_password.value
# }
