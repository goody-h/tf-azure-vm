# Resource Group/Location
variable "location" {}

variable "application_type" {
    default = "demo"
}
variable "resource_type" {
    default = "VM"
}
variable "resource_group" {}

variable "subnet_id" {}
variable "public_key_path" {}
variable "setup_script" {}
