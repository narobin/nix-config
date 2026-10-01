{ config, lib, ... }:
{
  options.benchmarks = {
    enable = lib.mkEnableOption "CIS Benchmark Checks";

    system = lib.mkOption {
      type = lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.enum [
              "server"
              "workstation"
            ];
            default = "workstation";
            description = "The type of system being configured.";
          };
          level = lib.mkOption {
            type = lib.types.enum [
              1
              2
            ];
            default = 1;
            description = "The level of system being configured.";
          };
        };
      };
    };

    rules = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to enable this rule";
            };
            assertion = lib.mkOption {
              type = lib.types.bool;
              description = "The rule definition to be used in the assertion";
            };
            rule = lib.mkOption {
              type = lib.types.str;
              description = "Rule number to be used for logging and documentation";
            };
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the rule to be used for logging and documentation";
            };
            server = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether to enable this rule on servers";
                  };
                  level = lib.mkOption {
                    type = lib.types.enum [
                      1
                      2
                    ];
                    default = 1;
                    description = "Level of server this rule will be enabled on";
                  };
                };
              };
            };
            workstation = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether to enable this rule on workstations";
                  };
                  level = lib.mkOption {
                    type = lib.types.enum [
                      1
                      2
                    ];
                    default = 1;
                    description = "Level of workstation this rule will be enabled on";
                  };
                };
              };
            };
          };
        }
      );
    };
  };

  config =
    let
      cfg = config.benchmarks;
    in
    lib.mkIf cfg.enable {
      assertions =
        map
          (rule: {
            assertion = rule.assertion;
            description = "CIS Benchmarks Rule ${rule.rule} requires: ${rule.name}";
          })
          (
            builtins.filter (
              rule:
              rule.enable
              && (cfg.system.type == "server" -> (rule.server.enable && rule.server.level <= cfg.system.level))
              && (
                cfg.system.type == "workstation"
                -> (rule.workstation.enable && rule.workstation.level <= cfg.system.level)
              )
            ) cfg.rules
          );
    };
}
