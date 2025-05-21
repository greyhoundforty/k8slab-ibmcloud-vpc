# Common Role

This role applies common configuration to all hosts in the Kubernetes cluster environment.

## Purpose

The common role performs basic system maintenance and updates to ensure all systems are up-to-date and ready for further configuration.

## Tasks Performed

- Updates system packages on both RPM-based (Red Hat/CentOS) and DEB-based (Ubuntu/Debian) systems
- Implements retry logic for package updates to handle temporary network issues
- Applies OS-specific optimizations based on detected system family

## Usage

This role is typically run against all hosts in the inventory and should be executed before other more specific roles.

## Requirements

- Root or sudo access on target hosts
- Internet connectivity for package updates

## Dependencies

None. This is a base role that other roles depend on.

## Example

```yaml
- name: Apply common configuration
  become: true
  hosts: all
  roles:
    - common
```

## Notes

- The update tasks include retry logic with a 30-second delay and 10 retries to handle temporary network issues
- The role automatically detects the operating system family and applies the appropriate package manager commands
