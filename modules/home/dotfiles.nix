{ class, lib, kubectl-aliases, ... }:
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

  home.file.".ssh/config" = {
    text = ''
      ${lib.optionalString (class == "personal") "Include ~/.orbstack/ssh/config\n"}
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
