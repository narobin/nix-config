{ ... }:
{
  homebrew = {
    enable = true;

    brews = [
      "mas"
      "mole"
    ];

    casks = [
      "affinity"
      "ungoogled-chromium"
      "logi-options+"
      "zen"
      "onedrive"
      "moonlight"
    ];

    masApps = {
      "Reeder" = 6475002485;
      "Things" = 904280696;
      "Mela" = 1568924476;
      "Numbers" = 361304891;
      "PowerPoint" = 462062816;
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
