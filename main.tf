
provider "aws" {
  region = "ap-southeast-2"
  profile = "${var.aws_profile}"
}

resource "aws_vpc" "zookeeper_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_hostnames = "true"
  tags  {
    Name = "zookeeper"
  }
}

# 172.31.0.0/20: ap-southeast-2b
# 172.31.16.0/20: ap-southeast-2c
# 172.31.32.0/20: ap-southeast-2a
resource "aws_subnet" "zookeeper_1" {
  vpc_id = "${aws_vpc.zookeeper_vpc.id}"
  cidr_block = "172.31.0.0/20"
}

resource "aws_security_group" "kafka_zookeeper" {
  name = "kafka-zookeeper"
  description = "Security group for Kafka and Zookeeper Instances"
  vpc_id = "${aws_vpc.zookeeper_vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "2181"
    to_port = "2181"
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port = "2888"
    to_port = "2888"
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port = "3888"
    to_port = "3888"
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port = "2181"
    to_port = "2181"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Zookeeper"
  }
}

resource "aws_instance" "zookeeper" {
  ami = "${var.ami}"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.kafka_zookeeper.id}"]
  subnet_id = "${aws_subnet.zookeeper_1.id}"
  associate_public_ip_address = "true"

  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
    delete_on_termination = "false"
  }

  key_name = "${var.key_name}"

  tags {
    Name = "Zookeeper Server 1"
  }
}
