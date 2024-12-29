# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.nix = {
    enable = true;
    packages = pkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    options = ["--rfc-style"];
    includes = ["*.nix"];
  };
}
