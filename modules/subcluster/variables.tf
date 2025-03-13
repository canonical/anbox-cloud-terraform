variable "ubuntu_pro_token" {
  description = "Pro token used to deploy AMS charm"
  type        = string
  sensitive   = true
}

variable "model_name" {
  description = "Model name used to deploy the applications"
  type        = string
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

variable "deploy_dashboard" {
  description = "Deploy anbox cloud dashboard with the streaming stack"
  type        = bool
  default     = false
}

variable "deploy_streaming_stack" {
  description = "Deploy anbox cloud streaming stack"
  type        = bool
  default     = false
}

variable "deploy_lb" {
  description = "Deploy a load balancer with anbox cloud streaming stack"
  type        = bool
  default     = false
}

