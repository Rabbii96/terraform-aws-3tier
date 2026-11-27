output "app_url" {
  value = "https://${module.compute.alb_dns_name}"
}

output "db_endpoint" {
  value = module.database.endpoint
}

output "db_secret_arn" {
  value = module.database.master_user_secret_arn
}
