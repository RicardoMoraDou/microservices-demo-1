variable "location" {
  description   = "The Azure Region in which all resources should be provisioned"
}

variable "rg_name" {
  description   = "Resource Group Name"
}

variable "name" {
  type          = string
  default       = "id_rsa"
}

variable "SSH_KEY" {
  type          = string
}