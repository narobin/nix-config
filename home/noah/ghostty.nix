{ mySystem, ... }:
{
  programs.ghostty = {
    enable = mySystem.enableGui;

    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = { };
  };
}
