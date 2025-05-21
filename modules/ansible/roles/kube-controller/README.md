# Kube-Controller Role

This role initializes the Kubernetes control plane on designated controller nodes.

## Purpose

The kube-controller role initializes a Kubernetes cluster using kubeadm, configures the Calico CNI networking plugin, and sets up administrative access. It's designed to be run on the controller nodes after the kube-base role has prepared the system.

## Tasks Performed

1. **Kubernetes Cluster Initialization**:
   - Checks if Kubernetes is already initialized
   - Runs `kubeadm init` to initialize the Kubernetes control plane if needed
   - Specifies the pod CIDR range (172.16.0.0/16) for the cluster network

2. **Cluster Access Configuration**:
   - Generates a join command token for worker nodes
   - Directly copies the admin.conf file to the bastion host using SCP
   - Creates a backup of the admin.conf for reference

3. **Calico CNI Deployment**:
   - Downloads and applies the Calico CNI manifest
   - Waits for Calico pods to become ready

## Requirements

- The kube-base role must be run first to set up containerd and Kubernetes components
- Only runs on the designated controller nodes
- For multi-controller setups, initialization only happens on the first controller

## Dependencies

- Depends on the `common` and `kube-base` roles
- Requires network connectivity between controllers and the bastion host

## Notes

- The cluster is initialized with pod CIDR 172.16.0.0/16 (should match your network design)
- Tasks that interact with the bastion host only run on the first controller node
- The kubeconfig file is copied directly to the bastion host using SCP
- The role includes verification that the kubeconfig was successfully copied

## Variables Used/Exported

- `kubeadm_join_cmd`: This variable is generated and stored for the worker nodes to use when joining the cluster
