variable "environment" {
    description = "A environment tag used for all resources"
}

variable "suffix" {
    description = "A suffix used for all resources"
}

variable "location" {
    description  = "The Azure Region in which all resources should be provisioned"
}

variable "rg_name" {  
    description = "Resource Group Name"
}

variable "dns_prefix" {
    type            = string
    default         = "hipsterdev"
}

variable "acr_id" {
    description     = "Azure Container Registry ID"
}