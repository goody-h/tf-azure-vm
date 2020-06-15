output "public_ip_address" {
  value = "${azurerm_public_ip.test.ip_address}"
}