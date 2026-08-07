{
  config,
  class,
  lib,
  kubectl-aliases,
  ...
}:
{
  xdg.configFile = {
    "ghostty/config".source = ../../configs/ghostty/config;
  };

  home.file = {
    ".dlv/config.yml".source = ../../configs/dlv/config.yml;
    ".claude/settings.json".source = ../../configs/claude/settings.json;
    ".claude/CLAUDE.md".source = ../../configs/ai-instructions.md;
    ".codex/AGENTS.md".source = ../../configs/ai-instructions.md;
    ".azure-select.sh".source = ../../configs/azure-select.sh;
    ".kubectl_aliases".source = "${kubectl-aliases}/.kubectl_aliases";
    ".local/bin/kube-edit.sh" = {
      source = ../../configs/kube-edit.sh;
      executable = true;
    };
  };

  # OpenTofu Cloudflare R2 state backend (homelab repo). R2 has no SSO/OIDC;
  # the key is pulled from 1Password at runtime so nothing lands on disk.
  home.file.".local/bin/r2-credential-process.sh" = lib.mkIf (class == "personal") {
    source = ../../configs/aws/r2-credential-process.sh;
    executable = true;
  };
  home.file.".aws/config" = lib.mkIf (class == "personal") {
    text = ''
      [profile homelab-tofu]
      region = auto
      credential_process = ${config.home.homeDirectory}/.local/bin/r2-credential-process.sh
    '';
  };

  home.file.".ssh/config" = {
    text = ''
      Include ~/.ssh/config.local
      ${lib.optionalString (class == "personal") "Include ~/.orbstack/ssh/config\n"}
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
