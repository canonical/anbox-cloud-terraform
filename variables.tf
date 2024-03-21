variable "ua_token" {
  description = "Pro token used for anbox services"
  type        = string
  sensitive   = true
}

variable "constraints" {
  description = "List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>`"
  type        = list(string)
  default     = []
}

variable "cloud_name" {
  description = "Name of the cloud to deploy the subcluster to"
  type        = string
}

variable "subclusters_per_region" {
  description = "Number of subclusters per region in the given cloud e.g `{ ap-south-east-1 = 1 }`"
  type        = map(list(string))
  nullable    = false
}

variable "lxd_nodes_per_subcluster" {
  description = "Number of lxd nodes to deploy per subcluster"
  type        = number
  default     = 1
}

