resource "azurerm_public_ip" "test" {
  name                = "${var.application_type}-${var.resource_type}-pubip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.application_type}-${var.resource_type}-NIC"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_B1s"
  admin_username      = "vm-user"
  network_interface_ids = [ azurerm_network_interface.nic.id ]
  admin_ssh_key {
    username   = "vm-user"
    public_key = file(var.public_key_path)
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  custom_data = var.setup_script != null ? filebase64(var.setup_script) : base64encode("echo Setup script")
}
