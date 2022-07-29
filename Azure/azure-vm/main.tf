resource "azurerm_resource_group" "terraform-rg" {
  name     = "az-resource-tf"
  location = "East US 2"
}
resource "azurerm_virtual_network" "terraform-vnet" {
  name                = "terraform-network"
  resource_group_name = azurerm_resource_group.terraform-rg.name
  location            = azurerm_resource_group.terraform-rg.location
  address_space       = ["10.125.25.0/24"]
}
resource "azurerm_availability_set" "terraform-as" {
  name                = "terraform-aset"
  location            = azurerm_resource_group.terraform-rg.location
  resource_group_name = azurerm_resource_group.terraform-rg.name

  tags = {
    environment = "Terraform"
  }
}
resource "azurerm_subnet" "terraform-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform-rg.name
  virtual_network_name = azurerm_virtual_network.terraform-vnet.name
  address_prefixes     = ["10.125.25.0/24"]
}
resource "azurerm_network_interface" "terraform-net-1" {
  name                = "terraform-nic-1"
  location            = azurerm_resource_group.terraform-rg.location
  resource_group_name = azurerm_resource_group.terraform-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip=="Yes"? azurerm_public_ip.terraform-pub.id: ""
  }
}
resource "azurerm_public_ip" "terraform-pub" {
  name                    = "terraform-pip"
  location                = azurerm_resource_group.terraform-rg.location
  resource_group_name     = azurerm_resource_group.terraform-rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  tags = {
    environment = "terraform-public"
  }
}
 resource "azurerm_linux_virtual_machine" "terraform-vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.terraform-rg.name
  location            = azurerm_resource_group.terraform-rg.location
  size                = local.instance_size
  admin_username      = "ksourangshu"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.terraform-net-1.id,
  ]
  os_disk {
    name                 = "${var.vm_name}-boot-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  admin_ssh_key {
    username = "ksourangshu"
    public_key = file("./sshkey/azure-pub.key")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
