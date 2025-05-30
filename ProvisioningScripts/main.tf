terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "minecraft_security_group" {
  name = "Project2MinecraftSecurityGroup"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "minecraft_elastic_ip" {
  instance = aws_instance.minecraft_server.id
}

resource "aws_instance" "minecraft_server" {
  ami                    = "ami-00565a15a71e4402a"
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.minecraft_security_group.id]
  iam_instance_profile   = "LabInstanceProfile"

  tags = {
    Name = "Project2MinecraftServer"
  }
}

output "minecraft_ec2_id" {
  value = aws_instance.minecraft_server.id
}

output "minecraft_public_ip" {
  value = aws_eip.minecraft_elastic_ip.public_ip
}