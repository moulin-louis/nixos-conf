{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./kitty.nix
    ./gnome.nix
  ];

  home = {
    username = "llr";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/llr" else "/home/llr";
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
  };
}
