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

/*
resource "aws_iam_instance_profile" "minecraft_iam_instance_profile" {
  name = "minecraft_iam_instance_profile"
  role = aws_iam_role.minecraft_iam_role.name
}

resource "aws_iam_role" "minecraft_iam_role" {
  name = "minecraft_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "minecraft_policy_attachment" {
  role       = aws_iam_role.minecraft_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
*/

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