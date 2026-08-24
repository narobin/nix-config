{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Noah Robinson";
        email = "noah@narobin.com";
      };
      push.autoSetupRemote = true;
    };

    # TODO: set up signing
  };
}
