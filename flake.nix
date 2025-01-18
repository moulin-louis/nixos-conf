{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, treefmt-nix, nix-darwin }:
    let
      darwinSystem = "aarch64-darwin";
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs.legacyPackages.x86_64-linux;
      treefmtEval = treefmt-nix.lib.evalModule linuxPkgs ./treefmt.nix;
    in
    {
      formatter.x86_64-linux = treefmtEval.config.build.wrapper;
      
      # NixOS configurations
      nixosConfigurations = {
        "pc-fixe" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./pc-fixe/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.llr = import ./home-manager/home.nix;
            }
          ];
        };
        
        "pc-portable" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./pc-portable/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.llr = import ./home-manager/home.nix;
            }
          ];
        };
      };

      # Darwin configuration
      darwinConfigurations."MacBook-Pro-de-Louis" = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          {
            nixpkgs.pkgs = darwinPkgs;
            nixpkgs.hostPlatform = darwinSystem;
            
            # Basic Darwin config
            environment.systemPackages = with darwinPkgs; [
              neovim
	      fish
            ];

            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            programs.fish.enable = true;

            
            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.stateVersion = 5;

            users.users.llr = {
              name = "llr";
              home = "/Users/llr";
	      shell = darwinPkgs.fish;
	      userDefaultShell = darwinPkgs.fish;
            };
          }

          # Home Manager module
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.llr = import ./home-manager/home.nix;
            };
          }
        ];
      };
    };
}
