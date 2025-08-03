{ pkgs, lib, ... }:
{

  # Basic Darwin config
  environment.systemPackages = with pkgs; [
    fish
    fd
    lazygit
    luajitPackages.luarocks
    lua
    htop
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  };
  nix.settings = {
    trusted-users = [ "llr" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;
  homebrew = {
    enable = true;
    brews = [
      "terraform"
      "terragrunt"
      "scw"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  system = {
    primaryUser = "llr";
    configurationRevision = lib.mkDefault null;
    stateVersion = 5;
  };

  users.users.llr = {
    name = "llr";
    home = "/Users/llr";
    shell = pkgs.fish;
  };
}
