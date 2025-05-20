resource "ibm_is_vpc" "vpc" {
  name                        = "${local.prefix}-vpc"
  resource_group              = module.resource_group.resource_group_id
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${local.prefix}-default-nacl"
  default_security_group_name = "${local.prefix}-default-sg"
  default_routing_table_name  = "${local.prefix}-default-rt"
  tags                        = local.tags
}

resource "ibm_is_public_gateway" "gateway" {
  name           = "${local.prefix}-${local.vpc_zones[0].zone}-pgw"
  resource_group = module.resource_group.resource_group_id
  vpc            = ibm_is_vpc.vpc.id
  zone           = local.vpc_zones[0].zone
  tags           = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

resource "ibm_is_subnet" "dmz" {
  name                     = "${local.prefix}-dmz-subnet"
  resource_group           = module.resource_group.resource_group_id
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.vpc_zones[0].zone
  total_ipv4_address_count = "16"
  public_gateway           = ibm_is_public_gateway.gateway.id
  tags                     = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

resource "ibm_is_subnet" "controller" {
  name                     = "${local.prefix}-controller-subnet"
  resource_group           = module.resource_group.resource_group_id
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.vpc_zones[0].zone
  total_ipv4_address_count = "64"
  public_gateway           = ibm_is_public_gateway.gateway.id
  tags                     = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

resource "ibm_is_subnet" "worker" {
  name                     = "${local.prefix}-worker-subnet"
  resource_group           = module.resource_group.resource_group_id
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.vpc_zones[0].zone
  total_ipv4_address_count = "64"
  public_gateway           = ibm_is_public_gateway.gateway.id
  tags                     = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}