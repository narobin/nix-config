{
  config,
  pkgs,
  lib,
  ...
}:
{
  # TODO: install some packages contingent on it being a GUI machine
  environment.systemPackages =
    with pkgs;
    [

    ]
    ++ lib.optionals config.mySystem.enableGui [
      wl-clipboard
    ];
}
