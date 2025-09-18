provider "aws" {
  region = var.region
  profile = var.developer_profile
}

module "network" {
  source             = "./modules/network"
  name               = var.project
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  az                 = var.az
}

module "security_group" {
  source = "./modules/security-group"
  name   = var.project
  vpc_id = module.network.vpc_id
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [module.security_group.sg_id]
  key_name               = var.key_name

  #user_data = file(var.user_data_file)

  tags = {
    Name = "${var.project}-ec2"
  }
}
