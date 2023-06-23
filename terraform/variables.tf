variable "project" {
  description = "The project ID to host resources in"
  type        = string
}

variable "region" {
  description = "The region to host resources in"
  type        = string
}

variable "service_account_key" {
  description = "The path to the service account key file"
  type        = string
}

variable "image_tag" {
  description = "The tag for the docker image to deploy"
  type        = string
}
