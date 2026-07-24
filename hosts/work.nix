{ username, pkgs, lib, du-packages, ... }:
let
  duPkgs = du-packages.packages.${pkgs.stdenv.hostPlatform.system};
  selfServiceApps = [
    { path = "/Applications/1Password.app"; id = 107; name = "1Password 8"; }
    { path = "/Applications/Adobe Acrobat Reader.app"; id = 105; name = "Adobe Acrobat"; }
    { path = "/Applications/Azure VPN Client.app"; id = 31; name = "Azure VPN"; }
    { path = "/Applications/BetterDisplay.app"; id = 185; name = "BetterDisplay"; }
    { path = "/Applications/ChatGPT.app"; id = 88; name = "ChatGPT"; }
    { path = "/Applications/Claude.app"; id = 139; name = "Claude Desktop"; }
    { path = "/Applications/draw.io.app"; id = 54; name = "draw.io"; }
    { path = "/Applications/Elgato Stream Deck.app"; id = 134; name = "Elgato Stream Deck"; }
    { path = "/Applications/Gather.app"; id = 348; name = "Gather"; }
    { path = "/Applications/Google Chrome.app"; id = 124; name = "Google Chrome"; }
    { path = "/Applications/Linear.app"; id = 131; name = "Linear"; }
    { path = "/Applications/logioptionsplus.app"; id = 311; name = "Logi Options+"; }
    { path = "/Applications/Microsoft Teams.app"; id = 55; name = "Teams"; }
    { path = "/Applications/Notion.app"; id = 44; name = "Notion"; }
    { path = "/Applications/Obsidian.app"; id = 29; name = "Obsidian"; }
    { path = "/Applications/OpenVPN Connect/OpenVPN Connect.app"; id = 120; name = "OpenVPN Connect"; }
    { path = "/Applications/OrbStack.app"; id = 256; name = "OrbStack"; }
    { path = "/Applications/Raycast.app"; id = 144; name = "Raycast"; }
    { path = "/Applications/Signal.app"; id = 87; name = "Signal"; }
    { path = "/Applications/Slack.app"; id = 274; name = "Slack"; }
    { path = "/Applications/Spotify.app"; id = 66; name = "Spotify"; }
    { path = "/Applications/Tailscale.app"; id = 116; name = "Tailscale"; }
    { path = "/Applications/Visual Studio Code.app"; id = 108; name = "VS Code"; }
    { path = "/Applications/Wireshark.app"; id = 118; name = "Wireshark"; }
  ];
  selfServiceInstallScript = builtins.concatStringsSep "\n" (map (app: ''
    if [ ! -e "${app.path}" ]; then
      echo "Installing ${app.name} via Jamf Self Service..."
      open "selfservicecapability://content?action=execute&id=${toString app.id}&entity=policy"
    fi
  '') selfServiceApps);
in
{
  system.activationScripts.selfService.text = ''
    ${selfServiceInstallScript}

    # DOD Root CAs - check system keychain
    if ! security find-certificate -c "DoD Root" /Library/Keychains/System.keychain >/dev/null 2>&1; then
      echo "Installing DOD Root CAs via Jamf Self Service..."
      open "selfservicecapability://content?action=execute&id=328&entity=policy"
    fi

    # STIG Viewer - version number in app name
    if ! ls /Applications/STIG\ Viewer* >/dev/null 2>&1; then
      echo "Installing STIG Viewer via Jamf Self Service..."
      open "selfservicecapability://content?action=execute&id=152&entity=policy"
    fi

    # OpenAI Codex - CLI tool
    if ! command -v codex >/dev/null 2>&1; then
      echo "Installing OpenAI Codex via Jamf Self Service..."
      open "selfservicecapability://content?action=execute&id=154&entity=policy"
    fi
  '';

  homebrew = {
    taps = [ "jorgelbg/tap" ];
    brews = [
      "chainloop-cli"
      "defenseunicorns/tap/lula"
      "hashicorp/tap/packer"
      "lima-additional-guestagents"
      "opa"
      "opensc"
      "terramaid"
    ];
    casks = [
      "font-teko"
      "session-manager-plugin"
    ];
  };

  home-manager.users.${username} = { lib, ... }: {
    home.packages = with pkgs; [
      aws-iam-authenticator
      eksctl
      gitleaks
      gnupg
      inetutils
      k0sctl
      minio-client
      step-cli

      duPkgs.chainctl
      duPkgs.uds-cli
      duPkgs.zarf
    ];

    home.activation.azureExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v az &>/dev/null; then
        for ext in aks-preview bastion image-copy-extension ssh; do
          if ! az extension show --name "$ext" &>/dev/null; then
            verboseEcho "Installing Azure CLI extension: $ext"
            az extension add --name "$ext" --yes 2>/dev/null || verboseEcho "WARNING: Failed to install az extension $ext"
          fi
        done
      fi
    '';

    home.file.".azure/config".text = ''
      [cloud]
      name = AzureUSGovernment
    '';

    home.file.".granted/config".text = ''
      DefaultBrowser = "CHROME"
      CustomBrowserPath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      CustomSSOBrowserPath = ""
      Ordering = ""
      ExportCredentialSuffix = ""

      [Keyring]
        Backend = "keychain"
    '';
  };
}
