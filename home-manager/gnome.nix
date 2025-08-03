{ pkgs, lib, ... }:
{

  dconf.settings = lib.mkIf pkgs.stdenv.isDarwin {

    "org/gnome/desktop/interface" = {
      enable-animations = false;
      enable-hot-corners = false;
      show-battery-percentage = true;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profil = "flat";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      click-method = "areas";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      workspaces-only-on-primary = false;
      edge-tiling = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      nigh-light-enabled = true;
      nigh-light-schedule-automic = false;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

  };

}
