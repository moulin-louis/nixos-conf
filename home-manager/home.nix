{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./tmux.nix
    ./fish.nix
    ./hyprland.nix
  ];

  home = {
    username = "llr";
    homeDirectory = "/home/llr";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.11";

    packages = with pkgs; [
      # Development tools
      git
      vim
      neovim
      gnumake
      binutils
      cmake
      pkg-config
      gdb
      python3
      python312Packages.pip
      nodejs
      corepack_22
      sccache
      eslint_d
      nixpacks

      # System utilities
      wget
      curl
      stow
      unzip
      ripgrep
      xclip
      bat
      eza
      nmap

      # Applications
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      discord
      qbittorrent
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "moulin-louis";
      userEmail = "louis.moulin@outlook.fr";
    };

    firefox = {
      enable = true;
    };

  };

  # Your existing xresources configuration
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
}
