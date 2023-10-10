locals {
  hostname = "${var.vm_name_base}-${var.vm_name_postfix}"
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

  # guestinfo = {
  #   # "userdata.encoding" = "gzip+base64"
  #   "userdata" = data.cloudinit_config.cloudinit.rendered
  # }
  #########################################
  #  ESXI Guestinfo metadata
  #########################################
  guestinfo = {
    "metadata"          = base64gzip(file("metadata.yaml"))
    "metadata.encoding" = "gzip+base64"
  }
}
