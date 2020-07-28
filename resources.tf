resource "aws_key_pair" "default" {
  key_name = "newkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDItlI6fXeZPPrEIhPn0Ays4uOiGE0Qip7UJanf6oCE6ORuJC++XO2hhNsOVro9S2ZcJ7vRVaIcPDXzf2ISBdXIq1TdCGn3A/W3Mksaa32j87iIAXql5b7AUwr0+npEvw+ycEFR7mmKVDrTQo/p5yyeWhhyv4i+Qq9kvzYizxUWreKWwoq1ayYh82Ko0dj/ckSIIcULezIMJZz/qylraqzJixLaBr/ru4CxkAxOBMsxt3E4Opnh9C5Dq2sJmGWfDjhoek/5OtSzG0ZPgaIZqGABT0qooWURqkw/4WwQOdbP8PUvPXWUC5rgNBHpYRRGi5mDvcbT2sfX9ApPh3FLGobR"
}


# Define webserver inside the public subnet
resource "aws_instance" "nginx" {
   ami  = var.ami
   instance_type = "t2.micro"
   key_name = aws_key_pair.default.id
   subnet_id = aws_subnet.public-subnet.id
   vpc_security_group_ids = ["${aws_security_group.sgNginx.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = file("install_nginx.sh")
   
  tags = {
    Name = "NginxRP"
  }
}

# Define Web server inside the private subnet
resource "aws_instance" "apache" {
   ami  = var.ami
   instance_type = "t2.micro"
   key_name = aws_key_pair.default.id
   subnet_id = aws_subnet.private-subnet.id
   vpc_security_group_ids = ["${aws_security_group.sgWeb.id}"]
   source_dest_check = false
   user_data = file("install_apache.sh")
   
  tags = {
    Name = "Websever"
  }
}