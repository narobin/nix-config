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
      cloudflare-warp
      rustc
      cargo
      moor
      github-cli
    ]
    ++ lib.optionals config.mySystem.enableGui [
    ];
}
