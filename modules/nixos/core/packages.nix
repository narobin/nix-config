{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      tcpdump
    ]
    ++ lib.optionals config.mySystem.enableGui [
      wl-clipboard
      rofi
    ];
}
