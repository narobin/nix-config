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
      wayvncConfig = pkgs.writeText "wayvnc-headless.conf" ''
        address=0.0.0.0
        port=5900
        enable_auth=true
        enable_pam=true
        certificate_file=/home/${cfg.user}/.local/state/wayvnc/tls_cert.pem
        private_key_file=/home/${cfg.user}/.local/state/wayvnc/tls_key.pem
        rsa_private_key_file=/home/${cfg.user}/.local/state/wayvnc/rsa_key.pem
      '';
      labwcConfigDir = pkgs.writeTextDir "menu.xml" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <openbox_menu>
          <menu id="root-menu" label="Headless CAD">
            <item label="Terminal (Ghostty)">
              <action name="Execute" command="ghostty --gtk-single-instance=false" />
            </item>
            <item label="Exit Remote Session">
              <action name="Exit" />
            </item>
          </menu>
        </openbox_menu>
      '';
      initKeys = pkgs.writeShellScript "wayvnc-init-keys" ''
        set -euo pipefail
        state_dir="$HOME/.local/state/wayvnc"
        mkdir -p "$state_dir"
        chmod 700 "$state_dir"

        if [ ! -f "$state_dir/tls_key.pem" ] || [ ! -f "$state_dir/tls_cert.pem" ]; then
          ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
            -keyout "$state_dir/tls_key.pem" \
            -out "$state_dir/tls_cert.pem" \
            -subj "/CN=nixos-headless" \
            -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
          chmod 600 "$state_dir/tls_key.pem"
        fi

        # -traditional forces PKCS#1 (BEGIN RSA PRIVATE KEY), required by wayvnc/nettle
        if [ ! -f "$state_dir/rsa_key.pem" ] || grep -q "BEGIN PRIVATE KEY" "$state_dir/rsa_key.pem"; then
          ${pkgs.openssl}/bin/openssl genrsa -traditional -out "$state_dir/rsa_key.pem" 2048
          chmod 600 "$state_dir/rsa_key.pem"
        fi
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

      security.pam.services.wayvnc = { };

      users.users.${cfg.user} = {
        linger = true;
        extraGroups = [
          "video"
          "render"
        ];
      };

      networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5900 ];

      systemd.user.services.remote-desktop = {
        description = "Headless Wayland compositor";
        path = with pkgs; [
          labwc
          wayvnc
          "/run/current-system/sw"
          "/etc/profiles/per-user/${cfg.user}"
          "/run/wrappers"
        ];
        environment = {
          WLR_BACKENDS = "headless";
          WLR_LIBINPUT_NO_DEVICES = "1";
          WLR_RENDER_DRM_DEVICE = "/dev/dri/renderD128";

          # Allow NVIDIA's proprietary blobs and Vulkan loader to dlopen /run/opengl-driver
          LD_LIBRARY_PATH = "/run/opengl-driver/lib";
          XDG_DATA_DIRS = "/run/opengl-driver/share:/run/current-system/sw/share:/etc/profiles/per-user/${cfg.user}/share";

          GBM_BACKEND = "nvidia-drm";
          GBM_BACKENDS_PATH = "/run/opengl-driver/lib/gbm";
          __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          WLR_NO_HARDWARE_CURSORS = "1";
        };
        serviceConfig = {
          Type = "simple";
          # Prevent inheriting local Niri's WAYLAND_DISPLAY socket
          UnsetEnvironment = [
            "WAYLAND_DISPLAY"
            "DISPLAY"
          ];
          ExecStartPre = "${initKeys}";
          # -S ties labwc's lifetime to wayvnc; -C points both to /nix/store configs
          ExecStart = ''
            ${pkgs.labwc}/bin/labwc -C ${labwcConfigDir} \
              -S "${pkgs.wayvnc}/bin/wayvnc -C ${wayvncConfig} -S %t/wayvncctl-headless"
          '';
          Restart = "no";
        };
      };
    };
}
