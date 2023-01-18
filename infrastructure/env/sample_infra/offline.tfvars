#######################
# VM Spec             #
#######################

host-ip = "192.168.15.94"

vcpu      = 8
memory    = 16384
disk-size = 100

pool-name = "disk"
extra-disk-size = 2000000000 


net-cidr = "192.168.16.0/24"

vm-count = 3

host-public-map = {
    "offline-m1" = ["192.168.16.45"]
    "offline-m2" = ["192.168.16.46"]
    "offline-m3" = ["192.168.16.47"]
}

host-private-map = {
    "offline-m1" = ["172.12.16.45"]
    "offline-m2" = ["172.12.16.46"]
    "offline-m3" = ["172.12.16.47"]
}

img-file-name = "CentOS-7-x86_64-GenericCloud.qcow2"


