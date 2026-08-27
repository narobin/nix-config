{ ... }:
{
  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "orion"
      "affinity"
    ];

    masApps = {
      "Reeder"  = 6475002485;
      "Things"  = 904280696;
      "Mela"	= 1568924476;
    };

    onActivation.cleanup = "zap";

    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
