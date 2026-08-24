{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
    ripgrep
    uutils-coreutils-noprefix
    xh
    _1password-gui
    _1password-cli
    cloudflare-warp
    rustc
    cargo
  ];
}
