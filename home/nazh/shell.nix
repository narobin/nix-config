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
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "moor";
  };

  programs.fish = {
    enable = true;

    shellAbbrs = { };

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
