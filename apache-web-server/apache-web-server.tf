provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type = number
    default = 80
}

output "public_ip" {
    value = aws_instance.web_server.public_ip
    description = "The public IP of the web server"
}
output "public_ip_dns" {
    value = aws_instance.web_server.public_dns
    description = "The public DNS of the web server"
}


resource "aws_instance" "web_server" {
    ami = "ami-09558250a3419e7d0"
    instance_type = "t2.micro"
    key_name = "ec2_web-server"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data = <<-EOF
            #!/bin/bash
            sudo yum install httpd -y
            echo "Academy Web Server" > /var/www/html/index.html
            sudo yum update -y
            sudo service httpd start
            EOF
    tags = {
        Name = "ec2_web-server_apache"
    }
}

resource "aws_security_group" "instance" {
    name = "sg_web-server"
    
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "sg_web-server_apache"
    }
}
