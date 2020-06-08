##############################################################################
# Variable block - See each variable description
##############################################################################


##############################################################################
# vnf_cos_gw_image_url - Vendor provided Checkpoint Gateway image COS url.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_gw_image_url" {
  default     = ""
  description = "The COS image object SQL URL for Checkpoint GW qcow2 image."
}

##############################################################################
# vnf_cos_gw_image_url_test - Vendor provided Checkpoint Gateway image COS url in test.cloud.ibm.com.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_gw_image_url_test" {
  default     = ""
  description = "The COS image object url for Checkpoint GW qcow2 image in test.cloud.ibm.com."
}

##############################################################################
# vnf_cos_mgmt_image_url - Vendor provided Checkpoint Mgmt image COS url.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_mgmt_image_url" {
  default     = ""
  description = "The COS image object SQL URL for Checkpoint Mgmt qcow2 image."
}

##############################################################################
# vnf_cos_mgmt_image_url_test - Vendor provided Checkpoint Mgmt image COS url in test.cloud.ibm.com.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_mgmt_image_url_test" {
  default     = ""
  description = "The COS image object url for Checkpoint Mgmt qcow2 image in test.cloud.ibm.com."
}

##############################################################################
# zone - VPC zone where resources are to be provisioned.
##############################################################################
variable "zone" {
  default     = "us-south-1"
  description = "The VPC Zone that you want your VPC networks and virtual servers to be provisioned in. To list available zones, run `ibmcloud is zones`."
}

##############################################################################
# vpc_name - VPC where resources are to be provisioned.
##############################################################################
variable "vpc_name" {
  default     = ""
  description = "The name of your VPC where Checkpoint GW and Mgmt VSIs are to be provisioned."
}

##############################################################################
# subnet_name - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id1" {
  default     = ""
  description = "The id of the subnet where Checkpoint GW and Mgmt VSI to be provisioned."
}

##############################################################################
# subnet_name - Subnet for second interface of Checkpoint GW 
##############################################################################
variable "subnet_id2" {
  default     = ""
  description = "The id of the subnet where the second interface of Checkpoint GW to be provisioned."
}

##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining cp-GW VSI.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to be used when provisining Checkpoint GW and Mgmt VSIs."
}

##############################################################################
# vnf_vpc_gw_image_name - The name of the Checkpoint GateWay custom image to be provisioned in your IBM Cloud account.
##############################################################################
variable "vnf_vpc_gw_image_name" {
  default     = "checkpoint-gw-image"
  description = "The name of the Checkpoint GW custom image to be provisioned in your IBM Cloud account."
}

##############################################################################
# vnf_vpc_mgmt_image_name - The name of the Checkpoint Mgmt custom image to be provisioned in your IBM Cloud account.
##############################################################################
variable "vnf_vpc_mgmt_image_name" {
  default     = "checkpoint-mgmt-image"
  description = "The name of the Checkpoint Mgmt custom image to be provisioned in your IBM Cloud account."
}

##############################################################################
# vnf_gw_instance_name - The name of your Checkpoint GateWay Virtual Server to be provisioned
##############################################################################
variable "vnf_gw_instance_name" {
  default     = "cp-gw-vsi01"
  description = "The name of your Checkpoint GW Virtual Server to be provisioned."
}

##############################################################################
# vnf_mgmt_instance_name - The name of your Checkpoint Mgmt Virtual Server to be provisioned
##############################################################################
variable "vnf_mgmt_instance_name" {
  default     = "cp-mgmt-vsi01"
  description = "The name of your Checkpoint Mgmt Virtual Server to be provisioned."
}

##############################################################################
# vnf_profile - The profile of compute cpU and memory resources to be used when provisioning cp-GW VSI.
##############################################################################
variable "vnf_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute cpu and memory resources to be used when provisioning cp-GW VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "vnf_license" {
  default     = ""
  description = "Optional. The BYOL license key that you want your cp virtual server in a VPC to be used by registration flow during cloud-init."
}

variable "ibmcloud_endpoint" {
  default     = "cloud.ibm.com"
  description = "The IBM Cloud environmental variable 'cloud.ibm.com' or 'test.cloud.ibm.com'"
}

variable "delete_custom_image_confirmation" {
  default     = ""
  description = "This variable is to get the confirmation from customers that they will delete the custom image manually, post successful installation of VNF instances. Customer should enter 'Yes' to proceed further with the installation."
}
