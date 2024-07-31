provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.vpc1.id

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

resource "aws_instance" "helloworldec2" {
  ami           = "ami-0aff18ec83b712f05"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg1.id}"]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y

              sudo apt-get install ca-certificates curl git apt-transport-https software-properties-common -y

              sudo install -m 0755 -d /etc/apt/keyrings

              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Add the repository to Apt sources:
              echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

              sudo apt-get update -y

              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

              sudo curl -L "https://github.com/docker/compose/releases/download/v2.14.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

              sudo chmod +x /usr/local/bin/docker-compose

              sudo usermod -aG docker ubuntu
              EOF                     

  tags = {
    Name = "Helloworld"
  }
}

