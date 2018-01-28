variable "aws_profile" {
  description = "AWS Profile name"
}

variable "ami" {
  description = "AWS AMI for Ubuntu 16.04 Server"
  default = "ami-37df2255"
}

variable "key_name" {
  description = "Key pair name"
  default = "kafka_zookeeper"
}
