{ mySystem, ... }:
{
  programs.zed-editor = {
    enable = mySystem.enableGui;
    extensions = [
      "html"
      "nix"
      "kdl"
    ];

    mutableUserSettings = false;
    mutableUserKeymaps = false;

    userSettings = {
      auto_update = false;
      diff_view_style = "split";
      cli_default_open_behavior = "new_window";
      ensure_final_newline_on_save = true;
      format_on_save = "on";
      autosave = {
        after_delay.milliseconds = 1000;
      };
      project_panel = {
        dock = "left";
      };
      disable_ai = true;
      base_keymap = "VSCode";
      vim_mode = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      ui_font_size = 16;
      theme = {
        mode = "system";
        light = "Gruvbox Light";
        dark = "Gruvbox Dark";
      };
    };
    userKeymaps = [
      {
        unbind = {
          "cmd-o" = "workspace::Open";
        };
      }
      {
        context = "Workspace";
        bindings = {
          "cmd-o" = "file_finder::Toggle";
          "cmd-p" = "command_palette::Toggle";
        };
      }
    ];
  };
}
