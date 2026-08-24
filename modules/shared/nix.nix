{ pkgs, ... }:
{
  nix.package = pkgs.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    interval.day = 7;
    options = "--delete-older-than 14d";
  };
  
  nixpkgs.config.allowUnfree = true;
}