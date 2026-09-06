{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    initContent = ''
      if [[ $- == *i* ]] \
        && [ -z "$ZSH_EXECUTION_STRING" ] \
        && [[ "$(< /proc/$PPID/comm)" != "fish" ]]
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
      zed = "zeditor .";
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    interactiveShellInit = ''
      set -g fish_greeting

      fish_vi_key_bindings
    '';

    plugins = [ ];
  };
}
