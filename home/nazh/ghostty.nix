{ config, ... }:
{
  programs.ghostty = {
    enable = config.mySystem.enableGui;

    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = { };
  };
}
