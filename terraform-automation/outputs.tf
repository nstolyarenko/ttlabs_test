output "vm_external_ips" {
  description = "External IPs of the VMs"
  value = {
    for name, m in module.instances :
    name => m.external_ip
  }
}
