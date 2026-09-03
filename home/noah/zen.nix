{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # TODO: set up spaces and profiles
    # TODO: set up extensions
  };
}
