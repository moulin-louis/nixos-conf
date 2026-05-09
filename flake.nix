{
  description = "Darwin configurations";

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
      nixpkgs,
      home-manager,
      nix-darwin,
      mac-app-util,
      neovim-nightly-overlay,
      nix-index-database,
      ...
    }:
    let
      lib = import ./lib {
        inherit
          nixpkgs
          home-manager
          nix-darwin
          mac-app-util
          nix-index-database
          neovim-nightly-overlay
          ;
      };

      inherit (lib) mkDarwinSystem;

      system = "aarch64-darwin";
      forAllSystems = nixpkgs.lib.genAttrs [ system ];
    in
    {
      darwinConfigurations = {
        "MacBook-Pro-de-Louis" = mkDarwinSystem { hostname = "macbook"; };
        "Louiss-MacBook-Pro" = mkDarwinSystem {
          hostname = "louiss-macbook-pro";
          homeModule = ./hosts/louiss-macbook-pro/home.nix;
        };
      };

      formatter = forAllSystems (s: nixpkgs.legacyPackages.${s}.nixfmt);

      devShells = forAllSystems (
        s:
        let
          pkgs = nixpkgs.legacyPackages.${s};
        in
        {
          default = pkgs.mkShell {
            name = "nix-conf";
            packages = with pkgs; [
              nil
              nixfmt
              statix
              deadnix
            ];
          };
        }
      );
    };
}
