{ ... }:
{
  nixpkgs.config.hardeningSpace = [
    "pie"
    "format"
    "fortify"
    "stackprotector"
    "relro"
    "bindnow"
  ];
}
