variable "region" {
  description = "Region for the VPC"
  default = "eu-west-1"
}

variable "zone" {
  description = "Zone for the VPC"
  default = "eu-west-1a"
}


variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.10.2.0/24"
}

variable "ami" {
  description = "Ubuntu Linux AMI"
  default = "ami-089cc16f7f08c4457"

}

variable "key_path" {
  description = "SSH Public Key path"
  default = "public_key"
}

