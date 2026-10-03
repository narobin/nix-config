{ config, assure, ... }:
{
  options = { };

  config.benchmarks.rules = with assure; [
    {
      rule = "3.4.1";
      name = "DCCP is disabled";
      server.level = 2;
      workstation.level = 2;
      assertion = kernelModuleDisabled "dccp";
    }
    {
      rule = "3.4.2";
      name = "SCTP is disabled";
      server.level = 2;
      workstation.level = 2;
      assertion = kernelModuleDisabled "sctp";
    }
    {
      rule = "3.4.3";
      name = "RDS is disabled";
      server.level = 2;
      workstation.level = 2;
      assertion = kernelModuleDisabled "rds";
    }
    {
      rule = "3.4.4";
      name = "TIPC is disabled";
      server.level = 2;
      workstation.level = 2;
      assertion = kernelModuleDisabled "tipc";
    }
  ];
}
