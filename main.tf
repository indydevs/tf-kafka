provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_vpc" "zookeeper_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_hostnames = "true"

  tags  {
    Name = "zookeeper"
  }
}

resource "aws_internet_gateway" "zookeeper_vpc_igw" {
  vpc_id = "${aws_vpc.zookeeper_vpc.id}"

  tags {
    Name = "zookeeper_vpc"
  }
}

resource "aws_route_table" "zookeeper_vpc_route_table" {
  vpc_id = "${aws_vpc.zookeeper_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.zookeeper_vpc_igw.id}"
  }
}

resource "aws_route_table_association" "zookeeper_1_subnet_route_table" {
  subnet_id      = "${aws_subnet.zookeeper_1.id}"
  route_table_id = "${aws_route_table.zookeeper_vpc_route_table.id}"
}

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
    Name = "zookeeper"
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
    Name = "zk-server1"
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.zookeeper.id}"
  vpc = true
}
