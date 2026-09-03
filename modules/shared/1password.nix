{ config, ... }:
{
  programs._1password-gui.enable = config.mySystem.enableGui;
  programs._1password.enable = true;
}
