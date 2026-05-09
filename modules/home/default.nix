{ ... }:
{
  imports = [
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./kitty.nix
  ];

  home = {
    username = "llr";
    homeDirectory = "/Users/llr";
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    man.enable = false;
    man.generateCaches = false;
  };
}
