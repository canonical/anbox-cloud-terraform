//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variable "model_suffix" {
  type        = string
  description = "Suffix to attach for model"
}

variable "ubuntu_pro_token" {
  description = "Pro token used to deploy AMS charm"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.ubuntu_pro_token) > 0
    error_message = "Ubuntu Pro Token should not be empty"
  }
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

