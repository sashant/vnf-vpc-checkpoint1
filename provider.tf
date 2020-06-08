##############################################################################
# Variable block - See each variable description
##############################################################################


variable "region" {
  default     = "us-south"
  description = "The VPC Region that you want your VPC, networks and the CP virtual server to be provisioned in. To list available regions, run `ibmcloud is regions`."
}

variable "generation" {
  default     = 2
  description = "The VPC Generation to target. Valid values are 2 or 1."
}

variable "resource_group" {
  default     = "default"
  description = "The resource group to use. If unspecified, the account's default resource group is used."
}


