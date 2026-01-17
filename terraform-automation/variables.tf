variable "project_id" {
  description = "tt-test-assignment-9b6t6y"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west2"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west2-a"
}

variable "ssh_port" {
  description = "Non-standard SSH port"
  type        = number
  default     = 2222
}

variable "ssh_cidr" {
  description = "Allowed CIDR blocks for SSH"
  type        = list(string)
  default     = ["95.111.15.207/32"]
}
