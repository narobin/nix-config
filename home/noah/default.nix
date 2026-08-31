{
  pkgs,
  config,
  lib,
  ...
}:

let
  username = "noah";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDir = if isDarwin then /Users/${username} else "/home/${username}";
in
{
  users.users.${username} = {
    home = homeDir;
    shell = pkgs.zsh;
  }
  // lib.optionalAttrs (!isDarwin) {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [
      ./resources/remote-access.pub
    ];
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
      ./chromium.nix
      ./1password.nix
      ./neovim.nix
    ];
  };
}
