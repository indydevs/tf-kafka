output "public_ip" {
  value = "${aws_instance.zookeeper_1.public_ip}"
}

output "image_id" {
  value = "${data.aws_ami.ubuntu.id}"
}
