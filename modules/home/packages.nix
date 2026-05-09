{
  pkgs,
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
      iina
      proton-vpn
      protonmail-desktop

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

      # macOS
      pkg-config
      openssl
      openssl.dev
      pinentry_mac
    ];
}
