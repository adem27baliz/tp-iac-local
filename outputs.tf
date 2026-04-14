# outputs.tf - Minimal working version
output "postgres_container_id" {
  description = "ID du conteneur PostgreSQL"
  value       = docker_container.postgres.id
}

output "app_container_id" {
  description = "ID du conteneur de l'application"
  value       = docker_container.app.id
}

output "app_url" {
  description = "URL d'accès à l'application web"
  value       = "http://localhost:${var.app_port}"
}

output "postgres_connection_string" {
  description = "Chaîne de connexion PostgreSQL"
  value       = "postgresql://${var.postgres_user}:${var.postgres_password}@localhost:${var.postgres_port}/${var.postgres_db}"
  sensitive   = true
}

output "deployment_summary" {
  description = "Résumé du déploiement"
  value = {
    message = "Déploiement réussi!"
    app_url = "http://localhost:${var.app_port}"
    db_port = var.postgres_port
    check_containers = "docker ps"
  }
}