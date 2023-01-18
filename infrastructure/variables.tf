#######################
# env                 #
#######################
variable "host-ip" {
  type = string
}

variable "qcow-path" {
  type = string
  default = "./qcow"
}

variable "pool-name" {
  type = string
  description = "Disk name in virsh-pool list"
}

########################
# variables            #
########################
variable "vcpu" {
  type = number
}

variable "memory" {
  type = number
  description = "MB" 
}

variable "disk-size" {
  type = number
  description = "Primary Disk(GB)" 
}

variable "extra-disk-size" {
  type = number
  default = 0
  description = "Extra Disk(Byte)"
}

variable "vm-count" {
  type = number
  default = 0
  description = "Number of VM intances. 'vm-count' cannot be greater than 'length(host-public-map)'"
}

#Public IP List
variable "host-public-map" {
  type = map(list(string))
  description = "VM Name = public ip"
}

#Private IP List
variable "host-private-map" {
  type = map(list(string))
  description = "VM Name = private ip"
}


variable "net-cidr" {
  type = string 
}

variable "img-file-name" {
  type = string
}

