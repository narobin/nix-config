
{ pkgs, config, ... }:

let
  username = "noah";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDir = if isDarwin then "Users/${username}" else "/home/${username}";
  sudoerGroup = if isDarwin then "admin" else "wheel";
in
{
  users.users.${username} = {
    isNormalUser = true;
    home = homeDir;
    shell = pkgs.zsh;
    extraGroups = [ sudoerGroup ];
  };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = homeDir;

    _module.args.mySystem = config.mySystem;

    imports = [
      ./../../home/${username}/git.nix
      ./../../home/${username}/shell.nix
      ./../../home/${username}/obsidian.nix
      ./../../home/${username}/zed.nix
      ./../../home/${username}/ghostty.nix
    ];
  };
}
