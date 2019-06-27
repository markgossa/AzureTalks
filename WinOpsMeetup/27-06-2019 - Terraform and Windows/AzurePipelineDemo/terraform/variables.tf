variable "ResourceGroupName" {}
variable "ResourceGroupLocation" {}
variable "VnetName" {}
variable "VnetAddressSpace" {
    type = "list"
}
variable "NsgName" {}
variable "SubnetName" {}
variable "SubnetAddressPrefix" {}
variable "PublicIpAddressName" {}
variable "NetworkInterfaceName" {}
variable "VirtualMachineName" {}
variable "VirtualMachineSize" {}
variable "VirtualMachineOsDiskName" {}




# Secrets
variable "Username" {}
variable "Password" {}
variable "NsgSourceAddressPrefix" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}