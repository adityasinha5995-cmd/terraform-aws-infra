# ─── Security Group ──────────────────────────────────────────────────────────
resource "aws_security_group" "instance" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-sg"
    Environment = var.environment
  }
}

# ─── EC2 Instance ─────────────────────────────────────────────────────────────
resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-instance"
    Environment = var.environment
  }
}
