//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

output "anbox_cloud_subclusters" {
  value = { for name, cluster in module.subcluster : name => cluster.applications }
}
