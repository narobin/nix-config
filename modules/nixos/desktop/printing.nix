{ config, ... }:
{
  services.printing.enable = config.mySystem.enableGui;
}
