variable "aws_profile" {
  description = "AWS Profile name"
}

variable "aws_region" {
  description = "Region name where the instances should be deployed"
  default = "ap-southeast-2"
}

variable "ami" {
  description = "AWS AMI for Ubuntu 16.04 Server"
  default = "ami-33ab5251"
}

variable "key_name" {
  description = "Key pair name"
  default = "kafka_zookeeper"
}
