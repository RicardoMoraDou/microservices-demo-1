variable "prefix" {
    type    = string
}

variable "rg_name" {
    type    = string
}

variable "location" {
    type    = string
}

variable "dns_prefix" {
    type    = string
    default = "hipsterdev"
}

variable "acr_id" {
    type    = string
}