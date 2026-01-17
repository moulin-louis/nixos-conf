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

      inherit (lib) mkNixosSystem mkDarwinSystem mkHomeConfiguration;

      # Systems to generate devShells and formatters for
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      nixosConfigurations = {
        "pc-fixe" = mkNixosSystem { hostname = "pc-fixe"; };
      };

      darwinConfigurations = {
        "MacBook-Pro-de-Louis" = mkDarwinSystem { hostname = "macbook"; };
      };

      homeConfigurations = {
        "llr@ubuntu" = mkHomeConfiguration { };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "nixos-conf";
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
