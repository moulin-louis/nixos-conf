{ pkgs, lib, ... }:
{
  # Basic Darwin config
  environment.systemPackages = with pkgs; [
    neovim
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
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;
  homebrew = {
    enable = true;
    brews = [
      "terraform"
      "terragrunt"
      "scw"
    ];
    casks = [
      "vagrant"
      "virtualbox@beta"
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
