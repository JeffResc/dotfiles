{ username, pkgs, ... }:
{
  homebrew = {
    taps = [
      "tw93/tap"
    ];
    brews = [
      "tw93/tap/mole"
    ];
    casks = [
      "balenaetcher"
      "bambu-studio"
      "basictex"
      "betterdisplay"
      "claude"
      "coolterm"
      "elgato-stream-deck"
      "gcloud-cli"
      "ha-menu"
      "imazing-profile-editor"
      "logi-options+"
      "mitmproxy"
      "mullvad-vpn"
      "notion"
      "obs"
      "obsidian"
      "ollama-app"
      "openscad"
      "openvpn-connect"
      "orbstack"
      "qflipper"
      "qmk-toolbox"
      "raspberry-pi-imager"
      "raycast"
      "rustdesk"
      "session-manager-plugin"
      "slack"
      "spotify"
      "steam"
      "unnaturalscrollwheels"
      "visual-studio-code"
      "vlc"
      "wifiman"
      "winbox"
    ];
    masApps = {
      "Apple Configurator" = 1037126344;
      "iMazing Profile Editor" = 1487860882;
      "MQTT Explorer" = 1455214828;
      "Tailscale" = 1475387142;
      "The Unarchiver" = 425424353;
      "Yubico Authenticator" = 1497506650;
    };
  };

  # Apps intentionally installed manually (not tracked here):
  #   SDR++                              - no Homebrew cask exists
  #   Helium                             - vendor install, not in App Store
  #   CalDigit Docking Station Utility   - vendor installer
  #   Autodesk Fusion (+ Service Utility) - Autodesk installer
  #   Games (Steam library, Jackbox Party Packs, KSP, Cities Skylines) - Steam / installer
  #   Python 3.11                        - system installer (use nix + uv instead)
  #   Mitmproxy Redirector               - bundled by the mitmproxy cask
  #   Claude Code URL Handler            - bundled by the claude-code cask
  #   CHIRP                              - cask URL 403s (archive.chirpmyradio.com); reinstall via cask when upstream fixed
  #   VNC Viewer                         - cask URL 404s (RealVNC moved download); reinstall via cask when upstream updates
  #   Remote Desktop Manager             - cask install chmod-fails on SIP-protected framework files; install manually from devolutions.net

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
      gnutar
      hubble
      iperf3
      k8sgpt
      kopia
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
      rtl_433
      rustup
      socat
      sops
      talosctl
      velero
      vsce
      yt-dlp
    ];
  };
}
