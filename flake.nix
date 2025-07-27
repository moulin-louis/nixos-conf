{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      nix-darwin,
      mac-app-util,
    }:
    let
      # Systems
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      darwinPkgs = import nixpkgs {
        system = darwinSystem;
      };

      linuxPkgs = import nixpkgs {
        system = linuxSystem;
      };

      # Formatters
      mkFormatter = pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      # Common configurations
      commonHomeManagerConfig = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.llr = import ./home-manager/home.nix;
        };
      };

      # NixOS system builder
      mkNixosSystem =
        { hostname }:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            commonHomeManagerConfig
          ];
        };
    in
    {
      formatter = {
        ${linuxSystem} = (mkFormatter linuxPkgs).config.build.wrapper;
        ${darwinSystem} = (mkFormatter darwinPkgs).config.build.wrapper;
      };

      # NixOS configurations
      nixosConfigurations = {
        "pc-fixe" = mkNixosSystem { hostname = "pc-fixe"; };
        "pc-portable-linux" = mkNixosSystem { hostname = "pc-portable-linux"; };
	"home-vps" = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./home-vps/configuration.nix
            home-manager.nixosModules.home-manager
	    home-manager = {
		  useGlobalPkgs = true;
		  useUserPackages = true;
		  users.llr = import ./home-manager/home.nix;
		}
          ];
        };
      };

      # Darwin configuration
      darwinConfigurations."MacBook-Pro-de-Louis" = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          {
            nixpkgs.hostPlatform = darwinSystem;
            nixpkgs.pkgs = darwinPkgs;
          }
          ./darwin/configuration.nix
          mac-app-util.darwinModules.default
          # Home Manager module
          home-manager.darwinModules.home-manager
          commonHomeManagerConfig
        ];
      };
    };
}
