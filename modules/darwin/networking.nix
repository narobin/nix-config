{ pkgs, ... }:
{
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
  };

  # Configure Cloudflare WARP
  environment.etc."Managed Preferences/com.cloudflare.warp.plist".source =
    pkgs.writeText "com.cloudflare.warp.plist" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <!-- DNS-only mode — only DNS queries are routed through Cloudflare -->
          <key>service_mode</key>
          <string>1dot1</string>

          <!-- Auto-reconnect after 1 minute if user toggles off -->
          <key>auto_connect</key>
          <integer>15</integer>
      </dict>
      </plist>

    '';
}
