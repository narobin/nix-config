{
  config,
  lib,
  options,
  ...
}:
{
  options = { };

  config.benchmarks.rules = [
    {
      rule = "1.2.1";
      name = "package manager repositories are configured";
      # does this do the right thing?
      assertion = options.nix.registry.isDefined;
    }
    # 1.2.2 Ensure GPG keys are configured
    # unsure how to implement
  ];
}
