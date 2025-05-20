variable "ibmcloud_api_key" {
  description = "IBM Cloud Api key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "ca-mon"
}

variable "existing_resource_group" {
  description = "Name of an existing Resource Group to use for resources. If not set, a new Resource Group will be created."
  type        = string
  default     = ""
}

variable "default_address_prefix" {
  description = "The address prefix to use for the VPC. Default is set to auto."
  type        = string
  default     = "auto"
}


variable "owner" {
  description = "Owner declaration for resource tags. e.g. 'ryantiffany'"
  type        = string
}

variable "existing_ssh_key" {
  description = "Name of an existing SSH key to use for the VPC. If not set, a new SSH key will be created."
  type        = string
  default     = ""
}

variable "controller_node_count" {
  description = "Number of Kubertnetes controller nodes to create."
  type        = number
  default     = 3
}

variable "worker_node_count" {
  description = "Number of Kubernetes worker nodes to create."
  type        = number
  default     = 3
}

variable "remote_ssh_ip" {
  description = "Remote SSH IP address for inbound access."
  type        = string
  default     = "0.0.0.0/0"
}
