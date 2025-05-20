data "ibm_is_ssh_key" "sshkey" {
  name = var.existing_ssh_key
}

# Pull in the zones in the region
data "ibm_is_zones" "regional" {
  region = var.region
}

