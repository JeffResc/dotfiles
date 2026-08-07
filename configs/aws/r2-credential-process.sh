#!/usr/bin/env bash
# AWS credential_process helper for the OpenTofu Cloudflare R2 state backend
# (profile "homelab-tofu"; see homelab repo stacks/homelab.yaml).
#
# R2 does not support SSO/OIDC, so the S3 API needs a static access key. We keep
# it out of ~/.aws entirely by fetching it from 1Password on each tofu run and
# emitting it as an ephemeral credential process payload.
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html
set -euo pipefail

item="op://Homelab Tofu/r2-key-homelab-tofu"

ak="$(op read "${item}/ACCESS_KEY_ID")"
sk="$(op read "${item}/ACCESS_SECRET_KEY")"

printf '{"Version":1,"AccessKeyId":"%s","SecretAccessKey":"%s"}\n' "${ak}" "${sk}"
