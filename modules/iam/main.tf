# ─── IAM Role for EC2 ────────────────────────────────────────────────────────
# Allows EC2 instances to assume this role
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Environment = var.environment
  }
}

# ─── S3 Access Policy (least privilege) ─────────────────────────────────────
resource "aws_iam_role_policy" "s3_access" {
  name = "${var.project_name}-s3-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      Resource = ["${var.bucket_arn}", "${var.bucket_arn}/*"]
    }]
  })
}

# ─── Instance Profile ─────────────────────────────────────────────────────────
# Attaches the IAM role to EC2 instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-profile"
  role = aws_iam_role.ec2_role.name
}
