variable "name" {
  description = "Prefix for resource names"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR, e.g. 10.0.0.0/16"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR."
  }
}

variable "az_count" {
  description = "Number of availability zones (2 or 3)"
  type        = number
  default     = 2
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "Use 2 or 3 AZs for high availability."
  }
}

variable "single_nat_gateway" {
  description = "One shared NAT gateway (cheaper, for dev) instead of one per AZ (HA, for prod)"
  type        = bool
  default     = true
}
