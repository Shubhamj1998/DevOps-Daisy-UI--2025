# AWS key-pair (login)
resource "aws_key_pair" "mykey" {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  }

# VPC and Security Groups

resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
  
}

resource "aws_security_group" "allow_tls" {
    name = "automate-sg"
    description = "This security gruop generated by Terraform"
    vpc_id = aws_default_vpc.default.id
  

# Inbound Rules
 ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
}  

ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
}  

ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Open"
}  

# Outbound Rules 
 egress {
   from_port = 0
   to_port   = 0
   protocol  = "-1"
   description = "all access open for Outbound traffic"

 }
    tags = {

    Name = "automate-sg"
 }

}


# EC2 instance

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.mykey.key_name
    security_groups = [aws_security_group.allow_tls.name]
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id
    depends_on = [aws_security_group.allow_tls, aws_key_pair.mykey]

    root_block_device {
       volume_size = var.env == "prd" ? 30 : var.root_storage_size
       volume_type = "gp3"
     }
     tags = {
        Name = "terraform-automate-ec2"
     }
}
