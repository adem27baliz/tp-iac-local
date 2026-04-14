# main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Configuration du provider Docker
provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# Ressource pour l'image PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = false
}

# Conteneur PostgreSQL
resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "tp-postgres-db"

  ports {
    internal = 5432
    external = var.postgres_port
  }

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.postgres_data.name
  }

  # Vérification de la santé du conteneur
  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.postgres_user} -d ${var.postgres_db}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  restart = "unless-stopped"
}

# Volume Docker pour la persistance des données PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

# Construction de l'image de l'application - CORRECTED VERSION
resource "docker_image" "app" {
  name = "tp-app:latest"
  keep_locally = true
}

# Conteneur de l'application web
resource "docker_container" "app" {
  image = docker_image.app.image_id
  name  = "tp-web-app"

  ports {
    internal = 80
    external = var.app_port
  }

  # Dépendance à la base de données
  depends_on = [docker_container.postgres]

  restart = "unless-stopped"
}