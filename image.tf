##############################################################################
# This file creates custom images using cp-gw and cp-mgmt qcow2 images hosted in vnfsvc COS
#  - Creates Custom Images in User account
#
# Note: There are following gaps in ibm is provider and thus using Terraform tricks
# to overcome the gaps for the PoC sake.
##############################################################################

locals {
  image_url_gw    = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.vnf_cos_gw_image_url : var.vnf_cos_gw_image_url_test}"
  image_url_mgmt    = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.vnf_cos_mgmt_image_url : var.vnf_cos_mgmt_image_url_test}"
}



resource "ibm_is_image" "cp_gw_custom_image" {
  href             = "${local.image_url_gw}"
  name             = "${var.vnf_vpc_gw_image_name}"
  operating_system = "centos-7-amd64"
  resource_group   = "${data.ibm_resource_group.rg.id}"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "ibm_is_image" "cp_gw_custom_image" {
  name       = "${ibm_is_image.cp_gw_custom_image.name}"
}

resource "ibm_is_image" "cp_mgmt_custom_image" {
  href             = "${local.image_url_mgmt}"
  name             = "${var.vnf_vpc_mgmt_image_name}"
  operating_system = "centos-7-amd64"
  resource_group   = "${data.ibm_resource_group.rg.id}"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "ibm_is_image" "cp_mgmt_custom_image" {
  name       = "${ibm_is_image.cp_mgmt_custom_image.name}"
}
