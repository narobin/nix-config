{ ... }:
{
  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "orion"
      "affinity"
      "ungoogled-chromium"
    ];

    masApps = {
      "Reeder" = 6475002485;
      "Things" = 904280696;
      "Mela" = 1568924476;
      "Wireguard" = 1451685025;
    };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
