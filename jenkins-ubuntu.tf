provider "aws" {
    region = "us-east-1"

}
resource "aws_instance" "My_Ubuntu" {
    count = 1
    ami                    = "ami-09e67e426f25ce0d7"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.jenkins_rules.id]
    user_data                = file("jenkins_install.sh")
    key_name               = "my_key" # aws key


    tags = {
    Name = "Jenkins-Server"
    Owner = "MaxSa"
    Project = "Terraform Lessons"
           }

  lifecycle {
    prevent_destroy = True  # Prevent destroy instance
    ignore_changes = ["ami", "user_data"] # ignore changes in code in this fields.
    create_before_destroy = true # create first instance after what destroy instance
            }

    }

#module "key_pair" {
#  source = "terraform-aws-modules/key-pair/aws"
#
#  key_name   = "n-virginia2"
#  public_key = "public_key_here"
#}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.My_Ubuntu.id  # elastic ip(static ip)
}


resource "aws_security_group" "jenkins_rules" {
  name        = "jenkins"
  description = "Allow 8080 inbound traffic"

  ingress {
    description      = "8080 from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "80 from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "443 from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "22 from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  #my ISP range
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_http_8080"


  }

}
