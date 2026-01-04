{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      mac-app-util,
      neovim-nightly-overlay,
nix-index-database,
    }:
    let
      # Systems
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      darwinPkgs = import nixpkgs {
        system = darwinSystem;
      };


      # Common configurations
      commonHomeManagerConfig = {
        home-manager = {
          useGlobalPkgs = true;
	    useUserPackages = true;
          extraSpecialArgs = { inherit neovim-nightly-overlay; };
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
      # NixOS configurations
      nixosConfigurations = {
        "pc-fixe" = mkNixosSystem { hostname = "pc-fixe"; };
        "pc-portable-linux" = mkNixosSystem { hostname = "pc-portable-linux"; };
        "home-vps" = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./home-vps/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.root = import ./home-vps/home-manager/home.nix;
              };
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
	  nix-index-database.darwinModules.nix-index
	  { programs.nix-index-database.comma.enable = true; }
          commonHomeManagerConfig
        ];
      };
    };
}
