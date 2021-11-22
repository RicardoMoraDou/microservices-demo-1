variable "environment" {
    description     = "A suffix used for all resources"
    type            = string
    default         = "dev"
}

variable "suffix" {
    description     = "A suffix used for all resources"
    type            = string
    default         = "hipster"
}

variable "location" {
    description     = "The Azure Region in which all resources should be provisioned"
    type            = string
    default         = "eastus"
}

variable "SSH_KEY" {
    type            = string
}