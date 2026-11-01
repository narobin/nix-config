{ config, lib, ... }:
{
  options.services.smart-home = {
    enable = lib.mkEnableOption "smart home";
  };

  config =
    let
      cfg = config.services.smart-home;
    in
    lib.mkIf cfg.enable {
      services.home-assistant = {
        enable = true;
        # openFirewall = true;

        extraComponents = [
          # Components required to complete the onboarding
          "analytics"
          "google_translate"
          "met"
          "radio_browser"
          "shopping_list"
          # Recommended for fast zlib compression
          # https://www.home-assistant.io/integrations/isal
          "isal"
          "mqtt"
        ];

        config = {
          # Includes dependencies for a basic setup
          # https://www.home-assistant.io/integrations/default_config/
          default_config = { };

          # mqtt = {
          #   broker = "127.0.0.1";
          #   port = toString (builtins.head config.services.mosquitto.listeners).port;

          #   sensor = [
          #     {
          #       name = "Water Meter";
          #       state_topic = "rtlamr/${cfg.waterMeterId}/state";
          #       value_template = "{{ value_json.Consumption }}";
          #       unit_of_measurment = "ft³";
          #       device_class = "water";
          #       state_class = "total_increasing";
          #     }
          #   ];
          # };
        };
      };
    };
}
