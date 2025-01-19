{ pkgs, lib, ... }:
{
  # Basic Darwin config
  environment.systemPackages = with pkgs; [
    neovim
    fish
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
  security.pam.enableSudoTouchIdAuth = true;

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
