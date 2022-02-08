variable "region" {
  description = "AWS Region to deploy server"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = "pc"
}

variable "allow_ports" {
  description = "List of ports to open for server"
  type        = list(any)
  default     = ["80", "443"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = true
}

variable "common_tags" {
  description = "Common tags to all resources"
  type        = map(any)
  default = {
    Owner       = "Me"
    Project     = "Test"
    Environment = "Stage"
  }
}
