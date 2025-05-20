locals {
  prefix = random_string.prefix.result
  zones  = length(data.ibm_is_zones.regional.zones)
  vpc_zones = {
    for zone in range(local.zones) : zone => {
      zone = "${var.region}-${zone + 1}"
    }
  }

  first_zone_prefix = ibm_is_vpc.vpc.default_address_prefixes[element(sort(keys(ibm_is_vpc.vpc.default_address_prefixes)), 0)]

  # Kubernetes-specific CIDRs
  k8s_pod_cidr     = "172.16.0.0/16" # Your pod CIDR
  k8s_service_cidr = "10.96.0.0/12"  # Default K8s service CIDR
  tags = [
    "provider:ibm",
    "workspace:${terraform.workspace}",
    "owner:${var.owner}"
  ]
}