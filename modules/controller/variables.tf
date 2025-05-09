//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

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

