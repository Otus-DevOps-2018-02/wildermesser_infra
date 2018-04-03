variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable app_machine_type {
  description = "Machine type for app instance"
  default     = "f1-micro"
}

variable db_address {
  description = "Address of db server"
}
