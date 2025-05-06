//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variable "model_suffix" {
  type        = string
  description = "Suffix to attach for model"
}

variable "channel" {
  description = "Channel for the deployed charm"
  type        = string
  default     = "latest/stable"
}

variable "external_etcd" {
  description = "Channel for the deployed charm"
  type        = bool
  default     = false
}

variable "lxd_nodes" {
  description = "Channel for the deployed charm"
  type        = number
  default     = 1
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

variable "registry_config" {
  description = "Object to represent connection details for connecting to anbox registry"
  type = object({
    mode      = string
    offer_url = string
  })
  default = null
}

variable "enable_cos" {
  description = "Enable cos integration by deploying grafana-agent charm."
  type        = bool
  default     = false
}

