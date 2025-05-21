# Bastion Role

This role configures the bastion host to serve as a management point for the Kubernetes cluster.

## Tasks Performed

1. Installs `kubectl` to allow cluster management
2. Configures the bastion host to use the admin kubeconfig file
3. Sets up environment variables and bash completion for easier management
4. Adds helpful kubectl aliases

## Requirements

- The `kube-controller` role must run first to generate and copy the kubeconfig file to the bastion host

## Variables

None required.

## Dependencies

This role depends on:
- The `common` role for basic system configuration
- The controller node having successfully initialized the Kubernetes cluster

## Notes

The bastion host allows you to securely manage your Kubernetes cluster without having to expose the control plane nodes to the internet. All kubectl commands can be run from the bastion host, which has the proper networking access to the private control plane nodes.