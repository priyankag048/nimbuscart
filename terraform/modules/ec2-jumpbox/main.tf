
resource "aws_security_group" "jumpbox_sg" {
  name        = "${var.project}-jumpbox-sg"
  description = "Allow SSH access to jumpbox"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami           = var.instance_image
  instance_type = var.instance_type
  subnet_id = var.public_subnet_id
  key_name = "${var.project}-key"
  vpc_security_group_ids  = [aws_security_group.jumpbox_sg.id]

  tags = { Name = "${var.project}-jumpbox"}
}