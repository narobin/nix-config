{ pkgs, ... }:
{
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet"
          + " --time"
          + " --time-format '%Y-%m-%d %H:%M'"
          + " --remember"
          + " --remember-session"
          + " --asterisks"
          + " --cmd niri-session";
        user = "greeter";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    niri-session
    fish
    zsh
  '';

  systemd.services.greetd.serviceConfig.Type = "idle";

  systemd.user.services.niri.enableDefaultPath = false;
}
