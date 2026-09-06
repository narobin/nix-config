{ pkgs, ... }:
{
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
      show-recents = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };

  };
}