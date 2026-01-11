{ pkgs, lib, neovim-nightly-overlay, ... }:
{
  home.packages = with pkgs; [
    # Editors
    vim
    neovim-nightly-overlay.packages.${pkgs.system}.default

    # Languages & runtimes
    python3
    python312Packages.pip
    nodejs
    corepack_22

    # Build tools
    sccache
    bison

    # Language servers & linters
    nil
    eslint_d
    taplo
    typescript-language-server

    # DevOps
    nixpacks
    nixfmt

    # CLI utilities
    wget
    curl
    unzip
    ripgrep
    bat
    eza
    zoxide
    fzf

    # System tools
    nmap
    gnupg

    # Misc
    cargo-binstall
    transmission_4-qt6
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    xclip
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkg-config
    openssl
    openssl.dev
    pinentry_mac
  ];
}
