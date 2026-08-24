{ mySystem, ... }:
{
  programs.obsidian = {
    enable = mySystem.enableGui;
    cli.enable = true;
  };
}
