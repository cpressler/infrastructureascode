# Configure the XenServer Provider
provider "xenserver" {
  url      = "http://192.168.102.182"
  username = "root"
  password = "Softvision1"
}

// Create a new virtual machine
resource "xenserver_vm" "testme" {
  base_template_name = "CentOS Template2"
  name_label = "test4"
  static_mem_min = 512000000
  static_mem_max = 512000000
  dynamic_mem_min = 512000000
  dynamic_mem_max = 512000000
#  static_mem_min = 2589934592
#  static_mem_max = 2589934592
#  dynamic_mem_min = 2589934592
#  dynamic_mem_max = 2589934592
  vcpus = 1
  boot_order = "c"

  hard_drive {
    is_from_template = true
    user_device = "0"
  } # Template VM HDD
  cdrom {
    is_from_template = true
    user_device = "3"
  }
// get network uuid from ssh into xenserver run xe pif-list
  network_interface {
    network_uuid = "ac17a5f9-1821-8d7a-5fe8-e45c50954321"
    device = 0
    mtu = 1500
    mac = ""
  }
}

// Create a new virtual machine
resource "xenserver_vm" "testme2" {
  base_template_name = "CentOS Template2"
  name_label = "test5"
  static_mem_min = 512000000
  static_mem_max = 512000000
  dynamic_mem_min = 512000000
  dynamic_mem_max = 512000000
#  static_mem_min = 2589934592
#  static_mem_max = 2589934592
#  dynamic_mem_min = 2589934592
#  dynamic_mem_max = 2589934592
  vcpus = 1
  boot_order = "c"

  hard_drive {
    is_from_template = true
    user_device = "0"
  } # Template VM HDD
  cdrom {
    is_from_template = true
    user_device = "3"
  }
// get network uuid from ssh into xenserver run xe pif-list
  network_interface {
    network_uuid = "ac17a5f9-1821-8d7a-5fe8-e45c50954321"
    device = 0
    mtu = 1500
    mac = ""
  }
}
