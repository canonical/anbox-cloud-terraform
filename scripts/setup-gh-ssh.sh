#!/bin/bash -ex
#
# Anbox Cloud Terraform
# Copyright 2026 Canonical Ltd.  All rights reserved.

# The key is provided through a secret and we need to write it to
# disk in order to load it into the SSH agent
mkdir -p "$HOME"/.ssh
echo "$ANBOX_CLOUD_CI_BOT_SSH_KEY" > "$HOME"/.ssh/id_bot
chmod 0600 "$HOME"/.ssh/id_bot

# Setup a host alias we can use with git push
cat << EOF > "$HOME"/.ssh/config
Host github-anbox-cloud-terraform
  Hostname github.com
  IdentityFile=$HOME/.ssh/id_bot
EOF

# If an egress proxy is configured we have to proxy all git commands through it
if [ -n "$EGRESS_PROXY" ]; then
  proxy_host="$(echo "$EGRESS_PROXY" | cut -d: -f1)"
  proxy_port="$(echo "$EGRESS_PROXY" | cut -d: -f2)"
  cat << EOF >> "$HOME"/.ssh/config
  port 22
  proxycommand socat - PROXY:${proxy_host}:%h:%p,proxyport=${proxy_port}
EOF
fi

# We need to trust the SSH host key from GitHub. Note that we
# don't use ssh-keyscan here as we wont get it easily through
# the egress proxy on our self hosted runners
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/meta | jq -r '.ssh_keys[] | "github.com " + .' > "$HOME"/.ssh/known_hosts


# And now we can finally start the agent and load our key
eval "$(ssh-agent -s)"
ssh-add "$HOME"/.ssh/id_bot
