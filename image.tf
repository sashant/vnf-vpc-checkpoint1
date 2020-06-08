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

# Generating random ID
resource "random_uuid" "test" {}

resource "ibm_is_image" "cp_gw_custom_image" {
  depends_on       = ["random_uuid.test"]
  href             = "${local.image_url_gw}"
  name             = "${var.vnf_vpc_gw_image_name}-${random_uuid.test.result}"
  operating_system = "centos-7-amd64"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "ibm_is_image" "cp_gw_custom_image" {
  name       = "${var.vnf_vpc_gw_image_name}-${random_uuid.test.result}"
  depends_on = ["ibm_is_image.cp_gw_custom_image"]
}

resource "ibm_is_image" "cp_mgmt_custom_image" {
  depends_on       = ["random_uuid.test"]
  href             = "${local.image_url_mgmt}"
  name             = "${var.vnf_vpc_mgmt_image_name}-${random_uuid.test.result}"
  operating_system = "centos-7-amd64"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "ibm_is_image" "cp_mgmt_custom_image" {
  name       = "${var.vnf_vpc_mgmt_image_name}-${random_uuid.test.result}"
  depends_on = ["ibm_is_image.cp_mgmt_custom_image"]
}
