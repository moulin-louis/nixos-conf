{ pkgs, lib, ... }:

{
  nixpkgs = {
    pkgs = pkgs;
    hostPlatform = "aarch64-darwin";
  };

  # Basic Darwin config
  environment.systemPackages = with pkgs; [
    neovim
    fish
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  programs.fish.enable = true;

  system = {
    configurationRevision = lib.mkDefault null;
    stateVersion = 5;
  };

  users.users.llr = {
    name = "llr";
    home = "/Users/llr";
    shell = pkgs.fish;
  };
}
