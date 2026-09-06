{ pkgs, ... }:

let
  username = "cabine";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDir = if isDarwin then "Users/${username}" else "/home/${username}";
in
{
  users.users.${username} = {
    home = homeDir;
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = {
    imports = [
      ./git.nix
      ./shell.nix
    ];
  };
}
