terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

terraform {
  backend "etcdv3" {
    endpoints = ["localhost:2379"]
    lock      = true
    prefix    = "terraform-state/"
  }
}

provider "libvirt" {
    uri = "qemu+ssh://root@${var.host-ip}/system"
}

#vm-count value check
resource "null_resource" "condition_checker" {
  count = "${var.vm-count > length(var.host-public-map) ? 0 : 1}"
  #require : error message" 
}


data "template_file" "cloud_init_config" {
  template = file("./cloudinit/cloud_init.cfg")
  vars = {
    HOST_NAME = "${keys(var.host-public-map)[count.index]}"
  }
  count = var.vm-count
}

data "template_file" "network_config" {
  template = file("./cloudinit/network.cfg")
  vars = {
    IP_ADDRESS = "${values(var.host-public-map)[count.index][0]}"
    PRIVATE_IP = "${values(var.host-private-map)[count.index][0]}"
  }
  count = var.vm-count
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${keys(var.host-public-map)[count.index]}_${count.index}.iso"
  user_data      = data.template_file.cloud_init_config[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
  count = var.vm-count
}

# Defining VM Volume
resource "libvirt_volume" "primary-qcow2" {
  name = "${keys(var.host-public-map)[count.index]}.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "${var.qcow-path}/${var.img-file-name}"
  format = "qcow2"

  count = var.vm-count
}

resource "libvirt_volume" "extra-qcow2" {
  name   = "${keys(var.host-public-map)[count.index]}_extra.qcow2"
  pool   = var.pool-name
  format = "qcow2"
  size   = var.extra-disk-size

  count = var.vm-count
}

resource "null_resource" "disk-resize" {

  provisioner "local-exec" {
    command = "qemu-img resize --shrink ${var.qcow-path}/${var.img-file-name} ${var.disk-size}G"
  }
}

# Define KVM domain to create
resource "libvirt_domain" "vm" {
  name  = "${keys(var.host-public-map)[count.index]}"
  memory = var.memory
  vcpu   = var.vcpu

  cpu {
    mode = "host-model"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    addresses = ["${var.net-cidr}"]
    bridge = "br0"
  }

  network_interface {
    network_name = "private-net-1"
  }


  disk {
    volume_id = "${libvirt_volume.primary-qcow2[count.index].id}"
  }

  disk {
    volume_id = "${libvirt_volume.extra-qcow2[count.index].id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
 
  count = var.vm-count
  depends_on = [ null_resource.disk-resize ] 
}


