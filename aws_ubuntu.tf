#AWS cloud
#---------------------------------

#Create SG to allow SSH in
resource "aws_security_group" "allow_ssh" {
  count = var.cloud == "aws" ? 1 :0 
  name        = "${var.name}-allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH inbound"
    from_port   = 0 //any source port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP inbound"
    from_port   = 8 //any source port
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Create AWS Linux VM in spoke
#https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  count = var.cloud == "aws" ? 1 :0 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.name
  associate_public_ip_address = true

  #Ubuntu AMI
  ami           = "ami-042ad9eec03638628"
  instance_type = var.size
  key_name      = var.aws_key_name
  monitoring    = true

  #SG allowing SSH and ICMP in
  vpc_security_group_ids = [aws_security_group.allow_ssh[count.index].id]
  subnet_id              = var.subnet_id
}
