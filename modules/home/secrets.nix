{ class, username, lib, ... }:
let
  op = "/opt/homebrew/bin/op";
  asUser = cmd: ''/usr/bin/sudo -u ${username} /usr/bin/env OP_BIOMETRIC_UNLOCK_ENABLED=true /bin/bash -c ${lib.escapeShellArg cmd}'';
  writeSecret = account: ref: path: ''
    ${asUser ''
      set -e
      umask 077
      dest="$1"
      tmp=$(/usr/bin/mktemp "$dest.tmp.XXXXXX")
      trap '/bin/rm -f "$tmp"' EXIT
      ${op} read --no-newline ${lib.escapeShellArg ref} --account ${lib.escapeShellArg account} > "$tmp"
      if [ ! -s "$tmp" ]; then
        printf '1Password returned an empty value for %s; leaving the file unchanged.\n' "$dest" >&2
        exit 1
      fi
      /bin/mv -f "$tmp" "$dest"
    ''} bash "$HOME/${path}"
  '';
in
{
  home.activation.fetchSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${op}" ]; then
      ${lib.optionalString (class == "work") ''
        /bin/mkdir -p "$HOME/.aws"
        /usr/sbin/chown ${username} "$HOME/.aws"
        ${writeSecret "defenseunicorns.1password.com" "op://Employee/awsconfig/notesPlain" ".aws/config"}
      ''}
      ${lib.optionalString (class == "personal") ''
        /bin/mkdir -p "$HOME/.kube" "$HOME/.talos"
        /usr/sbin/chown ${username} "$HOME/.kube" "$HOME/.talos"
        ${writeSecret "my.1password.com" "op://Homelab Tofu/talos-kubeconfig/notesPlain" ".kube/talos_config"}
        ${writeSecret "my.1password.com" "op://Homelab Tofu/talos-talosconfig/notesPlain" ".talos/talos_config"}
      ''}
    else
      verboseEcho "WARNING: 1Password CLI not found at ${op}. Skipping secret provisioning."
    fi
  '';
}
