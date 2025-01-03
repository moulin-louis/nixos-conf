{ config, pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./fish.nix
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
      python3
      python312Packages.pip
      nodejs
      corepack_22
      sccache
      eslint_d
      nixpacks
      gnumake
      taplo # toml formatter
      typescript-language-server

      # System utilities
      wget
      curl
      unzip
      ripgrep
      xclip
      bat
      eza
      zoxide
      fzf
      nmap
      pre-commit
      cabal-install # pre-commit deps
      ghc # pre-commit deps

      # Applications
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      discord
      qbittorrent
      protonmail-desktop
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

  };

  programs = {
    home-manager.enable = true;
    nix-index = {
      enable = true;
    };
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
