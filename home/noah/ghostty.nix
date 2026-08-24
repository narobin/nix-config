{ mySystem, pkgs, ... }:
{
  programs.ghostty = {
    enable = mySystem.enableGui;

    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = { };
  };
}
