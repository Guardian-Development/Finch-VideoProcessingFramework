# Amazon credentials
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}

# Application information used for build environment
variable "application_name" {
  default = "dissertation-streaming-service"
}

variable "client_service_application_name" {
  default = "client-service"
}
variable "client_service_application_version" {}

# Docker information
variable "docker_image_source" {
  default = "theguardian94"
}
variable "docker_client_service_image_name" {}

# AMIs for region
variable "amis-ecs" {
  type = "map"
  default = {
    "eu-west-1" = "ami-8fcc32f6"
  }
}