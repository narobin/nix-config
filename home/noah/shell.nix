{
  pkgs,
  lib,
  config,
  ...
}:
let
  onePasswordPath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
    else
      "~/.1password/agent.sock";
in
{
  programs.zsh = {
    enable = true;
    initContent = ''
      if [[ $- == *i* ]] \
        && [ -z "$ZSH_EXECUTION_STRING" ] \
        && [[ "$(ps -p $PPID -o comm=)" != *fish* ]]
      then
        exec ${lib.getExe pkgs.fish} --login
      fi
    '';
  };

  home.sessionVariables = {
    EDITOR = lib.mkForce "nvim";
    VISUAL = lib.mkForce "nvim";
    PAGER = "moor";
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      drs = "sudo darwin-rebuild switch --flake .#";
      nrs = "sudo nixos-rebuild switch --flake github:narobin/nix-config# --refresh";
      zed = "zeditor .";
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    interactiveShellInit = ''
      set -g fish_greeting

      fish_vi_key_bindings 

      if test -z "$SSH_AUTH_SOCK"
        set -gx SSH_1P_SOCK ${onePasswordPath}
      else
        set -gx SSH_1P_SOCK $SSH_AUTH_SOCK
      end
    '';

    plugins = [ ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
