{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./fish.nix
  ];
  home = {
    username = "root";
    homeDirectory = "/home/root";
    stateVersion = "24.11";
    packages =
      with pkgs;
      [
        # Development tools
        git
        vim
        neovim
        python3
        python312Packages.pip
        nodejs
        corepack_22
        sccache
        eslint_d
        nixpacks
        taplo
        typescript-language-server
        # System utilities
        wget
        curl
        unzip
        ripgrep
        bat
        eza
        zoxide
        fzf
        cargo-binstall
        nixfmt-rfc-style
        transmission_4-qt6
        nmap
       ]
      );
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    git = {
      enable = true;
      userName = "moulin-louis";
      userEmail = "louis.moulin@outlook.fr";
    };
  };
}
