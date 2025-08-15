{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix.settings = {
    trusted-users = [ "root" ];
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
    download-buffer-size = 524288000;
  };

  # here, NOT in environment.systemPackages
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core system libraries
    stdenv.cc.cc.lib
    glibc

    # SSL/TLS and networking
    openssl
    curl

    # Media libraries (for Jellyfin)
    ffmpeg
    libva
    libvdpau

    # Container runtime dependencies (for k3s)
    iptables

    # Common dynamic libraries
    zlib
    libxml2
    libxslt
    ncurses
    readline

    # Hardware acceleration (if applicable)
    mesa
    vulkan-loader

    # Networking utilities
    libnl
    libpcap
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home-vps";

  time.timeZone = "Europe/Paris";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.qbittorrent = {
    enable = true;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Username = "admin";
          Password_PBKDF2 = "+aMTPThHOFREgpfyYxCPHA==:TcM+I3psI/GhR8NuYUR6H/diYIBs+XzsGGb55dsx9o1MbSPkyvUBJ0zDHdWHlfy+82jQ4+MSHVBBnyOSz70zww==";
          BanDuration = 3600;
          MaxAuthenticationFailCount = 5;
          SecureCookie = true;
          Address = "100.105.249.93";
        };
        General = {
          Locale = "en";
        };
        Downloads = {
          SavePath = "/media/EHDD";
          TempPath = "/media/EHDD/incomplete/";

        };
      };
    };
    extraArgs = [
      "--confirm-legal-notice"
    ];
  };
  systemd.tmpfiles.rules = [
    "d /media/EHDD/downloads 0755 qbittorrent qbittorrent - -"
    "d /media/EHDD/incomplete 0755 qbittorrent qbittorrent - -"
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    neovim
    git
    gcc
    certbot
    kitty
  ];

  services.tailscale.enable = true;
  systemd.services.tailscaled.environment = {
    TS_PERMIT_CERT_UID = "caddy";
  };

  services.openssh = {
    enable = true;

    # Only listen on Tailscale interface
    listenAddresses = [
      {
        addr = "100.105.249.93";
        port = 22;
      }
    ];

    settings = {
      # Disable password authentication
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      # Only allow pubkey auth
      PubkeyAuthentication = true;
    };
  };
  systemd.services.sshd = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig = {
      # Restart SSH if it fails to bind (when Tailscale isn't ready)
      Restart = lib.mkForce "on-failure";
      RestartSec = "5s";
    };
  };
  services.fail2ban.enable = true;

  services.jellyfin = {
    enable = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."home-vps.ilish-mohs.ts.net" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8096
        header X-Reverse-By "Caddy"
      '';

    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "louis.moulin@outlook.fr";
  };

  networking.nftables.enable = true;
  # Configure firewall rules
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];

    allowedTCPPorts = [
      6443
      80
      443
    ];
    allowedUDPPorts = [
      443
      80
      8472
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;
  programs.fish.enable = true;
  documentation.man.generateCaches = false;
  users.users.root.shell = pkgs.fish;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
