variable "name" {
    description = "Instance name"
    type = string
}

variable "region" {
    description = "Instance region. Contains AZ as well for GCP"
    type = string
}

variable "cloud" {
  description = "Cloud type"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "oci", "gcp"], lower(var.cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP, or OCI."
  }
}

variable "tags" {
  description = "Tags to apply on instance"
  type = map
  default = null
}

variable "admin_username" {
  description = "The username to log into the instance"
  type    = string
  default = "ubuntu"
}

variable "admin_password" {
  description = "The password to log into the instance if applicable"
  type    = string
  default = ""
}

variable "aws_key_name" {
    description = "SSH key name used to log into AWS instance"
    type = string
    default = ""
}

variable "azure_resource_group" {
  description = "Azure resource group"
  type = string
  default = ""
}

variable "size" {
  description = "Instance size"
  type = string
}

variable "subnet_id" {
  description = "The subnet where the instance will reside. It is the name of the subnet, not the ID for GCP"
  type = string
}

 variable "vpc_id" {
  description = "The ID of the subnet for the instance. In the case of GCP this is the name of the VPC."  
  type = string
  default = ""
 }

 variable "command" {
  description = "The command to run on the VM after it is deployed" 
  type = string
  default = ""
}