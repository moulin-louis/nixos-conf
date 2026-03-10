{
  pkgs,
  lib,
  neovim-nightly-overlay,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # Editors
      neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
      openvpn
      libfido2
      openssh
      mold

      lua
      tree-sitter

      # DevOps & Kubernetes
      nixfmt
      kind
      kubecolor

      # Cloud
      scaleway-cli # scw

      # CLI utilities
      wget
      curl
      unzip
      ripgrep
      bat
      eza
      zoxide
      fzf
      fd
      dive
      dust
      lazygit
      difftastic
      htop

      # System tools
      nmap
      gnupg

      # Misc
      cargo-binstall
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
