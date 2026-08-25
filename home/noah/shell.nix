{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    initExtra = ''
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
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      drs = "darwin-rebuild switch";
      zed = "zeditor";
    };

    shellAliases = {
      vi  = "nvim";
      vim = "nvim";
    };

    interactiveShellInit = ''
      set -g fish_greeting

      fish_vi_key_bindings
    '';

    plugins = [ ];
  };
}
