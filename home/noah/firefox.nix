{ mySystem, ... }:
{
  programs.firefox = {
    enable = mySystem.enableGui;
    profiles.default = { };
  };
}
