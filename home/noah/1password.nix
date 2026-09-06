{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."1Password/ssh/agent.toml".source = tomlFormat.generate "agent.toml" {
    ssh-keys = [
      { account = "Robinson"; }
    ];
  };
}
