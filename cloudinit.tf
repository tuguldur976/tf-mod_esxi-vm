data "template_file" "cloudinit_metadata" {
  template = file("${path.module}/cloud-init/metadata.tpl")
  vars = {
    # HOSTNAME = var.guestHostname
    # STATIC_IP = var.vmStaticIp
    IP_ADDR = var.vmIpAddress
    NETMASK = var.vmNetmask
    GATEWAY = var.vmDefaultGW
    DNS1    = var.vmDNS1
    DNS2    = var.vmDNS2
    # USERNAME = var.vmUsername
    # SSH_KEY = var.vmSSHKey
  }
}

data "cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "hello-script.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/hello-script.sh")
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = file("${path.module}/scripts/cloud-config.yaml")
  }
}
