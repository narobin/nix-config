{ pkgs, ... }:
{
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

}
