{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.services.remote-desktop = {
    enable = lib.mkEnableOption "remote-desktop";
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config =
    let
      cfg = config.services.remote-desktop;
      sunshinePrepCmd = pkgs.writeShellScript "sunshine-prep" ''
        exec ${pkgs.wlr-randr}/bin/wlr-randr \
          --output HEADLESS-1 \
          --custom-mode "''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS}Hz" \
          --scale 2
      '';

      sunshineConf = pkgs.writeText "sunshine-headless.conf" ''
        capture = wlr
        encoder = nvenc
        adapter_name = /dev/dri/renderD128
        origin_web_ui_allowed = pc
        upnp = disabled
        system_tray = disabled
        global_prep_cmd = [{"do":"${sunshinePrepCmd}","undo":""}]
      '';

      # Creates /nix/store/<hash>-menu.xml/menu.xml and evaluates to the parent directory
      labwcConfigDir = pkgs.linkFarm "labwc-headless-config" {
        "rc.xml" = pkgs.writeText "rc.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <labwc_config>
            <libinput>
              <device category="default">
                <sendEventsMode>no</sendEventsMode>
              </device>
              <device category="libvirtualhid Keyboard">
                <sendEventsMode>yes</sendEventsMode>
              </device>
              <device category="libvirtualhid Mouse">
                <sendEventsMode>yes</sendEventsMode>
              </device>
              <device category="libvirtualhid Mouse (Absolute)">
                <sendEventsMode>yes</sendEventsMode>
              </device>
              <device category="libvirtualhid Touchscreen">
                <sendEventsMode>yes</sendEventsMode>
              </device>
              <device category="libvirtualhid Pen Tablet">
                <sendEventsMode>yes</sendEventsMode>
              </device>
            </libinput>
          </labwc_config>
        '';
        "menu.xml" = pkgs.writeText "menu.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <openbox_menu>
            <menu id="root-menu" label="Headless CAD">
              <item label="Terminal (Ghostty)">
                <action name="Execute" command="${pkgs.ghostty}/bin/ghostty --gtk-single-instance=false" />
              </item>
              <item label="Exit Remote Session">
                <action name="Exit" />
              </item>
            </menu>
          </openbox_menu>
        '';
      };

      labwcStartup = pkgs.writeShellScript "labwc-headless-startup" ''
        ${pkgs.wlr-randr}/bin/wlr-randr --output HEADLESS-1 --custom-mode 2560x1600@60Hz --scale 2 &
        ${pkgs.swaybg}/bin/swaybg -c '#243b55' &
        exec ${pkgs.sunshine}/bin/sunshine ${sunshineConf}
      '';
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.user != null;
          message = "services.remote-desktop.user must be set when remote-desktop is enabled";
        }
        {
          assertion = config.hardware.graphics.enable;
          message = "graphics must be enabled when remote-desktop is enabled";
        }
      ];

      programs.labwc.enable = true;

      hardware.uinput.enable = true;

      users.users.${cfg.user} = {
        linger = true;
        extraGroups = [
          "video"
          "render"
          "uinput"
          "input"
        ];
      };

      networking.firewall.interfaces."tailscale0" = {
        allowedTCPPortRanges = [
          {
            from = 47984;
            to = 47990;
          }
        ];
        allowedUDPPorts = [
          47998
          47999
          48000
          48002
          48010
        ];
      };

      systemd.user.services.headless-cad = {
        description = "Headless Wayland Compositor (labwc + Sunshine)";
        path = with pkgs; [
          labwc
          sunshine
          wlr-randr
          "/run/current-system/sw"
          "/etc/profiles/per-user/${cfg.user}"
          "/run/wrappers"
        ];

        environment = {
          WLR_BACKENDS = "headless,libinput";
          WLR_LIBINPUT_NO_DEVICES = "1";
          WLR_RENDER_DRM_DEVICE = "/dev/dri/renderD128";
          LIBSEAT_BACKEND = "noop";

          # Expose NVIDIA /run/opengl-driver for NVENC encoding and 3D CAD OpenGL/Vulkan
          LD_LIBRARY_PATH = "/run/opengl-driver/lib";
          XDG_DATA_DIRS = "/run/opengl-driver/share:/run/current-system/sw/share:/etc/profiles/per-user/${cfg.user}/share";
          __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.labwc}/bin/labwc -C ${labwcConfigDir} -s ${labwcStartup}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
}
