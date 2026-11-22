{ ... }:
{
  nixpkgs.config.hardeningSpace = [
    "pie"
    "format"
    "fortify"
    "stackprotector"
    "relro"
    "bindnow"
  ];

  nix = {
    enable = true;

    gc = {
      automatic = true;
      dates = [ "02:15" ];
      randomizedDelaySec = "15min";
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };
}
