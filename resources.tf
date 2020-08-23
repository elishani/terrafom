resource "aws_key_pair" "default" {
  key_name = "newkey"
  public_key = ""
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
