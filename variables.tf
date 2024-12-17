variable "create_sg" {
  description = "Controls creation of security group"
  type        = bool
  default     = true
}

variable "sg_name" {
  description = "Security group name"
  type        = string
}

variable "sg_description" {
  description = "Security group description"
  type        = string
}

variable "sg_vpc" {
  description = "Define security group VPC"
  type        = string
}

variable "sg_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
    sg_id       = optional(string)
  }))
  default = []
}

variable "sg_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
    sg_id       = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Security group tags"
  type        = object({})
  default     = {}
}