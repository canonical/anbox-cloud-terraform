//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variable "ubuntu_pro_token" {
  description = "Pro token used for anbox services"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.ubuntu_pro_token) > 0
    error_message = "Ubuntu Pro Token should not be empty"
  }
}

variable "constraints" {
  description = "List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>`"
  type        = list(string)
  default     = []
}

variable "anbox_channel" {
  description = "Channel to deploy anbox cloud charms from."
  type        = string

  validation {
    condition     = can(regex("\\d+\\.\\d+\\/\\w+", var.anbox_channel))
    error_message = "Channel should be of the format `\\d+.\\d+/\\w+`"
  }
}

variable "subcluster_labels" {
  type        = list(string)
  default     = []
  description = "Number of subclusters to deploy"
  validation {
    condition     = length(var.subcluster_labels) > 0
    error_message = "Minimum 1 subcluster is required."
  }
}

variable "lxd_nodes_per_subcluster" {
  description = "Number of lxd nodes to deploy per subcluster"
  type        = number
  default     = 1
}

variable "enable_ha" {
  description = "Number of lxd nodes to deploy per subcluster"
  type        = bool
  default     = false
}


