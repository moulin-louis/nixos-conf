{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./tmux.nix
    ./fish.nix
    ./hyprland.nix
    ./gnome.nix
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
       gnumake
      binutils
      pkg-config
      udev
      protobuf
      openssl.dev

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
      whatsapp-for-linux
      transmission_4-qt6
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

  };

  programs = {
    home-manager.enable = true;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    command-not-found.enable = false;
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
