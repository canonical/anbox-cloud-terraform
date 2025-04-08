#!/bin/bash
#
# Copyright 2025 Canonical Ltd. All rights reserved.

trivy fs "$GITHUB_WORKSPACE" --format json --output trivy-full-report.json

kev_cves="$(jq -r '.vulnerabilities[].cveID' kev.json | sort -u)"

found_cves="$(jq -r '.Results[] | select(.Vulnerabilities != null) | .Vulnerabilities[].VulnerabilityID' trivy-full-report.json | sort -u)"

matches="$(echo "$found_cves" | grep -F -f <(echo "$kev_cves") || true)"

if [ -n "$matches" ]; then
  echo "KEV listed vulnerabilities found."
  echo "$matches"
  exit 1
fi

echo "No KEV listed vulnerabilities found."