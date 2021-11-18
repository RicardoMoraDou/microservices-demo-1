variable "environment" {
  description   = "A environment tag used for all resources"
}

variable "suffix" {
  description   = "A suffix used for all resources"
}

variable "location" {
  description   = "The Azure Region in which all resources should be provisioned"
}

variable "rg_name" {  
  description   = "Resource Group Name"
}

variable "addr_space" {
  type          = string
  default       = "10.0.0.0/16"
}

variable "addr_prefixes_vault" {
  type          = string
  default       = "10.0.2.0/24"
}