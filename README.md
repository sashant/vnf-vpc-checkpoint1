# Checkpoint Gateway Virtual Server for Virtual Private Cloud using Custom Image

Use this template to create CheckPoint Gateway(CP-gw) and CheckPoint Management (CP-mgmt)  virtual servers using custom images from your IBM Cloud account in IBM Cloud [VPC Gen2](https://cloud.ibm.com/vpc-ext/overview) by using Terraform or IBM Cloud Schematics.  Schematics uses Terraform as the infrastructure-as-code engine.  With this template, you can create and manage infrastructure as a single unit as follows. For more information about how to use this template, see the IBM Cloud [Schematics documentation](https://cloud.ibm.com/docs/schematics).

_The CP-gw virtual server instance only supports BYOL at this time._

## Prerequisites

- Must have access to [Gen 2 VPC](https://cloud.ibm.com/vpc-ext/network/vpcs).
- The given VPC must have at least two subnets with at least 2 unassigned IPs in a subnet and 1 unassigned IP in another subnet. CP-gw has 2 interfaces and is assigned to 2 IP addresses one from each subnet. Cp-mgmt is has 1 interface and is assigned 1 IP address belonging to 1 subnet.  

## Costs

When you apply template, the infrastructure resources that you create incur charges as follows. To clean up the resources, you can [delete your Schematics workspace or your instance](https://cloud.ibm.com/docs/schematics?topic=schematics-manage-lifecycle#destroy-resources). Removing the workspace or the instance cannot be undone. Make sure that you back up any data that you must keep before you start the deletion process.


* _VPC_: VPC charges are incurred for the infrastructure resources within the VPC, as well as network traffic for internet data transfer. For more information, see [Pricing for VPC](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc).
* _VPC Custom Image_: The template will copy over custom CP-gw and CP-mgmt images - this can be a one time operation.  CP-gw and CP-mgmt virtual instances can be created from the custom image.  VPC charges per custom image.
* _CP-gw and CP-mgmt Instances_: The price for your virtual server instances depends on the flavor of the instances, how many you provision, and how long the instances are run. For more information, see [Pricing for Virtual Servers for VPC](https://cloud.ibm.com/docs/infrastructure/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc#pricing-for-virtual-servers-for-vpc).

## Dependencies

Before you can apply the template in IBM Cloud, complete the following steps.


1.  Ensure that you have the following permissions in IBM Cloud Identity and Access Management:
    * `Manager` service access role for IBM Cloud Schematics
    * `Operator` platform role for VPC Infrastructure
2.  Ensure the following resources exist in your VPC Gen 2 environment
    - VPC
    - SSH Key
    - VPC has 2 subnets
    - _(Optional):_ 2 Floating IP Addresses to assign to the CP-mgmt and CP-gw instance post deployment

## Configuring your deployment values

When you select the [`CP-gw-offering`template](https://cloud.ibm.com/catalog/content/CP-gw-offering) from the IBM Cloud catalog, you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics  provisions the resources based on the values that were specified for the deployment variables.

### Required values
Fill in the following values, based on the steps that you completed before you began.

| Key | Definition |
| --- | ---------- |
| `zone` | The VPC Zone that you want your VPC virtual servers to be provisioned. To list available zones, run `ibmcloud is zones` |
| `resource_group` | The resource group to use. If unspecified, the account's default resource group is used. To list available resource groups, run `ibmcloud resource groups` |
| `vpc_name` | The name of your VPC in which CP-gw VSI is to be provisioned. |
| `ssh_key_name` | The name of your public SSH key to be used for CP-gw VSI. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh key. |
| `vnf_vpc_gw_image_name` | The name of the CP-gw Custom Image to be provisioned in your IBM Cloud account and (if already available) to be used to create the CP-gw virtual server instance. |
| `vnf_vpc_mgmt_image_name` | The name of the CP-mgmt Custom Image to be provisioned in your IBM Cloud account and (if already available) to be used to create the CP-gw virtual server instance. |
| `vnf_profile` | The profile of compute CPU and memory resources to be used when provisioning the vnf instance. To list available profiles, run `ibmcloud is instance-profiles`. |
| `vnf_gw_instance_name` | The name of the CP-gw VNF instance to be provisioned. |
| `vnf_mgmt_instance_name` | The name of the CP-mgmt VNF instance to be provisioned. |
| `subnet_id1` | The ID of the subnet where the CP-gw and CP-mgmt VNF instances will be deployed. Click on the subnet details in the VPC Subnet Listing to determine this value | 
| `subnet_id2` | The ID of the subnet where the second interface of CP-gw VNF instance will be deployed. Click on the subnet details in the VPC Subnet Listing to determine this value | 
| `ibmcloud_endpoint` | The IBM Cloud environment `cloud.ibm.com` or `test.cloud.ibm.com` |
| `vnf_cos_gw_image_url` | The COS image object SQL URL for CP-gw qcow2 image |
| `vnf_cos_mgmt_image_url` | The COS image object SQL URL for CP-mgmt qcow2 image |
| `vnf_security_group` | Security group for VNF VPC |
| `vnf_license` | Optional. The BYOL license key that you want your cp virtual server in a VPC to be used by registration flow during cloud-init. |
| `ibmcloud_endpoint` | The IBM Cloud environmental variable 'cloud.ibm.com' or 'test.cloud.ibm.com' |
| `delete_custom_image_confirmation` | This variable is to get the confirmation from customers that they will delete the custom image manually, post successful installation of VNF instances. Customer should enter 'Yes' to proceed further with the installation. |
| `ibmcloud_api_key` | Holds the user api key |


### Outputs
After you apply the template your VPC resources are successfully provisioned in IBM Cloud, you can review information such as the virtual server IP addresses and VPC identifiers in the Schematics log files, in the `Terraform SHOW and APPLY` section.

| Variable Name | Description | Sample Value |
| ------------- | ----------- | ------------ |
| `resource_name` | Name of the CP-gw instance | N/A |
| `resource_status` | Status of the CP-gw instance | `Running` or `Failed` |
| `VPC` | The VPC ID | `r134-7a9df886-xxxx-yyyy-zzzz-67c6dd202337` |
| `CP-gw_admin_portal` | Web url to interact with CP-gw admin portal - `https://<Floating IP>` | `https://192.168.1.1` |
| `CP-mgmt_admin_portal` | Web url to interact with CP-mgmt admin portal - `https://<Floating IP>` | `https://192.168.1.1` |

## Notes

If there is any failure during VSI creation, the created resources must be destroyed before attempting to instantiate again. To destroy resources go to `Schematics -> Workspaces -> [Your Workspace] -> Actions -> Delete` to delete  all associated resources. <br/>
1. The BYOI image download may take a while. Timeout has been set 30 Minutes.
2. Do not modify or delete subnets and floating/public IPs used by the CP-gw instance.

# Post Instances Spin-up

1. From the VSI list, confirm the CP-gw-VSI and CP-mgmt-VSI are powered ON with green button
2. Assign a Floating IP to the VSIs. Refer the steps below to associate floating IP
    - Go to `VPC Infrastructure Gen 2` from IBM Cloud
    - Click `Floating IPs` from the left pane
    - Click `Reserve floating IP` -> Click `Reserve IP`
    - There will be a (new) Floating IP address with status `Unassociated`
    - Click Three Dot Button corresponding to the Unassociated IP address -> Click `Associate`
    - Select CP-gw instance from `Instance to be associated` column.
    - After clicking `Associate`, you can see the IP address assigned to your CP-gw Instance.
3. From the browser, open `https://<Floating IP>`, login using user and password 
4. In First login, it will ask to reset the password.
5. Once the password got reset. You will be able to login to CP-gw instance admin portal.

