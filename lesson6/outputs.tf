output "webserver_instance_id" {
  value = aws_instance.webserver.id
}

output "webserver_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_sg_id" {
  value = aws_security_group.my_webserver.id
}
