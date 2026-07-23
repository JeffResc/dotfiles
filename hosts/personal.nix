{ username, pkgs, ... }:
{
  homebrew = {
    taps = [
      "jeffreywildman/virt-manager"
      "robusta-dev/krr"
      "supabase/tap"
      "tw93/tap"
    ];
    brews = [
      "jeffreywildman/virt-manager/virt-viewer"
      "oauth2l"
      "openapi-generator"
      "robusta-dev/krr/krr"
      "rtl_433"
      "supabase/tap/supabase"
      "tw93/tap/mole"
      "virt-manager"
      "wireshark"
    ];
    casks = [
      "basictex"
      "ha-menu"
      "kap"
      "mitmproxy"
      "openscad"
      "orbstack"
      "session-manager-plugin"
      "visual-studio-code"
      "wireshark"
    ];
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      age
      argocd
      backblaze-b2
      ccache
      chart-testing
      cilium-cli
      cloudflared
      cmake
      coreutils
      croc
      delve
      dfu-util
      dnsutils
      fluxcd
      gnu-tar
      hubble
      iperf3
      k8sgpt
      kopia
      kubebuilder
      kubeconform
      kubeseal
      libpq
      meson
      minio-client
      nmap
      ollama
      openocd
      poppler
      pv
      rustup
      socat
      sops
      talosctl
      velero
      virtctl
      vsce
      yt-dlp
    ];
  };
}
