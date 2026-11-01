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
