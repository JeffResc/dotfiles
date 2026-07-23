{ class, pkgs, userEmail, signingKey, lib, ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = signingKey;
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Jeff Rescignano";
        email = userEmail;
      };
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      init.defaultBranch = "main";
      credential."https://github.com" = {
        helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
      };
      credential."https://gist.github.com" = {
        helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
      };
    } // lib.optionalAttrs (class == "personal") {
      credential.helper = "store";
      filter.lfs = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
      };
    };
  };
}
