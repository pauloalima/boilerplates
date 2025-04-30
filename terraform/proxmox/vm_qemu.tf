resource "proxmox_vm_qemu" "your-vm" {

  # SECTION General Settings

  name = "tf-test-1"
  desc = "VM creation with Terraform"
  agent = 1  # <-- (Optional) Enable QEMU Guest Agent

  # FIXME Before deployment, set the correct target node name
  target_node = "pve1"

  # FIXME Before deployment, set the desired VM ID (must be unique on the target node)
  #vmid = ""

  # !SECTION
  
  # SECTION Template Settings

  # FIXME Before deployment, set the correct template or VM name in the clone field
  #       or set full_clone to false, and remote "clone" to manage existing (imported) VMs
  clone = "temp-ubuntu-24-04"
  full_clone = true

  # !SECTION

  # SECTION Boot Process

  onboot = true 

  # NOTE Change startup, shutdown and auto reboot behavior
  startup = ""
  automatic_reboot = false

  # !SECTION

  # SECTION Hardware Settings

  qemu_os = "other"
  bios = "seabios"
  cores = 2
  sockets = 1
  cpu_type = "host"
  memory = 2048

  # NOTE Minimum memory of the balloon device, set to 0 to disable ballooning
  balloon = 0
  
  # !SECTION

  # SECTION Network Settings

  network {
    id     = 0  # NOTE Required since 3.x.x
    bridge = "vmlan100"
    model  = "virtio"
  }

  # !SECTION

  # SECTION Disk Settings
  
  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"
  
  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "VM_Data"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "VM_Data"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "24G"

          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread = true
          replicate = false
        }
      }
    }
  }

  # !SECTION

  # SECTION Cloud Init Settings

  # FIXME Before deployment, adjust according to your network configuration
  ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
  nameserver = "0.0.0.0"
  ciuser = "plima"
  sshkeys = var.PUBLIC_SSH_KEY

  # !SECTION
}
