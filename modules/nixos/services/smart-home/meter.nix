{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.smart-home = {
    enableMetering = lib.mkEnableOption "water meter";
    waterMeterId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    energyMeterId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config =
    let
      cfg = config.services.smart-home;
      yamlFormat = pkgs.formats.yaml { };
      rtlamrConfig = {
        mqtt = {
          host = "10.88.0.1";
          port = (builtins.head config.services.mosquitto.listeners).port;
          ha_autodiscovery = true;
        };
        meters = [
          {
            id = cfg.waterMeterId;
            name = "Water Meter";
            protocol = "r900";
            unit_of_measurement = "ft³";
            icon = "mdi:water";
            format = "######.##";
            state_class = "total_increasing";
            device_class = "water";
          }
          {
            id = cfg.energyMeterId;
            protocol = "scm";
            name = "Electric Meter";
            device_class = "energy";
            unit_of_measurement = "kWh";
            state_class = "total_increasing";
            icon = "mdi:transmission-tower";
          }
        ];
      };
    in
    lib.mkIf cfg.enableMetering {
      assertions = [
        {
          assertion = cfg.waterMeterId != null;
          message = "water meter ID must be set when water metering is enabled";
        }
      ];

      hardware.rtl-sdr.enable = true;

      environment.etc."rtlamr2mqtt.yaml".source = yamlFormat.generate "rtlamr2mqtt.yaml" rtlamrConfig;

      virtualisation.oci-containers.containers."rtlamr2mqtt" = {
        image = "docker.io/allangood/rtlamr2mqtt:latest";
        volumes = [
          "/etc/rtlamr2mqtt.yaml:/etc/rtlamr2mqtt.yaml"
        ];
        # Pass the USB RTL-SDR dongle into the container
        extraOptions = [
          "--device=/dev/bus/usb"
        ];
      };

      networking.firewall.extraInputRules = ''
        iifname "podman0" tcp dport 1883 accept
      '';
    };
}
