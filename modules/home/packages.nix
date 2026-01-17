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

      # Languages & runtimes
      uv
      rustup
      go
      gotools # goimports
      lua
      luajitPackages.luarocks
      tree-sitter

      # DevOps & Kubernetes
      nixfmt
      kind
      ko
      kustomize
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
      delta
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
