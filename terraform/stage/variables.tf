variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access in provisioning"
}

variable disk_image {
  description = "Disk image"
}

variable instances_count {
  description = "Count of instances"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable app_machine_type {
  description = "Machine type for app instance"
  default     = "f1-micro"
}

variable db_machine_type {
  description = "Machine type for db instance"
  default     = "f1-micro"
}
