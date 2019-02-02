variable "region" {}

variable "vpc-cidr" {}

variable "subnet-cidr-public1" {}
variable "subnet-cidr-public2" {}

# for the purpose of this exercise use the default key pair on your local system
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key" {
  default = "~/.ssh/id_rsa"
}

variable "ami" {}