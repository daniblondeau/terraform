terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "test_terraform" {
  ami           = "ami-09558250a3419e7d0"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-test_daniel"
}