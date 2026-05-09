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

      # Apps
      iina
      proton-vpn
      protonmail-desktop

      # DevOps & Kubernetes
      nixfmt
      kubecolor

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
      lazygit
      difftastic
      htop

      # System tools
      gnupg

      # Misc
      cargo-binstall

      # macOS
      pinentry_mac
    ];
}
