variable "prefix" {
  type      = string
}

variable "rg_name" {
  type      = string
}

variable "location" {
  type      = string
}

variable "addr_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "addr_prefixes" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ip_name" {
  type    = string
  default = "ip_hipster"
}