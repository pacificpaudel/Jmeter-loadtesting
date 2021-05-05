# TF Main - Most resources are built with local modules
# Basic TF config

terraform {
    required_version = ">= 0.12.29"
      backend "s3" {
        bucket = "loadtest-states"
        dynamodb_table = "loadtest-state-lock"
        region = "eu-west-1"
        key = "loadtest.tfstate"
      }
}

# Basic AWS provider config
provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  version = ">= 2.61"
}

###############################################################################
### VPC Config ################################################################

# VPC config using the local vpc module
# (based on terraform-aws-modules/terraform-aws-vpc)
# local module
module "vpc" {
  source = "./modules/vpc"

  name = "loadtest-vpc"
  cidr = var.vpccidrblock
  azs = [
    "${var.region}a"
  ]
  public_subnets = var.vpcpublicsubnets
  private_subnets = var.vpcprivatesubnets
  enable_nat_gateway = false

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}VPC"
  }

  igw_tags = {
    Name = "${var.nametagprefix}IGW"
  }

  public_route_table_tags = {
    Name = "${var.nametagprefix}Public RT"
  }

  private_route_table_tags = {
    Name = "${var.nametagprefix}Private RT"
  }

  public_subnet_tags = {
    Name = "${var.nametagprefix} Public Subnet"
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
  }

  private_subnet_tags = {
    Name = "${var.nametagprefix} Private Subnet"
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
  }
}


###############################################################################
# EC2 Web server(s) and EIP config ############################################

# User data for EC2 instances
locals {

  user_data = <<EOF
#!/bin/bash

sudo su
echo -e "\nPort 22" >> /etc/ssh/sshd_config
service sshd restart
yum update -y
yum install java-1.8.0-openjdk-src.x86_64
yum install java-1.8.0-openjdk-headless.x86_64 -y
wget https://www.nic.funet.fi/pub/mirrors/apache.org//jmeter/binaries/apache-jmeter-5.4.1.tgz
tar -xf apache-jmeter-5.4.1.tgz
cd /apache-jmeter-5.4.1/bin
./jmeter.sh
EOF

}

# local modules
module "loadtest_server" {
  source = "./modules/ec2"
  instance_count = 1
  name = "loadtest-server"
  key_name = "loadtest-keys"

  #AMI from loadtest server in eu-west-1
  ami = "ami-063d4ab14480ac177"

  #instance_type = "c5.xlarge"
  instance_type = "m5.xlarge"

  subnet_ids = [
    module.vpc.public_subnets[0]
    #module.vpc.private_subnets[0],
    #module.vpc.private_subnets[1]
  ]
  vpc_security_group_ids = [
    aws_security_group.allow-all-out.id,
    aws_security_group.allow-http-https-in-public.id,
    aws_security_group.allow-ssh-in-public.id,
    aws_security_group.allow-load-test.id
  ]
  associate_public_ip_address = true
  private_ips = [
    "10.1.1.11"
  #  "10.1.2.11",
  #  "10.1.4.11"
  ]

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
      encrypted   = false
    }
  ]

  user_data_base64 = base64encode(local.user_data)

  tags = {
    Name =  "${var.nametagprefix}-Server"
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
  }

  volume_tags = {
    Name =  "${var.nametagprefix}Server root volume"
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
  }
}

#Elastic IP for web server and related association to web server
resource "aws_eip" "loadtest_eip" {
  vpc = true
  tags = {
    Name =  "${var.nametagprefix}EIP"
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
  }
  depends_on = [ module.vpc.igw_id ]
}

resource "aws_eip_association" "loadtest_eip_assoc" {
  instance_id = module.loadtest_server.id[0]
  allocation_id = aws_eip.loadtest_eip.id
}
