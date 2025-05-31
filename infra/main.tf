resource "aws_key_pair" "deployer" {
  key_name   = "finbot-key"
  public_key = file(var.ec2_public_key)
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "finbot_sg" {
  name        = "finbot-sg"
  description = "Allow inbound HTTP for Streamlit app"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "finbot_ec2" {
  ami                    = "ami-0e35ddab05955cf57" # Ubuntu 20.04 (update if needed)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.main_subnet.id
  security_groups        = [aws_security_group.finbot_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install python3-pip -y
              mkdir -p /home/ubuntu/app
              cd /home/ubuntu/app
              git clone https://github.com/Sayan-sam/finbot.git .
              git checkout feature/basicPlatform
              nohup streamlit run app.py --server.port 8501 --server.enableCORS false > streamlit.log 2>&1 &
              EOF

  tags = {
    Name = "StreamlitApp"
  }
}
