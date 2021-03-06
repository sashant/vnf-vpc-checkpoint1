##############################################################################
# This file creates the compute instances for the solution.
# - Virtual Server using cp-gw custom image
# - Virtual Server using cp-mgmt custom image
##############################################################################

##############################################################################
# Read/validate sshkey
##############################################################################
data "ibm_is_ssh_key" "cp_ssh_pub_key" {
  name = "${var.ssh_key_name}"
}

##############################################################################
# Read/validate vsi profile
##############################################################################
data "ibm_is_instance_profile" "vnf_profile" {
  name = "${var.vnf_profile}"
}

data "ibm_is_vpc" "cp_vpc" {
  name = "${var.vpc_name}"
}

resource "ibm_is_security_group" "ckp_security_group" {
    name = "${var.vnf_security_group}"
    vpc = "${data.ibm_is_vpc.cp_vpc.id}"
    resource_group = "${data.ibm_resource_group.rg.id}"
}

//security group rule to allow ssh
resource "ibm_is_security_group_rule" "test_ckp_sg_allow_ssh" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group     = "${ibm_is_security_group.ckp_security_group.id}"
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

//security group rule to allow all for inbound
resource "ibm_is_security_group_rule" "test_ckp_sg_rule_all" {
  depends_on = ["ibm_is_security_group_rule.test_ckp_sg_allow_ssh"]
  group     = "${ibm_is_security_group.ckp_security_group.id}"
  direction = "inbound"
  remote    = "0.0.0.0/0"
}
##############################################################################
# Create CHECKPOINT firewall virtual server.
##############################################################################
resource "ibm_is_instance" "cp_gw_vsi" {
  depends_on = ["ibm_is_security_group_rule.test_ckp_sg_rule_all", "ibm_is_image.cp_gw_custom_image"]
  name    = "${var.vnf_gw_instance_name}"
  image   = "${ibm_is_image.cp_gw_custom_image.id}"
  profile = "${data.ibm_is_instance_profile.vnf_profile.name}"
  resource_group = "${data.ibm_resource_group.rg.id}"

  primary_network_interface {
    subnet = "${data.ibm_is_subnet.cp_subnet1.id}"
    security_groups = ["${ibm_is_security_group.ckp_security_group.id}"]
  }

  network_interfaces {
    name   = "eth1"
    subnet = "${data.ibm_is_subnet.cp_subnet2.id}"
    security_groups = ["${ibm_is_security_group.ckp_security_group.id}"]
  }

  vpc  = "${data.ibm_is_vpc.cp_vpc.id}"
  zone = "${data.ibm_is_zone.zone.name}"
  keys = ["${data.ibm_is_ssh_key.cp_ssh_pub_key.id}"]

  # user_data = "$(replace(file("cp-userdata.sh"), "cp-LICENSE-REPLACEMENT", var.vnf_license)"

  //User can configure timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }
  # Hack to handle some race condition; will remove it once have root caused the issues.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

##############################################################################
# Create CHECKPOINT Management virtual server.
##############################################################################
resource "ibm_is_instance" "cp_mgmt_vsi" {
  depends_on = ["ibm_is_security_group_rule.test_ckp_sg_rule_all", "ibm_is_image.cp_mgmt_custom_image"]
  name    = "${var.vnf_mgmt_instance_name}"
  image   = "${ibm_is_image.cp_mgmt_custom_image.id}"
  profile = "${data.ibm_is_instance_profile.vnf_profile.name}"
  resource_group = "${data.ibm_resource_group.rg.id}"

  primary_network_interface {
    subnet = "${data.ibm_is_subnet.cp_subnet1.id}"
    security_groups = ["${ibm_is_security_group.ckp_security_group.id}"]
  }
  
  vpc  = "${data.ibm_is_vpc.cp_vpc.id}"
  zone = "${data.ibm_is_zone.zone.name}"
  keys = ["${data.ibm_is_ssh_key.cp_ssh_pub_key.id}"]

  # user_data = "$(replace(file("cp-userdata.sh"), "cp-LICENSE-REPLACEMENT", var.vnf_license)"

  //User can configure timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }
  # Hack to handle some race condition; will remove it once have root caused the issues.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# Delete checkpoint firewall custom image from the local user after VSI creation.
data "external" "delete_custom_image1" {
  depends_on = ["ibm_is_instance.cp_gw_vsi"]
  program    = ["bash", "${path.module}/scripts/delete_custom_image.sh"]

  query = {
    custom_image_id   = "${ibm_is_image.cp_gw_custom_image.id}"
    region            = "${var.region}"
  }
}


output "delete_custom_image1" {
  value = "${lookup(data.external.delete_custom_image1.result, "custom_image_id")}"
}

# Delete checkpoint management custom image from the local user after VSI creation.
data "external" "delete_custom_image2" {
  depends_on = ["ibm_is_instance.cp_mgmt_vsi"]
  program    = ["bash", "${path.module}/scripts/delete_custom_image.sh"]

  query = {
    custom_image_id   = "${ibm_is_image.cp_mgmt_custom_image.id}"
    region            = "${var.region}"
  }
}

output "delete_custom_image2" {
  value = "${lookup(data.external.delete_custom_image2.result, "custom_image_id")}"
}
