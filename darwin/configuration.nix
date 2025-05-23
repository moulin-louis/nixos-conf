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
      "telegram"
      "minikube"
    ];
  };

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
