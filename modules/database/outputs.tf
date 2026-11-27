output "endpoint" {
  value = aws_db_instance.this.address
}

output "master_user_secret_arn" {
  description = "Secrets Manager secret that holds the generated password"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
