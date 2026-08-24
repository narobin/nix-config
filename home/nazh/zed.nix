{ ... }:
{
  programs.zed-editor = {
    enable = true;
    defaultEditor = true;
    extensions = [
      "html"
      "nix"
    ];
    userSettings = {
      auto_update = false;
      diff_view_style = "split";
      cli_default_open_behavior = "new_window";
      ensure_final_newline_on_save = true;
      format_on_save = "modifications";
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
        anthropic_retention = false;
      };
      ui_font_size = 16;
      buffer_font-size = 16;
      theme = {
        mode = "system";
        light = "Gruvbox Light";
        dark = "Gruvbox Dark";
      };
    };
  };
}
