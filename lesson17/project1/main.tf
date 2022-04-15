provider "aws" {
  region = "eu-west-1"
}

module "vpc-default" {
  source = "../modules/aws_network"
}

module "vpc-dev" {
  source               = "../modules/aws_network"
  env                  = "dev"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}

output "dev_public_subnets_ids" {
  value = module.vpc-dev.public_subnet_ids
}
