{ config, lib, ... }:
{
  options.services.smart-home = {
    enableMQTT = lib.mkEnableOption "MQTT";
  };

  config =
    let
      cfg = config.services.smart-home;
    in
    lib.mkIf cfg.enableMQTT {
      services.mosquitto = {
        enable = true;
        listeners = [
          {
            address = "0.0.0.0";
            acl = [ "pattern readwrite #" ];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [ 1883 ];
    };
}
