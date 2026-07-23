{ class, lib, ... }:
{
  home.activation.fetchSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v op &>/dev/null; then
      ${lib.optionalString (class == "work") ''
        run mkdir -p "$HOME/.aws"
        op read "op://Employee/awsconfig/notesPlain" > "$HOME/.aws/config"
        run chmod 600 "$HOME/.aws/config"
      ''}
      ${lib.optionalString (class == "personal") ''
        run mkdir -p "$HOME/.kube" "$HOME/.talos"
        op read "op://Homelab Tofu/talos-kubeconfig/notesPlain" > "$HOME/.kube/talos_config"
        op read "op://Homelab Tofu/talos-talosconfig/notesPlain" > "$HOME/.talos/talos_config"
        run chmod 600 "$HOME/.kube/talos_config" "$HOME/.talos/talos_config"
      ''}
    else
      verboseEcho "WARNING: 1Password CLI not found. Skipping secret provisioning."
    fi
  '';
}
