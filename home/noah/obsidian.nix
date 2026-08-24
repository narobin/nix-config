{ mySystem, ... }:
{
  programs.obsidian = {
    enable = config.mySystem.enableGui;
    cli.enable = true;
  };
}
