
{ config, pkgs, ... }:
{
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";
  nix.settings = {
    trusted-users = [ "llr" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # Bootloader
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "pc-fixe";
    networkmanager.enable = true;
  };

  # Time and Locale
  time = {
    timeZone = "Europe/Paris";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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

  };

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

  # System-wide services
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [ "llr" ];

      # Restrict key exchange, cipher, and MAC algorithms
      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];

      # Additional security settings
      X11Forwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
      PermitEmptyPasswords = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };
  services.fail2ban.enable = true;
  programs = {
    nix-ld.enable = true;
    dconf.enable = true;
    ccache.enable = true;
    fish.enable = true;
  };
  virtualisation.docker.enable = true;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "llr";
  };

  services.transmission = {
    enable = true; # Enable transmission daemon
    openRPCPort = true; # Open firewall for RPC
    settings = {
      # Override default settings
      rpc-bind-address = "0.0.0.0"; # Bind to own IP
      rpc-whitelist = "*.*.*.*";
      rpc-username = "llr";
      rpc-password = "v7MHua6!LKdT6u0m";
      rpc-authentication-required = true;
      download-dir = "/srv/EHDD/";
      incomplete-dir = "/srv/EHDD/incomplete/";
      incomplete-dir-enabled = true;
    };
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
  ];

  documentation.man.generateCaches = false;
  # System-wide fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  # User configuration
  users.users.llr = {
    isNormalUser = true;
    description = "llr";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "transmission"
    ];
    shell = pkgs.fish;
  };
}
  imports = [
    ./hardware-configuration-nixos-fixe.nix
  ];

  system.stateVersion = "24.11";
  nix.settings = {
    trusted-users = [ "llr" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # Bootloader
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "nixos-fixe";
    networkmanager.enable = true;
  };

  # Time and Locale
  time = {
    timeZone = "Europe/Paris";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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

  };

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

  # System-wide services
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [ "llr" ];

      # Restrict key exchange, cipher, and MAC algorithms
      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];

      # Additional security settings
      X11Forwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
      PermitEmptyPasswords = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };
  services.fail2ban.enable = true;
  programs = {
    nix-ld.enable = true;
    dconf.enable = true;
    ccache.enable = true;
    fish.enable = true;
  };
  virtualisation.docker.enable = true;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "llr";
  };

  services.transmission = {
    enable = true; # Enable transmission daemon
    openRPCPort = true; # Open firewall for RPC
    settings = {
      # Override default settings
      rpc-bind-address = "0.0.0.0"; # Bind to own IP
      rpc-whitelist = "*.*.*.*";
      rpc-username = "llr";
      rpc-password = "v7MHua6!LKdT6u0m";
      rpc-authentication-required = true;
      download-dir = "/srv/EHDD/";
      incomplete-dir = "/srv/EHDD/incomplete/";
      incomplete-dir-enabled = true;
    };
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
  ];

  documentation.man.generateCaches = false;
  # System-wide fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  # User configuration
  users.users.llr = {
    isNormalUser = true;
    description = "llr";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "transmission"
    ];
    shell = pkgs.fish;
  };
}
