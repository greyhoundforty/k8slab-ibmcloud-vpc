module "dmz_security_group" {
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.5.0"
  add_ibm_cloud_internal_rules = true
  vpc_id                       = ibm_is_vpc.vpc.id
  resource_group               = module.resource_group.resource_group_id
  security_group_name          = "${local.prefix}-dmz-sg"
  security_group_rules = [
    {
      name      = "remote-ssh-inbound"
      direction = "inbound"
      remote    = var.remote_ssh_ip
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    {
      name      = "icmp-inbound"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      icmp = {
        type = 8
        code = 1
      }
    },
    {
      name      = "allow-all-inbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
    }
  ]
}

module "control_plane_security_group" {
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.5.0"
  add_ibm_cloud_internal_rules = true
  vpc_id                       = ibm_is_vpc.vpc.id
  resource_group               = module.resource_group.resource_group_id
  security_group_name          = "${local.prefix}-control-plane-sg"
  security_group_rules = [
    # Kubernetes API server
    {
      name      = "kube-apiserver"
      direction = "inbound"
      remote    = local.first_zone_prefix # Consider limiting to your VPC CIDR
      tcp = {
        port_min = 6443
        port_max = 6443
      }
    },
    # etcd server client API
    {
      name      = "etcd-client"
      direction = "inbound"
      remote    = ibm_is_subnet.controller.ipv4_cidr_block # CIDR of control plane nodes
      tcp = {
        port_min = 2379
        port_max = 2380
      }
    },
    # Kubelet API
    {
      name      = "kubelet-api"
      direction = "inbound"
      remote    = local.first_zone_prefix # CIDR of all K8s nodes
      tcp = {
        port_min = 10250
        port_max = 10250
      }
    },
    # kube-scheduler
    {
      name      = "kube-scheduler"
      direction = "inbound"
      remote    = ibm_is_subnet.controller.ipv4_cidr_block
      tcp = {
        port_min = 10259
        port_max = 10259
      }
    },
    # kube-controller-manager
    {
      name      = "kube-controller-manager"
      direction = "inbound"
      remote    = ibm_is_subnet.controller.ipv4_cidr_block
      tcp = {
        port_min = 10257
        port_max = 10257
      }
    },
    # Allow SSH from bastion
    {
      name      = "ssh-from-bastion"
      direction = "inbound"
      remote    = module.bastion_security_group.security_group_id
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    # Outbound internet access
    {
      name      = "outbound-all"
      direction = "outbound"
      remote    = "0.0.0.0/0"
    }
  ]
}

module "worker_security_group" {
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.5.0"
  add_ibm_cloud_internal_rules = true
  vpc_id                       = ibm_is_vpc.vpc.id
  resource_group               = module.resource_group.resource_group_id
  security_group_name          = "${local.prefix}-worker-sg"
  security_group_rules = [
    # Kubelet API
    {
      name      = "kubelet-api"
      direction = "inbound"
      remote    = local.first_zone_prefix # CIDR of all K8s nodes
      tcp = {
        port_min = 10250
        port_max = 10250
      }
    },
    # NodePort Services
    {
      name      = "nodeport-services"
      direction = "inbound"
      remote    = "0.0.0.0/0" # Adjust as needed
      tcp = {
        port_min = 30000
        port_max = 32767
      }
    },
    {
      name      = "pod-to-node-traffic"
      direction = "inbound"
      remote    = local.k8s_pod_cidr
      tcp = {
        port_min = 1
        port_max = 65535
      }
    },

    # Allow UDP for pod network
    {
      name      = "pod-network-udp"
      direction = "inbound"
      remote    = local.k8s_pod_cidr
      udp = {
        port_min = 1
        port_max = 65535
      }
    },

    # For CNI overlay network (adjust based on your CNI)
    {
      name      = "vxlan-overlay"
      direction = "inbound"
      remote    = local.first_zone_prefix
      udp = {
        port_min = 4789
        port_max = 4789
      }
    }, # Allow SSH from bastion
    {
      name      = "ssh-from-bastion"
      direction = "inbound"
      remote    = module.bastion_security_group.security_group_id
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    # Outbound internet access
    {
      name      = "outbound-all"
      direction = "outbound"
      remote    = "0.0.0.0/0"
    }
  ]
}