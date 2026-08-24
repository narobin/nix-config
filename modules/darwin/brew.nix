{ ... }:
{
  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "orion"
      "zen"
      "affinity"
    ];

    masApps = {
      "Reeder"  = 6475002485;
      "Things"  = 904237743;
    };

    onActivation.cleanup = "zap";

    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
