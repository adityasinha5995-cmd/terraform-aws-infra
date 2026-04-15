# ─── SNS Topic ────────────────────────────────────────────────────────────────
# SNS sends email notifications when alarms trigger
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ─── EC2 CPU Alarm ────────────────────────────────────────────────────────────
# Triggers when average CPU across ASG goes above 80% for 2 minutes
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EC2 CPU above 80% - scale up triggered"
  alarm_actions       = [aws_sns_topic.alerts.arn, var.scale_up_policy_arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = { Environment = var.environment }
}

# ─── EC2 CPU Low Alarm ────────────────────────────────────────────────────────
# Triggers when CPU drops below 20% — scale down to save cost
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "EC2 CPU below 20% - scale down triggered"
  alarm_actions       = [var.scale_down_policy_arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = { Environment = var.environment }
}

# ─── RDS CPU Alarm ────────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU above 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  tags = { Environment = var.environment }
}

# ─── RDS Storage Alarm ───────────────────────────────────────────────────────
# Triggers when free storage drops below 5GB
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 5000000000 # 5GB in bytes
  alarm_description   = "RDS free storage below 5GB"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  tags = { Environment = var.environment }
}

# ─── CloudWatch Dashboard ─────────────────────────────────────────────────────
# Single pane of glass to see all metrics
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          region = "us-east-1"

          title  = "EC2 CPU Utilization"
          period = 300
          stat   = "Average"

          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", "i-123456"]
          ]
        }
      },
      {
        type = "metric"
        properties = {
          region = "us-east-1"

          title  = "RDS CPU Utilization"
          period = 60
          stat   = "Average"

          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id]
          ]
        }
      },
      {
        type = "metric"
        properties = {
          region = "us-east-1"

          title  = "RDS Free Storage"
          period = 60
          stat   = "Average"

          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_instance_id]
          ]
        }
      }
    ]
  })
}