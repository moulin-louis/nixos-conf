{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      enabled_layouts = "splits";
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      mouse_hide_wait = "3.0";
      click_interval = "0.5";
      mouse_map = "left click ungrabbed no-op";

      # Terminal behavior
      close_on_child_death = "yes";
      allow_remote_control = "yes";

      # NOTE: Settup Themes
      font_family = "FiraCode Nerd Font Mono";
      bold_font = "FiraCode Nerd Font Mono Bold";
      bold_italic_font = "FiraCode Nerd Font Mono Bold Italic";
      font_size = "9.5";
    };
    keybindings = {
      #Tabs Navigation
      "ctrl+shift+n" = "next_tab";

      # Windows splits
      "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+backslash" = "launch --location=split --cwd=current";

      # Windows navigation
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";

      # Windows Resize
      "ctrl+shift+alt+left" = "resize_window narrower";
      "ctrl+shift+alt+right" = "resize_window wider";
      "ctrl+shift+alt+up" = "resize_window taller";
      "ctrl+shift+alt+down" = "resize_window shorter";
    };
    themeFile = "Catppuccin-Mocha";
  };
}
