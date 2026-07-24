{ username, pkgs, lib, du-packages, ... }:
let
  duPkgs = du-packages.packages.${pkgs.stdenv.hostPlatform.system};
  selfServiceApps = [
    { path = "/Applications/1Password.app"; id = 107; name = "1Password 8"; entity = "app-installer"; }
    { path = "/Applications/Adobe Acrobat Reader.app"; id = 105; name = "Adobe Acrobat"; entity = "app-installer"; }
    { path = "/Applications/Azure VPN Client.app"; id = 31; name = "Azure VPN"; entity = "app"; }
    { path = "/Applications/BetterDisplay.app"; id = 185; name = "BetterDisplay"; entity = "policy"; }
    { path = "/Applications/ChatGPT.app"; id = 88; name = "ChatGPT"; entity = "app-installer"; }
    { path = "/Applications/Claude.app"; id = 139; name = "Claude Desktop"; entity = "app-installer"; }
    { path = "/Applications/draw.io.app"; id = 54; name = "draw.io"; entity = "app-installer"; }
    { path = "/Applications/Elgato Stream Deck.app"; id = 134; name = "Elgato Stream Deck"; entity = "app-installer"; }
    { path = "/Applications/Gather.app"; id = 348; name = "Gather"; entity = "policy"; }
    { path = "/Applications/Google Chrome.app"; id = 124; name = "Google Chrome"; entity = "policy"; }
    { path = "/Applications/Linear.app"; id = 131; name = "Linear"; entity = "app-installer"; }
    { path = "/Applications/logioptionsplus.app"; id = 311; name = "Logi Options+"; entity = "policy"; }
    { path = "/Applications/Microsoft Teams.app"; id = 55; name = "Teams"; entity = "app-installer"; }
    { path = "/Applications/Notion.app"; id = 44; name = "Notion"; entity = "app-installer"; }
    { path = "/Applications/Obsidian.app"; id = 29; name = "Obsidian"; entity = "app-installer"; }
    { path = "/Applications/OpenVPN Connect/OpenVPN Connect.app"; id = 120; name = "OpenVPN Connect"; entity = "app-installer"; }
    { path = "/Applications/OrbStack.app"; id = 256; name = "OrbStack"; entity = "policy"; }
    { path = "/Applications/Raycast.app"; id = 144; name = "Raycast"; entity = "app-installer"; }
    { path = "/Applications/Signal.app"; id = 87; name = "Signal"; entity = "app-installer"; }
    { path = "/Applications/Slack.app"; id = 274; name = "Slack"; entity = "policy"; }
    { path = "/Applications/Spotify.app"; id = 66; name = "Spotify"; entity = "app-installer"; }
    { path = "/Applications/Tailscale.app"; id = 116; name = "Tailscale"; entity = "app-installer"; }
    { path = "/Applications/Visual Studio Code.app"; id = 108; name = "VS Code"; entity = "app-installer"; }
    { path = "/Applications/Wireshark.app"; id = 118; name = "Wireshark"; entity = "app-installer"; }
  ];
  uid = "\"$(id -u ${username})\"";
  openAsUser = "launchctl asuser ${uid} open";
  selfServiceInstallScript = builtins.concatStringsSep "\n" (map (app: ''
    if [ ! -e "${app.path}" ]; then
      echo "Installing ${app.name} via Jamf Self Service..."
      ${openAsUser} "selfservicecapability://content?action=execute&id=${toString app.id}&entity=${app.entity}"
    fi
  '') selfServiceApps);
in
{
  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/System/Applications/App Store.app"
    "/Applications/Google Chrome.app"
    "/System/Applications/System Settings.app"
    "/Applications/Slack.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Notion.app"
    "/Applications/Gather.app"
    "/Applications/Spotify.app"
    "/Applications/Obsidian.app"
    "/System/Applications/Home.app"
    "/Applications/Claude.app"
    "/Applications/Ghostty.app"
    "/Applications/Signal.app"
  ];
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "Checking Jamf Self Service apps..." >&2
    ${selfServiceInstallScript}

    # DOD Root CAs - check system keychain
    if ! security find-certificate -c "DoD Root" /Library/Keychains/System.keychain >/dev/null 2>&1; then
      echo "Installing DOD Root CAs via Jamf Self Service..."
      ${openAsUser} "selfservicecapability://content?action=execute&id=328&entity=configprofile"
    fi

    # STIG Viewer - version number in app name
    if ! ls /Applications/STIG\ Viewer* >/dev/null 2>&1; then
      echo "Installing STIG Viewer via Jamf Self Service..."
      ${openAsUser} "selfservicecapability://content?action=execute&id=152&entity=policy"
    fi

    # ChatGPT Desktop
    if [ ! -e "/Applications/ChatGPT.app" ]; then
      echo "Installing ChatGPT via Jamf Self Service..."
      ${openAsUser} "selfservicecapability://content?action=execute&id=154&entity=app-installer"
    fi
  '';

  homebrew = {
    masApps = {
      "Jamf Trust" = 1608041266;
      "Windows App" = 1295203466;
    };
    brews = [
      "chainloop-cli"
      "hashicorp/tap/packer"
      "lima-additional-guestagents"
      "opa"
      "opensc"
      "terramaid"
    ];
    casks = [
      "codex"
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
