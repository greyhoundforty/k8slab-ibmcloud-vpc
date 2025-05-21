# Kube-Base Role

This role installs and configures the base Kubernetes components required on all cluster nodes (both controllers and workers).

## Purpose

The kube-base role prepares the system for running Kubernetes by configuring required kernel modules, system parameters, container runtime (containerd), and installing Kubernetes components.

## Tasks Performed

1. **Kernel Configuration**:
   - Loads and enables the `overlay` and `br_netfilter` kernel modules
   - Configures required sysctl parameters (`net.ipv4.ip_forward`, `net.bridge.bridge-nf-call-iptables`)

2. **Container Runtime Installation**:
   - Installs containerd v2.0.3
   - Configures containerd systemd service
   - Generates containerd configuration

3. **Container Tools Installation**:
   - Installs runc
   - Installs CNI plugins for Kubernetes networking

4. **Kubernetes Component Installation**:
   - Adds the Kubernetes APT repository
   - Installs kubelet, kubeadm, and kubectl (version 1.32.2-1.1)
   - Pins Kubernetes packages to prevent unintended upgrades
   - Enables kubelet systemd service

## Requirements

- Ubuntu/Debian-based system (the role focuses on APT-based package installation)
- Root or sudo access
- Internet connectivity for package downloads

## Dependencies

- This role depends on the `common` role for basic system preparation

## Notes

- The role implements idempotent checks before each task to ensure components are only installed if not already present
- Kernel modules are configured for persistence to survive reboots
- The role is designed to work on Ubuntu 24.04 but should be compatible with other Debian-based systems
- Contains error handling and proper registration of changes

## Variables

The role uses fixed versions for better stability:
- Containerd version: 2.0.3
- Runc version: 1.3.0-rc.1
- CNI plugins version: 1.6.2
- Kubernetes version: 1.32.2-1.1
