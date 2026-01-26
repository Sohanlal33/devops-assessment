resource "aws_instance" "Nexgen_assessment" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name


  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = file("${path.module}/scripts/install_docker.sh")

  tags = {
    Name = "assignment-ec2"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name        = "assignment-web-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "assignment-web-sg" }
}
resource "aws_eip" "app_eip" {
  instance = aws_instance.Nexgen_assessment.id
  domain   = "vpc"

  tags = {
    Name = "assignment-elastic-ip"
  }
}

