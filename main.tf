locals {
  hostname = "${var.vm_name_base}-${var.vm_name_postfix}"

  meta_data = templatefile("${path.module}/cloud-init/metadata.tpl", {
    IP_ADDR = var.vmIpAddress,
    NETMASK = var.vmNetmask,
    GATEWAY = var.vmDefaultGW,
    DNS1    = var.vmDNS1,
    DNS2    = var.vmDNS2
  })
  # USERNAME = var.vmUsername,
  # SSH_KEY = var.vmSSHKey,
  # HOSTNAME = var.guestHostname,
  # STATIC_IP = var.vmStaticIp,
}

resource "esxi_guest" "vm" {
  guest_name = local.hostname
  guestos    = var.vm_os_type
  memsize    = var.vm_spec_memory
  numvcpus   = var.vm_spec_cpu_cores
  ovf_source = var.vm_image_template_file
  power      = var.vm_poweron
  disk_store = var.esxi_datastore_name
  notes      = var.vm_notes

  network_interfaces {
    virtual_network = var.esxi_network_name
  }

  #########################################
  #  ESXI Guestinfo metadata
  #########################################
  guestinfo = {
    # "userdata.encoding" = "gzip+base64"
    "userdata" = data.cloudinit_config.cloudinit.rendered
    # "metadata.encoding" = "gzip+base64"
    # "metadata"          = base64gzip(data.template_file.cloudinit_metadata.rendered)
    "metadata" = jsonencode(local.meta_data)
  }
}
