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
      git
      neovim
      ripgrep
      uutils-coreutils-noprefix
      xh
      rustc
      cargo
      moor
      github-cli
      rsync
      ouch
    ]
    ++ lib.optionals config.mySystem.enableGui [
    ];
}
