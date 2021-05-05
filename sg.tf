# Security group/firewall configuration

# allow all traffic out
resource "aws_security_group" "allow-all-out" {
  name        = "allow-all-out"
  description = "allow all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}All-Out"
  }
}

# allow inbound HTTP and HTTPS from the public Internet
resource "aws_security_group" "allow-http-https-in-public" {
  name        = "allow-http-https-in-public-v2"
  description = "allow inbound HTTP and HTTPS traffic from the public internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.pubnwaddressrange
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = var.pubnwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}HTTP-HTTPS-In-Public"
  }
}

# allow inbound HTTP and HTTPS from the private network
resource "aws_security_group" "allow-http-https-in-private" {
  name        = "allow-http-https-in-private-v2"
  description = "allow inbound HTTP and HTTPS traffic from the private network"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}HTTP-HTTPS-In-Private"
  }
}

# allow inbound SSH from the public internet
resource "aws_security_group" "allow-ssh-in-public" {
  name        = "allow-ssh-in-public"
  description = "allow inbound SSH traffic from the public Internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.pubnwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}SSH-In-Public"
  }
}

# allow inbound SSH from the private network
resource "aws_security_group" "allow-ssh-in-private" {
  name        = "allow-ssh-in-private"
  description = "allow inbound SSH traffic from the private network"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}SSH-In-Private"
  }
}

# allow inbound SSH to port 4422 from the public internet
resource "aws_security_group" "allow-ssh4422-in-public" {
  name        = "allow-ssh4422-in-public"
  description = "allow inbound SSH traffic to port 4422 from public internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 4422
    to_port   = 4422
    protocol  = "tcp"
    cidr_blocks = var.pubnwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}SSH4422-In-Public"
  }
}


# allow inbound SSH to port 4422 from the private network
resource "aws_security_group" "allow-ssh4422-in-private" {
  name        = "allow-ssh4422-in-private"
  description = "allow inbound SSH traffic to port 4422 from the private network"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 4422
    to_port   = 4422
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}SSH4422-In-Private"
  }
}

####################

# allow iload test port
resource "aws_security_group" "allow-load-test" {
  name        = "allow-load-test"
  description = "allow inbound HTTP and HTTPS traffic from the private network"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 4445
    to_port   = 4445
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  ingress {
    from_port = 4445
    to_port   = 4445
    protocol  = "tcp"
    cidr_blocks = var.privatenwaddressrange
  }

  tags = {
    Billing = var.billingtag
    Creator = var.creatortag
    Project = var.projecttag
    Name = "${var.nametagprefix}-4445-flood-port"
  }
}
