{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    trusted-users = [ "llr" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.nix-ld.enable = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  

  # Time and Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # System-wide fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # X11 and Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [ "nvidia" ];
  };
  services.libinput.mouse = {
    accelProfile = "flat";
  };

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # NVIDIA
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # User configuration
  users.users.llr = {
    isNormalUser = true;
    description = "llr";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  # System-wide services
  programs.ccache = {
    enable = true;
  };
  programs.fish.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
  virtualisation.docker.enable = true;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "llr";
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gcc
    clang
    egl-wayland
  ];

  system.stateVersion = "24.11";
}
