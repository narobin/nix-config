{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.garage = {

  };

  config =
    let
      cfg = config.services.garage;
    in
    lib.mkIf cfg.enable {
      services.garage = {
        package = pkgs.garage_2;
        settings = {
          metadata_dir = "/data/garage/meta";
          data_dir = "/data/garage/data";
          db_engine = "sqlite";

          rpc_bind_addr = "[::]:3901";
          rpc_public_addr = "127.0.0.1:3901";
          rpc_secret = "$(openssl rand -hex 32)";

          replication_factor = 1;

          s3_api = {
            s3_region = "garage";
            api_bind_addr = "[::]:3900";
          };
        };
      };
    };
}
