variable "project_name" {
  type = string
  default = "test"
  description = "This is a test project"
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type = string
  default = "default"
}

variable "dns_support" {
  type = bool
  default = true
}

variable "dns_hostnames" {
  type = bool
  default = true
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "test"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "postgressql_port" {
    type = number
    default = 5432
}

variable "cidr_list" {
  type = list
  default =  ["10.0.1.0/24", "10.0.2.0/24"]
}