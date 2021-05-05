# TF Variables (mainly useful tag data here)

### General variables #########################################################

# Region
variable "region" {
  type    = string
  default = "eu-west-1"
}


#VPC CIDR Block
variable "vpccidrblock" {
  type    = string
  default = "10.1.0.0/16"
}

#VPC Public subnets -
variable "vpcpublicsubnets" {
  type    = list(string)
  default = [
    "10.1.1.0/24",
    "10.1.3.0/24"
  ]
}

#VPC Private subnets
variable "vpcprivatesubnets" {
  type    = list(string)
  default = [
    "10.1.2.0/24",
    "10.1.4.0/24"
  ]
}

#VPC Acceptable public internet address range for incoming traffic (for SGs)
variable "pubnwaddressrange" {
  type    = list(string)
  # Replace with "0.0.0.0/0" when setting up final env for devs
  default = [
    
    "0.0.0.0/0"
  ]
}

#VPC Acceptable private network address range for incoming traffic (for SGs)
variable "privatenwaddressrange" {
  type    = list(string)
  default = [
    "10.1.0.0/16"
  ]
}

# Main Fiarebastion IP address
variable "fiarebastionaddress" {
  type    = string
  default = "63.34.243.176/32"
}

### Tag variables #############################################################

# Billing target for the resource
variable "billingtag" {
  type    = string
  default = "Loadtest"
}

# Project linked to the resource
variable "projecttag" {
  type    = string
  default = "Loadtest"
}

# Creator of the resource
variable "creatortag" {
  type    = string
  default = "Prashanta"
}

# Name tag prefix
variable "nametagprefix" {
  type    = string
  default = "loadtest-"
}
