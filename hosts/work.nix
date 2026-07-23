{ username, pkgs, du-packages, ... }:
let
  duPkgs = du-packages.packages.${pkgs.stdenv.hostPlatform.system};
in
{
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

  home-manager.users.${username} = {
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
