variable "subdomain" {
  # if left empty, this will be a random UUID
  type        = string
  description = "The subdomain you want (leave empty for a random one)"
  default     = ""
}

variable "domain" {
  type        = string
  description = "The domain/zone name for Cloudflare"
}

variable "folder" {
  type        = string
  description = "The folder you want to upload"
}
