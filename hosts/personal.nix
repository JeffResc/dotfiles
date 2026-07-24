{ username, pkgs, ... }:
{
  homebrew = {
    casks = [
      "1password"
      "balenaetcher"
      "bambu-studio"
      "basictex"
      "betterdisplay"
      "caldigit-docking-utility"
      "claude"
      "codex"
      "coolterm"
      "elgato-stream-deck"
      "gcloud-cli"
      "google-chrome"
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
      "visual-studio-code"
      "vlc"
      "wifiman"
      "winbox"
    ];
    masApps = {
      "Apple Configurator" = 1037126344;
      "iMazing Profile Editor" = 1487860882;
      "MQTT Explorer" = 1455214828;
      "Numbers" = 409203825;
      "Tailscale" = 1475387142;
      "The Unarchiver" = 425424353;
      "Yubico Authenticator" = 1497506650;
    };
  };

  # Apps intentionally installed manually (not tracked here):
  #   SDR++                              - no Homebrew cask exists
  #   Helium (helium.foss42.com browser) - not in Homebrew (existing `helium` cask is a different, deprecated app)
  #   Autodesk Fusion (+ Service Utility) - cask runs an installer downloader, not a cask-style copy; install manually via Autodesk
  #   Games (Steam library, Jackbox Party Packs, KSP, Cities Skylines) - Steam / installer
  #   Python 3.11                        - system installer (use nix + uv instead)
  #   Mitmproxy Redirector               - bundled by the mitmproxy cask
  #   Claude Code URL Handler            - bundled by the claude-code cask
  #   CHIRP                              - cask disabled 2025-08-05 (Cloudflare blocks fetch); reinstall via cask when upstream restored
  #   VNC Viewer                         - cask URL still 404s (RealVNC download moved); install manually from realvnc.com

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
