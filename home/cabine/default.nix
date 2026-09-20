{
  pkgs,
  lib,
  config,
  ...
}:

let
  username = "cabine";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDir = if isDarwin then /Users/${username} else "/home/${username}";
in
{
  users.users.${username} = {
    home = homeDir;
    shell = pkgs.zsh;
  }
  // lib.optionalAttrs (!isDarwin) {
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    isNormalUser = true;
    uid = 1001;
    # openssh.authorizedKeys.keyFiles = [
    #   ./resources/remote-access.pub
    # ];
    # hashedPasswordFile = config.sops.secrets."cabine/password".path;
  };

  home-manager.users.${username} = {
    imports = [
      ./git.nix
      ./shell.nix
    ];
  };
}
