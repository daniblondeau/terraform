provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type = number
    default = 8080
}
output "public_ip" {
    value = aws_instance.test_terraform.public_ip
    description = "The public IP of the web server"
}


resource "aws_instance" "test_terraform" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!bin/bash
                echo "Hello there" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

    tags = {
        Name = "terraform_single-server-daniel"
    }
}

resource "aws_security_group" "instance" {
    name = "sg_single-server"
    
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

