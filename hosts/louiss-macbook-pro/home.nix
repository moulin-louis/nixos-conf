{
  pkgs,
  lib,
  neovim-nightly-overlay,
  ...
}:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/fish.nix
    ../../modules/home/kitty.nix
    ../../modules/home/gnome.nix
  ];

  home = {
    username = "llr";
    homeDirectory = "/Users/llr";
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      # Editor
      neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Rust
      rustup
      cargo-binstall

      # Python
      uv

      # JS / Vue
      nodejs

      # Build deps
      pkg-config
      openssl
      openssl.dev
      sqlite

      # Tree-sitter (used by neovim)
      tree-sitter

      # CLI essentials
      wget
      curl
      unzip
      ripgrep
      bat
      eza
      zoxide
      fzf
      fd
      lazygit
      delta
      difftastic
      htop

      # macOS
      pinentry_mac
    ];
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
  };

  # Override the rebuild function to target this host
  programs.fish.functions.rebuild = lib.mkForce {
    body = ''
      darwin-rebuild switch --flake $HOME/nixos-conf/#Louiss-MacBook-Pro
    '';
  };
}
