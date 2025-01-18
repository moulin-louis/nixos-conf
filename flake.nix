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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      nix-darwin,
    }:
    let
      # Systems
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      # Packages
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};

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
        "pc-portable" = mkNixosSystem { hostname = "pc-portable"; };
      };

      # Darwin configuration
      darwinConfigurations."MacBook-Pro-de-Louis" = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          {
            nixpkgs = {
              pkgs = darwinPkgs;
              hostPlatform = darwinSystem;
            };

            # Basic Darwin config
            environment.systemPackages = with darwinPkgs; [
              neovim
              fish
            ];

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
            programs.fish.enable = true;

            system = {
              configurationRevision = self.rev or self.dirtyRev or null;
              stateVersion = 5;
            };

            users.users.llr = {
              name = "llr";
              home = "/Users/llr";
              shell = darwinPkgs.fish;
            };
          }

          # Home Manager module
          home-manager.darwinModules.home-manager
          commonHomeManagerConfig
        ];
      };
    };
}
