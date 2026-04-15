variable "project_name"        { type = string }
variable "environment"         { type = string }
variable "asg_name"            { type = string }
variable "db_instance_id"      { type = string }
variable "scale_up_policy_arn"   { type = string }
variable "scale_down_policy_arn" { type = string }

variable "alert_email" {
  description = "Email address to send CloudWatch alerts to"
  type        = string
}
