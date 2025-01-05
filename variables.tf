variable "create_sg" {
  description = "Controls creation of security group"
  type        = bool
  default     = true
}

variable "sg_name" {
  description = "Security group name. Required if 'create_sg' is true"
  type        = string
  default     = null
}

variable "sg_description" {
  description = "Security group description. Required if 'create_sg' is true"
  type        = string
  default     = null
}

variable "sg_vpc" {
  description = "Define security group VPC. Required if 'create_sg' is true"
  type        = string
  default     = null
}

variable "sg_id" {
  description = "ID of existing security group"
  type        = string
  default     = ""
}

variable "sg_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
    sg_id       = optional(string)
    self        = optional(bool)
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
    self        = optional(bool)
  }))
  default = []
}

variable "tags" {
  description = "Security group tags"
  type        = object({})
  default     = {}
}