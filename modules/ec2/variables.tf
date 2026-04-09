variable "project_name"  { type = string }
variable "environment"   { type = string }
variable "vpc_id"        { type = string }
variable "subnet_id"     { type = string }

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
