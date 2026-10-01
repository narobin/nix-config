{
  config,
  lib,
  options,
  ...
}:
{
  options = { };

  config.benchmarks.rules = [
    # 1.7.1 Command Line Warning Banners
    {
      rule = "1.7.1.1";
      name = "message of the day is configured properly";
      assertion = options.users.motd.isDefined || options.users.motdFile.isDefined;
    }
    {
      rule = "1.7.1.2";
      name = "local login warning banner is configured properly";
      assertion = options.services.getty.greetingLine.isDefined;
    }
    {
      rule = "1.7.1.3";
      name = "remote login warning banner is configured properly";
      assertion = config.services.openssh.settings.Banner != null;
    }
    # 1.7.1.4 Ensure permissions on /etc/motd are configured
    # 1.7.1.5 Ensure permissions on /etc/issue are configured
    # 1.7.1.6 Ensure permissions on /etc/issue.net are configured
    {
      rule = "1.7.2";
      name = "GDM login banner is configured";
      assertion =
        config.services.displayManager.gdm.enable -> options.services.displayManager.gdm.banner.isDefined;
    }
  ];
}
