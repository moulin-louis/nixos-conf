{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

      mouse_hide_wait = "3.0";
      click_interval = "0.5";
      mouse_map = "left click ungrabbed no-op";

      # NOTE: Settup Themes
      font_family = "family='FiraCode Nerd Font Mono' postscript_name=FiraCodeNFM-Reg";
      bold_font = "family='FiraCode Nerd Font Mono' postscript_name=FiraCodeNFM-Bold";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "9.5";
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
    };
    themeFile = "tokyo_night_night";
  };
}
