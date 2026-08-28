{ pkgs, ... }:
{
  programs.chromium = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
    package = pkgs.ungoogled-chromium;
    extensions = [
      # Obsidian Web Clipper (official, from Chrome Web Store)
      { id = "cnjifjpddelmedmihgijeibhnjfabmlf"; }
  
      # 1Password (from Chrome Web Store)
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; }
  
      # uBlock Origin (unofficial CRX build, not from Chrome Web Store)
      {
        id = "blockjmkbacgjkknlgpkjjiijinjdanf";
        updateUrl = "https://raw.githubusercontent.com/imputnet/ublock-origin-crx/refs/heads/main/update.xml";
      }
    ]
    ;
  };
}