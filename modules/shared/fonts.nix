{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    inter
    atkinson-hyperlegible
    fira-code
    et-book
    source-serif
    source-sans
    (iosevka-bin.override { variant = "Aile"; })
    (iosevka-bin.override { variant = "Etoile"; })
  ];
}
