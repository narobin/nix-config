{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = { };

  config =
    let
      cfg = config.services.sunshine;
    in
    lib.mkIf cfg.enable {
      programs.sway = {
        enable = true;
        extraSessionCommands = ''
          export WAYLAND_DISPLAY=wayland-headless-1
          export WLR_BACKENDS=headless,libinput
          export WLR_LIBINPUT_NO_DEVICES=1
          export WLR_RENDERER=gles2
          export XDG_CURRENT_DESKTOP=sway
          export XDG_SESSION_TYPE=wayland

          output HEADLESS-1 mode 1920x1080@60Hz

          output * allow_tearing yes max_render_time off

          exec sunshine
        '';
      };

      services.sunshine = {
        settings = {
          sunshine_name = "Imperator Somnium";
          global_prep_cmd = [
            {
              do = "sh -c 'swaymsg \"output HEADLESS-1 mode \${SUNSHINE_CLIENT_WIDTH}x\${SUNSHINE_CLIENT_HEIGHT}@\${SUNSHINE_CLIENT_FPS}Hz\"'";
              undo = "sh -c 'swaymsg \"output HEADLESS-1 mode 1920x1080@60Hz\"'";
            }
          ];
        };
      };
      # TODO: allow access from tailnet only
      # tailscale0
      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
        allowedTCPPorts = [
          47989
          47984
        ];
        allowedUDPPorts = [
          47998
          47999
          47800
        ];
      };
    };
}
