//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variable "debug" {
  description = "Enable debug logging and charm-level debug options across all deployed applications."
  type        = bool
  default     = false
}

variable "base" {
  description = "Ubuntu base to use for deployed charms and machines."
  type        = string
  default     = "ubuntu@24.04"
}

variable "channel" {
  description = "Channel for the deployed charm"
  type        = string
  default     = "latest/stable"
}

variable "constraints" {
  description = "List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>`"
  type        = list(string)
  default     = []
}

variable "enable_ha" {
  description = "Number of lxd nodes to deploy per subcluster"
  type        = bool
  default     = false
}

variable "enable_cos" {
  description = "Enable cos integration by deploying grafana-agent charm."
  type        = bool
  default     = false
}

variable "enable_lb" {
  description = "Deploy an haproxy load balancer in front of the gateway and dashboard."
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "SSH key to be imported in the juju models. No key is imported by default."
  type        = string
  default     = ""
}

variable "ubuntu_pro_token" {
  description = "Ubuntu Advantage token that is received with your license of Anbox Cloud."
  type        = string
  default     = ""
}
