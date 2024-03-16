terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "sock-shop-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = ""
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}
 
data "aws_availability_zones" "azs" {}

module "sock-shop-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"
  
  name             = "sock-shop-vpc"
  cidr             = var.vpc_cidr_block
  private_subnets  = var.private_subnet_cidr_blocks
  public_subnets   = var.public_subnet_cidr_blocks
  azs              = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/sock-shop-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/sock-shop-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/sock-shop-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

 