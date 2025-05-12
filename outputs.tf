#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#

output "anbox_models" {
  value       = compact(concat(values(module.subcluster)[*].model_name, [module.controller.model_name, one(module.registry[*].model_name)]))
  description = "Name of the models created for Anbox Cloud"
}
