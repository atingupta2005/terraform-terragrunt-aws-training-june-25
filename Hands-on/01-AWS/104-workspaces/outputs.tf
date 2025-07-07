output "instance_id" {
  value = aws_instance.example.id
}

output "instance_type" {
  value = var.instance_type
}
