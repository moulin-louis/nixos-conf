{
  nixpkgs,
  home-manager,
  nix-darwin,
  mac-app-util,
  nix-index-database,
  neovim-nightly-overlay,
}:
let
  # Systems
  darwinSystem = "aarch64-darwin";
  linuxSystem = "x86_64-linux";

  # Common home-manager configuration shared across all systems
  mkCommonHomeManagerConfig =
    {
      user ? "llr",
    }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit neovim-nightly-overlay; };
        users.${user} = import ../modules/home;
      };
    };

  # NixOS system builder
  mkNixosSystem =
    {
      hostname,
      user ? "llr",
    }:
    nixpkgs.lib.nixosSystem {
      system = linuxSystem;
      modules = [
        ../hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager
        (mkCommonHomeManagerConfig { inherit user; })
      ];
    };

  # Standalone home-manager builder (for non-NixOS Linux, e.g., Ubuntu with nix daemon)
  mkHomeConfiguration =
    {
      system ? linuxSystem,
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit neovim-nightly-overlay; };
      modules = [
        ../modules/home
        nix-index-database.homeModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    };

  # Darwin system builder
  mkDarwinSystem =
    {
      hostname,
      user ? "llr",
    }:
    let
      darwinPkgs = import nixpkgs { system = darwinSystem; };
    in
    nix-darwin.lib.darwinSystem {
      system = darwinSystem;
      modules = [
        {
          nixpkgs.hostPlatform = darwinSystem;
          nixpkgs.pkgs = darwinPkgs;
        }
        ../hosts/${hostname}/configuration.nix
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        nix-index-database.darwinModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        (mkCommonHomeManagerConfig { inherit user; })
        {
          home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
        }
      ];
    };
in
{
  inherit
    darwinSystem
    linuxSystem
    mkNixosSystem
    mkDarwinSystem
    mkHomeConfiguration
    mkCommonHomeManagerConfig
    ;
}
