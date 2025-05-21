# Generate a random string for the prefix
resource "random_string" "prefix" {
  length  = 4
  special = false
  upper   = false
  numeric = false
}

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.2.0"
  existing_resource_group_name = var.existing_resource_group
}

module "bastion" {
  source            = "./modules/compute"
  prefix            = "${local.prefix}-bastion"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = ibm_is_vpc.vpc.id
  subnet_id         = ibm_is_subnet.dmz.id
  security_group_id = module.dmz_security_group.security_group_id
  zone              = local.vpc_zones[0].zone
  ssh_key_ids       = [data.ibm_is_ssh_key.sshkey.id]
  tags              = local.tags
}

resource "ibm_is_floating_ip" "bastion" {
  name           = "${local.prefix}-${local.vpc_zones[0].zone}-bastion-ip"
  target         = module.bastion.primary_network_interface
  resource_group = module.resource_group.resource_group_id
  tags           = local.tags
}

module "control_plane" {
  count             = var.controller_node_count
  source            = "./modules/compute"
  prefix            = "${local.prefix}-controller-${count.index + 1}"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = ibm_is_vpc.vpc.id
  subnet_id         = ibm_is_subnet.controller.id
  security_group_id = module.control_plane_security_group.security_group_id
  zone              = local.vpc_zones[0].zone
  ssh_key_ids       = [data.ibm_is_ssh_key.sshkey.id]
  tags              = local.tags
}

module "worker_node" {
  count             = var.worker_node_count
  source            = "./modules/compute"
  prefix            = "${local.prefix}-worker-${count.index + 1}"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = ibm_is_vpc.vpc.id
  subnet_id         = ibm_is_subnet.worker.id
  security_group_id = module.worker_security_group.security_group_id
  zone              = local.vpc_zones[0].zone
  ssh_key_ids       = [data.ibm_is_ssh_key.sshkey.id]
  tags              = local.tags
}

module "ansible" {
  source            = "./modules/ansible"
  bastion_public_ip = ibm_is_floating_ip.bastion.address
  controllers       = module.control_plane[*].instance[0]
  workers           = module.worker_node[*].instance[0]
  region            = var.region
}
