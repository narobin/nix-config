{ pkgs, config, ... }:

let
  username = "noah";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDir = if isDarwin then /Users/${username} else "/home/${username}";
  # sudoerGroup = if isDarwin then "admin" else "wheel";
in
{
  users.users.${username} = {
    # isNormalUser = true;
    home = homeDir;
    shell = pkgs.zsh;
    # extraGroups = [ sudoerGroup ];
  };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = homeDir;

    _module.args.mySystem = config.mySystem;

    imports = [
      ./git.nix
      ./shell.nix
      ./obsidian.nix
      ./zed.nix
      ./ghostty.nix
      ./ssh.nix
      ./firefox.nix
      ./1password.nix
      ./neovim.nix
    ];
  };
}
