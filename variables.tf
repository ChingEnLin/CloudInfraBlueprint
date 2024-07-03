# define map of environment and service to create public IP

variable "ip_services" {
    description = "Map of environment and service to create public IP"
    type        = map(any)
    default     = {
        dev_backend = {
            target = "backend"
            environment = "dev"
        }
        dev_frontend = {
            target = "frontend"
            environment = "dev"
        }
        staging_backend = {
            target = "backend"
            environment = "staging"
        }
        staging_frontend = {
            target = "frontend"
            environment = "staging"
        }
    }
}