{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
  };

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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
jellyfin
jellyfin-web
jellyfin-ffmpeg
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nvim
    git
  #   wget
  ];

   services.tailscale.enable = true;

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
    openFirewall = true;
  };

  services.k3s = {
    enable = true;
    role = "agent";
    token = "K10dc4cbd3ee96a2df365c61ed95c6b050b709325d767d53b720e9cd31e5914c959::server:e801431581bef44cfa6a838c1b1fe7dd";
    serverAddr = "https://100.77.251.72:6443";
    extraFlags = toString [
      "--flannel-iface=tailscale0"
    ];
  };

  networking.nftables.enable = true;
  # Configure firewall rules
  networking.firewall = {
    enable = true;
    
    # Or use the allowedTCPPorts with interface-specific rules
    allowedTCPPorts = [ 6443 ];
    allowedUDPPorts = [ 8472 ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

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


