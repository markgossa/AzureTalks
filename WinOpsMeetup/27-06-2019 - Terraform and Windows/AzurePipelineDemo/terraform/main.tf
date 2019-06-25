# Create resource group
resource "azurerm_resource_group" "resourceGroup1" {
  name     = "${var.ResourceGroupName}"
  location = "${var.ResourceGroupLocation}"
}

# Create a virtual network
resource "azurerm_virtual_network" "virtualNetwork1" {
  name                = "${var.VnetName}"
  location            = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup1.name}"
  address_space       = "${var.VnetAddressSpace}"
}

# Create network security group
resource "azurerm_network_security_group" "networkSecurityGroup1" {
  name                = "${var.NsgName}"
  location            = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup1.name}"
}

# Create network security group rule to allow inbound RDP traffic from a specified IP
resource "azurerm_network_security_rule" "networkSecurityGroupRule1" {
  name                        = "AllowRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${var.NsgSourceAddressPrefix}" # Enter the public IP you're connecting to your VM from
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup1.name}"
  network_security_group_name = "${azurerm_network_security_group.networkSecurityGroup1.name}"
}

# Create a subnet
resource "azurerm_subnet" "lanSubnet" {
  name                        = "${var.SubnetName}"
  resource_group_name         = "${azurerm_resource_group.resourceGroup1.name}"
  virtual_network_name        = "${azurerm_virtual_network.virtualNetwork1.name}"
  address_prefix              = "${var.SubnetAddressPrefix}"
}

# Network security group association
resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = "${azurerm_subnet.lanSubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.networkSecurityGroup1.id}"
}

# Create a public IP
resource "azurerm_public_ip" "publicIp1" {
  name                         = "${var.PublicIpAddressName}"
  location                     = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name          = "${azurerm_resource_group.resourceGroup1.name}"
  allocation_method            = "Static"
}

# Create a virtual network interface
resource "azurerm_network_interface" "networkInterface1" {
  name                = "${var.NetworkInterfaceName}"
  location            = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup1.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.lanSubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicIp1.id}"
  }
}

# Create VM
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.VirtualMachineName}"
  location              = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name   = "${azurerm_resource_group.resourceGroup1.name}"
  network_interface_ids = ["${azurerm_network_interface.networkInterface1.id}"]
  vm_size               = "${var.VirtualMachineSize}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  storage_os_disk {
    name              = "${var.VirtualMachineOsDiskName}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.VirtualMachineName}"
    admin_username = "${var.Username}"
    admin_password = "${var.Password}"
  }
}
