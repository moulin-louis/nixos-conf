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

      inherit (lib) mkNixosSystem mkDarwinSystem;
    in
    {
      nixosConfigurations = {
        "pc-fixe" = mkNixosSystem { hostname = "pc-fixe"; };
      };

      darwinConfigurations = {
        "MacBook-Pro-de-Louis" = mkDarwinSystem { hostname = "macbook"; };
      };
    };
}
