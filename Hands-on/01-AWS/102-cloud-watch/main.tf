provider "aws" {
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-03598bf9d15814511"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CloudWatchDemo"
  }

  monitoring = true  # Enables detailed monitoring (1-minute intervals)
}

# Create a CloudWatch Log Group (optional for custom logs)
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/ec2/cloudwatch-demo"
  retention_in_days = 7
}

# Create a CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors high CPU utilization"
  alarm_actions       = []  # No SNS action yet, just visible in the console

  dimensions = {
    InstanceId = aws_instance.example.id
  }

  tags = {
    Name = "CPUAlarm"
  }
}
