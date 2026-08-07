{ class, username, lib, ... }:
let
  op = "/opt/homebrew/bin/op";
  asUser = cmd: ''/usr/bin/sudo -u ${username} /bin/bash -c '${cmd}' '';
in
{
  home.activation.fetchSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${op}" ]; then
      ${lib.optionalString (class == "work") ''
        /bin/mkdir -p "$HOME/.aws"
        /usr/sbin/chown ${username} "$HOME/.aws"
        ${asUser "${op} read \"op://Employee/awsconfig/notesPlain\" --account defenseunicorns.1password.com > $HOME/.aws/config"}
        ${asUser "chmod 600 $HOME/.aws/config"}
      ''}
      ${lib.optionalString (class == "personal") ''
        /bin/mkdir -p "$HOME/.kube" "$HOME/.talos"
        /usr/sbin/chown ${username} "$HOME/.kube" "$HOME/.talos"
        ${asUser "${op} read \"op://Homelab Tofu/talos-kubeconfig/notesPlain\" --account my.1password.com > $HOME/.kube/talos_config"}
        ${asUser "${op} read \"op://Homelab Tofu/talos-talosconfig/notesPlain\" --account my.1password.com > $HOME/.talos/talos_config"}
        ${asUser "chmod 600 $HOME/.kube/talos_config $HOME/.talos/talos_config"}
      ''}
    else
      verboseEcho "WARNING: 1Password CLI not found at ${op}. Skipping secret provisioning."
    fi
  '';
}
