{ config, lib, ... }:
{
  # TODO: l8n

  # TODO: set up hyprland
  services.hyprland.enable = config.mySystem.enableGui;
}
