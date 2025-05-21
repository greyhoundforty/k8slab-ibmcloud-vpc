output "control_node_info" {
  value = module.control_plane.0.instance
}

output "control_1_ip" {
  value = module.control_plane.0.primary_ip
}
