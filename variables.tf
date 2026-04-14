# variables.tf
variable "postgres_user" {
  description = "Nom d'utilisateur PostgreSQL"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "postgres_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  default     = "dom"
  sensitive   = true
}

variable "postgres_db" {
  description = "Nom de la base de données"
  type        = string
  default     = "appdb"
}

variable "app_port" {
  description = "Port externe pour l'application web"
  type        = number
  default     = 8080
}

variable "postgres_port" {
  description = "Port externe pour PostgreSQL"
  type        = number
  default     = 5432
}